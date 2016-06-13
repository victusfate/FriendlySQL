SELECT posts.file_hash
FROM user_posts
LEFT OUTER JOIN posts
ON user_posts.post_id = posts.post_id
AND user_posts.user_id = 7753
WHERE posts.file_hash is not NULL
