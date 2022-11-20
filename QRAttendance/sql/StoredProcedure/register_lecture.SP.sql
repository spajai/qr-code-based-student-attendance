    -- **************************************************************************************
-- Function : register_lecture
-- Desc     : This SP is used register_lecture
-- Params   : params json
-- Returns  : "insert_data"::JSON
-- **************************************************************************************

DROP FUNCTION IF EXISTS register_lecture(params json);
CREATE OR REPLACE FUNCTION "register_lecture"(params JSON)
RETURNS JSON AS $$
DECLARE

--input var
    user_id                   BIGINT;
    lecture_code              VARCHAR;
    course_code               VARCHAR;
    room_code                 VARCHAR;
    name                      VARCHAR;
    start_timestamp           TIMESTAMP;

--sp variable
    lecture_id      BIGINT;
    course_id       BIGINT;
    room_id         BIGINT;
    result          JSONB;
    query           TEXT;
    is_room_free    INTEGER;
    is_teacher      BOOLEAN DEFAULT FALSE;
    uuid4           VARCHAR;
    inp_start_epoch BIGINT;
    inp_end_epoch   BIGINT;

-- error variables
    e_state                         TEXT;
    e_msg                           TEXT;
    e_schema                        TEXT;
    e_table                         TEXT;
    e_column                        TEXT;
    e_dt_type                       TEXT;
    e_constr                        TEXT;
    e_detail                        TEXT;
    e_hint                          TEXT;
    e_context                       TEXT;

BEGIN
/*
**********************************************************
    Lets Extract everything from json
*********************************************************
*/
RAISE NOTICE 'register_lecture Reqeust Params %', jsonb_pretty(params::jsonb);

user_id               := (params->>'user_id')::BIGINT;
lecture_code         := (params->>'lecture_code')::VARCHAR;
course_code           := (params->>'course_code')::VARCHAR;
room_code             := (params->>'room_code')::VARCHAR;
name                  := (params->>'name')::VARCHAR;
start_timestamp       := (params->>'start_timestamp')::TIMESTAMP;

/*
**********************************************************
    Check mandatory values present
*********************************************************
*/
    IF
        lecture_code IS NULL
    OR user_id IS NULL
    OR room_code IS NULL
    OR course_code IS NULL
    OR name IS NULL
    THEN
        RAISE EXCEPTION 'Register lecture request error either of field from list is null params = %', jsonb_pretty(params::jsonb)
        USING HINT = 'Please check the user_id lecture_code course_code room_code name start_timestamp';
    END IF;

/*
**********************************************************
    Check if user is teacher
*********************************************************
*/

    select 
        true into is_teacher 
    from 
        users u
    where 
        u.id = user_id
    and 
        u.type = 'Teacher'
    and 
        u.is_deleted is FALSE;

    IF
        is_teacher IS NULL
    THEN
        RAISE EXCEPTION 'User is not Teacher %',user_id
        USING HINT = 'Only User type teacher allowed to schedule the lecture';
    END IF;


/*
**********************************************************
    Check if room available and free for lecture
*********************************************************
*/

    inp_start_epoch := EXTRACT(EPOCH FROM start_timestamp::timestamp)::INT;
    inp_end_epoch := inp_start_epoch + (1 * 60 * 60); --always 1 hour

    select into
        is_room_free
        count(*)
    from 
        lectures l
    join 
        rooms r on r.id = l.room_id
    where 
        r.code = room_code
    and 
        inp_start_epoch BETWEEN l.start_epoch AND l.end_epoch
        ;

    IF
        is_room_free > 0
    THEN
        RAISE EXCEPTION 'Room % Not available at given time = % or invalid room code',room_code, start_timestamp
        USING HINT = 'Please use the different time or check room code';
    END IF;
/*
**********************************************************
    Check course id
*********************************************************
*/

    select 
        c.id into course_id 
    from 
        courses c
    where 
        c.code = course_code
    and 
        is_deleted is FALSE;

    IF
        course_id IS NULL
    THEN
        RAISE EXCEPTION 'Course code % Not available',course_code
        USING HINT = 'Please check Course code';
    END IF;

