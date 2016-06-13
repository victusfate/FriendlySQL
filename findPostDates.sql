SELECT posts.post_id, posts.post_date, posts.post_date_updated
FROM posts
LEFT OUTER JOIN user_posts
ON user_posts.post_id = posts.post_id
WHERE user_posts.montage_id = 561
