set @d1 = '2013-05-17';
set @d2 = '2013-06-01';
SELECT AVG(likeCount)
FROM (
	SELECT 
		COUNT(*) AS likeCount
	FROM likes
	LEFT OUTER JOIN montages
	ON likes.montage_id = montages.montage_id
	WHERE montages.montage_date_end >= @d1 and montages.montage_date_end < @d2
	GROUP BY likes.montage_id
	) iTable