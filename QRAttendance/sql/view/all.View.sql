create view active_teachers as (
	select * from users where type = 'Teacher' and is_deleted is false
);


create  view  active_students as (
	select * from users  where type = 'Student' and is_deleted is false 
);
