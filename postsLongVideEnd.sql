select user_posts.post_id, posts.file_hash, files.file_length_ms, user_posts.post_video_end * 1000
from user_posts
left outer join posts
on user_posts.post_id = posts.post_id
left outer join files
on posts.file_hash = files.file_hash
where (user_posts.post_video_end * 1000) > (files.file_length_ms + 1)
