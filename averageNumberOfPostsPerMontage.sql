set @d1 = '2013-05-17';
set @d2 = '2013-06-01';
SELECT AVG(postCount)
FROM (
	SELECT 
		montages.montage_id AS montageID,
		user_posts.post_id AS postID,
		COUNT(user_posts.post_id) AS postCount
	FROM montages
	LEFT OUTER JOIN user_posts
	ON user_posts.montage_id = montages.montage_id
	WHERE montages.montage_date_end >= @d1 and montages.montage_date_end < @d2
	AND montages.montage_status = 'Shared'
	AND user_posts.post_status = 'Montage'
	GROUP BY user_posts.montage_id
	) iTable