/*
**********************************************************
    Check room id
*********************************************************
*/

    select 
        r.id into room_id 
    from 
        rooms r
    where 
        r.code = room_code;

    IF
        room_id IS NULL
    THEN
        RAISE EXCEPTION 'Room code % Not valid',room_code
        USING HINT = 'Please check Room code';
    END IF;


/*
**********************************************************
    Genereate uuid4
*********************************************************
*/
    SELECT uuid_in(overlay(overlay(md5(random()::text || ':' || random()::text) placing '4' from 13) placing to_hex(floor(random()*(11-8+1) + 8)::int)::text from 17)::cstring) into uuid4;
/*
**********************************************************
    build and execute actual query
*********************************************************
*/
    query := 'WITH inserted_lecture AS (
        INSERT INTO "lectures" (
            name,                            --$1
            code,                            --$2
            room_id,                         --$3
            course_id,                       --$4
            created_user_id,                 --$5
            start_epoch,                     --$6
            end_epoch                        --$7
        )
        VALUES(
            $1,                           --name
            $2,                           --code
            $3,                           --room_id
            $4,                           --course_id
            $5,                           --created_user_id
            $6,                           --start_epoch
            $7                            --end_epoch
        )
        RETURNING lectures.id,start_epoch
    ), generate_qr as  (
        INSERT INTO qrcode (
            code,                          --$8
            expiry_epoch,                  --$9,
            created_user_id,               --$10
            lecture_id
        )
        VALUES (
            $8,                             --code
            $9,                             --expiry_epoch
            $10,                            --created_user_id
            (SELECT id from inserted_lecture)
        )
        RETURNING code as qr_code,id
    ), pre_fill_attendance as (
        INSERT INTO attendances (
            "user_id",
            "lecture_id",
            "date"
        )
        select 
            u.id as user_id,
            (SELECT id from inserted_lecture) as lecture_id,
            (select to_timestamp('||inp_start_epoch||')::date) as date
        from 
            users u
        join student_courses sc on sc.user_id = u.id 
        join courses c on c.id = sc.course_id and c.id = ('||course_id||')
        where type = ''Student''
        ON CONFLICT DO NOTHING
        RETURNING id
    )
     SELECT
        json_build_object(
            ''inserted_lecture_id'',  (SELECT id from inserted_lecture),
            ''qr_code'',              (SELECT qr_code from generate_qr),
            ''qr_id'',                (SELECT id from generate_qr),
            ''attendance_ids'',       (SELECT array_agg (distinct(id)) from pre_fill_attendance)
        ) AS result
    ';

    EXECUTE query INTO result USING
        name,                         --$1
        lecture_code,                --$2
        room_id,                      --$3
        course_id,                    --$4
        user_id,                      --$5
        inp_start_epoch,              --$6
        inp_end_epoch,                --$7
        uuid4,                        --$8
        inp_end_epoch,                --$9
        user_id;                      --$10
    RETURN result;

        EXCEPTION
        WHEN OTHERS THEN
        get stacked diagnostics
            e_state   = RETURNED_SQLSTATE,
            e_msg     = MESSAGE_TEXT,
            e_schema  = SCHEMA_NAME,
            e_table   = TABLE_NAME,
            e_column  = COLUMN_NAME,
            e_dt_type = PG_DATATYPE_NAME,
            e_constr  = CONSTRAINT_NAME,
            e_detail  = PG_EXCEPTION_DETAIL,
            e_hint    = PG_EXCEPTION_HINT,
            e_context = PG_EXCEPTION_CONTEXT;

         RAISE Exception 'Got exception:
            state  : %
            message: %
            schema : %
            table  : %
            column : %
            dt_type: %
            constraint: %
            detail : %
            hint   : %
            context: %
            SQLSTATE: %
            SQLERRM: %
            register_conference_call_role_SP: %
            query : %', e_state, e_msg, e_schema, e_table, e_column, e_dt_type, e_constr, e_detail, e_hint, e_context,SQLSTATE,SQLERRM,params, query;

END;
$$ LANGUAGE plpgsql;

/**************************
**************************/
-- select * from register_lecture('{"name" : "Fundamental of CS", "lecture_code" : "L-CS02",     "room_code": "R-102",     "course_code": "CS-101",     "user_id": 7,     "start_timestamp": "12-12-2022 01:00:00" }');