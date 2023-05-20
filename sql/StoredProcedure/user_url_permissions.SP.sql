-- **************************************************************************************
-- Function : user_url_permissions
-- Desc     : This SP is used user_url_permissions
-- Params   : user_id BIGINT
-- Returns  : "user_url_permissions"::JSON
-- **************************************************************************************
CREATE OR REPLACE FUNCTION "user_url_permissions"(inp_user_id BIGINT)
RETURNS JSON AS $$
DECLARE

    result      JSON;

BEGIN

    SELECT
        json_agg(row_to_json (sq)) INTO result AS user_url_permissions
    FROM (
         SELECT
            array_agg(url_type_permissions_str) AS url_type_permissions
        FROM (
            SELECT
                concat (u.type,'#',urp.type,'#',http_method,'#', prefix, path) AS url_type_permissions_str,
                u.id
            FROM
                users u
            JOIN
                url_permissions urp 
            ON
                u.type = urp.permission_group AND urp.is_deleted IS FALSE
            WHERE u.id = inp_user_id AND u.is_deleted IS FALSE
        ) sq
    ) sq;

    RETURN result;

END;
$$ LANGUAGE plpgsql;