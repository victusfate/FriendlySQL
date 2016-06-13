set @d1 = '2013-05-17';
set @d2 = '2013-06-01';
SELECT AVG(commentCount)
FROM (
	SELECT 
		COUNT(*) AS commentCount
	FROM comments
	WHERE comment_date_added >= @d1 and comment_date_added < @d2
	GROUP BY montage_id
	) iTable