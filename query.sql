SELECT posts.file_hash 
FROM user_posts 
LEFT OUTER JOIN posts 
ON user_posts.post_id = posts.post_id 
WHERE user_posts.montage_id = 388
