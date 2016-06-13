select
	files.*
from files
left outer join posts
on files.file_hash = posts.file_hash
left outer join user_posts
on posts.post_id = user_posts.post_id
left outer join users
on user_posts.user_id = users.user_id
where user_posts.montage_id = '204530'