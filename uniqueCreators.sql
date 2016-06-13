set @d1 = '2013-10-24';
set @d2 = '2013-11-05';
set @VideosCreated = 1;

SELECT 
COUNT(*)
FROM (
	SELECT COUNT(*) AS videosCreated
	FROM montages
	WHERE montages.montage_status = 'Shared'
	AND montages.montage_date_updated >= @d1 and montages.montage_date_updated < @d2
	GROUP BY montages.user_id
) iTable
WHERE videosCreated = @VideosCreated

