SELECT user_posts.post_id, user_posts.post_video_start, user_posts.post_video_end, posts.file_hash, user_posts.post_status
FROM user_posts
LEFT OUTER JOIN posts
ON user_posts.post_id = posts.post_id
WHERE user_posts.montage_id = 1862
