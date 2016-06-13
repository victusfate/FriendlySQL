set @d1 = '2013-10-09';
select
	*
from posts
left outer join files
on posts.file_hash = files.file_hash
where posts.post_date_updated >= @d1
and files.file_hash_processed is NULL