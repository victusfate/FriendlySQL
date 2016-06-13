SELECT files.file_hash_processed
FROM posts
LEFT OUTER JOIN files
ON posts.file_hash = files.file_hash
LEFT OUTER JOIN user_posts
ON posts.post_id = user_posts.post_id
WHERE user_posts.montage_id = 419
