BEGIN;

DROP TYPE IF EXISTS users_type CASCADE;
CREATE TYPE users_type AS ENUM ('Student','Teacher');

DROP TABLE IF EXISTS "users" CASCADE; 
CREATE TABLE IF NOT EXISTS "users" (
    "id"                            BIGSERIAL PRIMARY KEY,
    "email"                         VARCHAR UNIQUE NOT NULL,
    "password"                      VARCHAR NOT NULL,
    "username"                      VARCHAR UNIQUE NOT NULL,
    "type"                          users_type NOT NULL,
    "first_name"                    VARCHAR NULL,
    "last_name"                     VARCHAR NULL,
    "sex"                           VARCHAR(1) NULL,
    "phone"                         VARCHAR NULL,
    "device_token"                  VARCHAR UNIQUE NOT NULL,
    "dob"                           DATE NOT NULL,
    "metadata"                      JSONB NULL,
    "is_deleted"                    BOOLEAN NOT NULL DEFAULT '0',
    "created_epoch"                 BIGINT DEFAULT EXTRACT(EPOCH FROM NOW()),
    "last_login"                    BIGINT NULL,
    "updated_user_id"               BIGINT NULL,
    "updated_epoch"                 BIGINT NULL,
    "deleted_epoch"                 BIGINT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS "indx_users_unique_lower_email" ON "users" (lower("email"));
CREATE UNIQUE INDEX IF NOT EXISTS "indx_users_unique_lower_username" ON "users" (lower("username"));

DROP INDEX IF EXISTS "indx_users_email";
CREATE INDEX IF NOT EXISTS "indx_users_email" ON "users" ("id","username","email","type");
/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/

/* relatively less data hence no index needed*/
DROP TABLE IF EXISTS "courses" CASCADE;
CREATE TABLE IF NOT EXISTS "courses" (
    "id"                           BIGSERIAL PRIMARY KEY,
    "code"                         VARCHAR UNIQUE NOT NULL,
    "name"                         VARCHAR(100),
    "total_hours"                  VARCHAR(5),
    "is_deleted"                   BOOLEAN NOT NULL DEFAULT '0',
    "created_epoch"                BIGINT NOT NULL DEFAULT extract(epoch from now()),
    "metadata"                     JSONB NULL
);

/*--------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS  "qrcode" CASCADE;
CREATE TABLE IF NOT EXISTS "qrcode" (
    "id"                         BIGSERIAL PRIMARY KEY,
    "code"                       VARCHAR UNIQUE NOT NULL,
    "lecture_id"                 BIGINT REFERENCES "lectures"(id),
    "metadata"                   JSONB NULL,
    "expiry_epoch"               BIGINT NOT NULL, --3600 seconds
    "created_user_id"            BIGINT NOT NULL REFERENCES "users"(id),
    "created_epoch"              BIGINT NOT NULL DEFAULT extract(epoch from now())
);

/*--------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS  "rooms" CASCADE; 
CREATE TABLE IF NOT EXISTS "rooms" (
    "id"                         BIGSERIAL PRIMARY KEY,
    "code"                       VARCHAR UNIQUE NOT NULL,
    "metadata"                   JSONB NULL
);

/*--------------------------------------------------------------------------------------------------------------------*/
DROP TYPE IF EXISTS lecture_status CASCADE;
CREATE TYPE lecture_status AS ENUM ('Finihsed', 'Scheduled','Cancelled','InProgress');

DROP TABLE IF EXISTS  "lectures" CASCADE; 
CREATE TABLE IF NOT EXISTS "lectures" (
    "id"                         BIGSERIAL PRIMARY KEY,
    "name"                       VARCHAR NOT NULL,
    "code"                       VARCHAR UNIQUE NOT NULL,
    "room_id"                    BIGINT NOT NULL REFERENCES "rooms"(id),
    "metadata"                   JSONB NULL,
    "status"                     lecture_status DEFAULT 'Scheduled',
    "timezone"                   VARCHAR,
    "course_id"                  BIGINT NOT NULL REFERENCES "courses"(id),
    "created_user_id"            BIGINT NOT NULL REFERENCES "users"(id),
    "start_epoch"                BIGINT NOT NULL,
    "end_epoch"                  BIGINT NOT NULL DEFAULT extract(epoch from now()) + (1* 60 * 60), --3600 seconds,
    "created_epoch"              BIGINT NOT NULL DEFAULT extract(epoch from now())
);

CREATE UNIQUE INDEX IF NOT EXISTS "indx_lectures_unique_lower_code" ON "lectures" (lower("code"));
DROP INDEX IF EXISTS "indx_lectures_id_code_name";
CREATE INDEX IF NOT EXISTS "indx_lectures_id_code_name" ON "lectures" ("id","code","name");

/* to make sure only one lecture Scheduled for XX time */
CREATE UNIQUE INDEX IF NOT EXISTS "indx_lecture_unique_room" ON "lectures" ("room_id","start_epoch");
--where start_epoch should not fall between other lectures start and end should be always after end
/*--------------------------------------------------------------------------------------------------------------------*/

DROP TYPE IF EXISTS http_method_types CASCADE;
CREATE TYPE http_method_types AS ENUM ('GET', 'POST','PUT','DELETE');

DROP TYPE IF EXISTS url_types CASCADE;
CREATE TYPE url_types AS ENUM ('UI', 'API');

DROP TABLE IF EXISTS "url_permissions" CASCADE;
CREATE TABLE IF NOT EXISTS "url_permissions" (
    "id"               BIGSERIAL PRIMARY KEY,
    "name"             VARCHAR NOT NULL,
    "type"             url_types DEFAULT 'UI',
    "prefix"           VARCHAR NULL,
    "path"             VARCHAR NOT NULL,
    "permission_group" users_type NOT NULL,
    "http_method"      http_method_types NOT NULL,
    "is_deleted"       BOOLEAN NOT NULL DEFAULT '0',
    "created_epoch"    BIGINT DEFAULT EXTRACT(EPOCH FROM NOW()),
    "updated_epoch"    BIGINT NULL,
    "deleted_epoch"    BIGINT NULL
);

DROP INDEX IF EXISTS "indx_url_permissions";
CREATE INDEX IF NOT EXISTS "indx_url_permissions_id_path_group" ON "url_permissions" ("id","path","permission_group");

DROP INDEX IF EXISTS "indx_url_permissions_type_prefix_path_group_http_method";
CREATE UNIQUE INDEX IF NOT EXISTS "indx_url_permissions_type_prefix_path_group_http_method" ON "url_permissions" ("type",lower("prefix"),lower("path"),"permission_group","http_method") where "is_deleted" = false;
/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS "attendances" CASCADE;
CREATE TABLE IF NOT EXISTS "attendances" (
    "id"               BIGSERIAL PRIMARY KEY,
    "user_id"          BIGINT NOT NULL REFERENCES "users"(id),
    "lecture_id"       BIGINT NOT NULL REFERENCES "lectures"(id),
    "present"          BOOLEAN NOT NULL DEFAULT '0',  --if student present or not
    "date"             DATE NOT NULL DEFAULT CURRENT_DATE,
    "is_deleted"       BOOLEAN NOT NULL DEFAULT '0',
    "created_epoch"    BIGINT DEFAULT EXTRACT(EPOCH FROM NOW()),
    "deleted_epoch"    BIGINT NULL
);

CREATE INDEX IF NOT EXISTS "indx_attendances_id_code_name" ON "attendances" ("id","user_id","lecture_id","date");

/* to make sure only one attendace per student per lecture on day */
CREATE UNIQUE INDEX IF NOT EXISTS "indx_attendances_unique_lecture_date" ON "attendances" ("date","user_id","lecture_id");

/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/

DROP TABLE IF EXISTS "student_courses" CASCADE;
CREATE TABLE IF NOT EXISTS "student_courses" (
    "id"               BIGSERIAL PRIMARY KEY,
    "user_id"          BIGINT NULL REFERENCES "users"(id),
    "course_id"        BIGINT NULL REFERENCES "courses"(id)
);

/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS "teacher_courses" CASCADE;
CREATE TABLE IF NOT EXISTS "teacher_courses" (
    "id"               BIGSERIAL PRIMARY KEY,
    "user_id"          BIGINT NULL REFERENCES "users"(id),
    "course_id"        BIGINT NULL REFERENCES "courses"(id)
);

/* Create a table in your database for sessions */
DROP TABLE IF EXISTS "sessions" CASCADE;
CREATE TABLE IF NOT EXISTS "sessions" (
    id              BIGSERIAL PRIMARY KEY,
    sess_id         TEXT,
    session_data    TEXT,
    expires         TEXT
);


COMMIT;



--------------------------------
/*
 Require Data section
*/
--------------------------------

BEGIN;

--insert needed data
INSERT INTO public.courses (code, name, total_hours)
VALUES('CS-101', 'Computer Science', '80'),
      ('CS-102', 'Machine Learning', '60'),
      ('DS-100', 'Data Science', '70'),
      ('CS-202', 'Artificial Intelligence', '50');

-- Data for ROOMS
INSERT INTO public.rooms (code,metadata)
VALUES ('R-101','{"type":"single room","projector":true}'::JSONB),
       ('R-102','{"type":"single room","projector":true}'::JSONB),
       ('R-201','{"type":"computer room","projector":true}'::JSONB),
       ('R-202','{"type":"Double room","projector":false}'::JSONB),
       ('R-500','{"type":"Hall room","projector":true}'::JSONB),
       ('R-301','{"type":"single room","projector":true}'::JSONB);

COMMIT;