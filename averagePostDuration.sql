set @d1 = '2013-05-17';
set @d2 = '2013-06-01';
SELECT AVG(TIMEDIFF(user_posts.post_video_end,user_posts.post_video_start))
FROM user_posts
WHERE user_posts.post_video_end > 0
AND post_status_updated >= @d1 and post_status_updated < @d2
