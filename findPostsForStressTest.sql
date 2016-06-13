SELECT DISTINCT parents.file_hash
FROM user_posts
LEFT OUTER JOIN posts
ON user_posts.post_id = posts.post_id
LEFT OUTER JOIN files AS parents
ON posts.file_hash = parents.file_hash
LEFT OUTER JOIN files AS processed
ON parents.file_hash_processed = processed.file_hash
WHERE posts.file_hash is not NULL
AND processed.file_hash is not NULL
AND processed.file_type = "Video"
AND processed.file_width = 1280
AND processed.file_height = 720
