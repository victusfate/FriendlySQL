set @d1 = '2013-05-17';
set @d2 = '2013-06-06';
SELECT 
	AVG(castSize) AS averageCastSize 
FROM ( 
	SELECT COUNT(*) AS castSize
	FROM casts 
	WHERE casts.cast_status != 'Expired' 
	AND casts.cast_status != 'Denied'
	AND casts.cast_date_added > @d1 AND casts.cast_date_updated < @d2
	GROUP BY casts.montage_id
) iTable
WHERE castSize > 1