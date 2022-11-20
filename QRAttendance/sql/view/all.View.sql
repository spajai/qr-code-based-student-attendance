create view active_teachers as (
	select * from users where type = 'Teacher' and is_deleted is false
);


create  view  active_students as (
	select * from users  where type = 'Student' and is_deleted is false 
);

drop view if exists qr_data_vw;
create  view qr_data_vw as (
with absent_data as (
	select
		array_agg(concat(u.first_name,' ', u.last_name)) as all_absent_student,
		count(*) total_absent
		from qrcode qr join attendances a on qr.lecture_id = a.lecture_id join users u on u.id = a.user_id
		where present is false
	), present_data as (
		select
			array_agg(concat(u.first_name,' ', u.last_name)) as all_present_student,
			count(*) total_present
		from qrcode qr join attendances a on qr.lecture_id = a.lecture_id join users u on u.id = a.user_id
		where present is true
	), qr_data as (
		select row_to_json(row) as qr_info,
		--(array_agg(row.qr_code))[1] as qr_code
		row.qr_code as qr_code
		from (
			select
			qr.code as qr_code,
			to_timestamp(qr.expiry_epoch)::timestamp as qr_code_validity,
			l.name as lecture_name,
			l.code as lecture_code,
			l.status as lecture_status,
			to_timestamp(l.start_epoch)::timestamp as lecture_start_date,
			to_timestamp(l.end_epoch)::timestamp as lecture_end_date,
			r.code as room_code,
			c.name as course_name,
			c.code as course_code,
			concat_ws(t.first_name,t.last_name) as teacher_name,
			qr.lecture_id as lecture_id
			from 
			qrcode qr
			join lectures l on qr.lecture_id = l.id
			left join rooms r on l.room_id = r.id
			left join courses c on l.course_id = c.id
			left join teacher_courses tc on tc.course_id = c.id
			left join users t on tc.user_id = t.id
		) row
		GROUP by row.*,qr_code
	) select json_build_object(
		'all_absent_student',  (select all_absent_student  from absent_data),
		'total_absent',        (SELECT total_absent from absent_data),
		'all_present_student', (SELECT all_present_student from present_data),
		'total_present',       (SELECT total_present from present_data),
		'qr_data',			  (SELECT qr_info from qr_data)
	) AS result, q.qr_code
	from qr_data q

);