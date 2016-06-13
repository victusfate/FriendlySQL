set @d1 = '2013-05-31';
set @d2 = '2013-06-09';

SELECT 
	AVG(DATEDIFF(montage_date_updated, montage_date_start)),
	COUNT(*) as total
FROM montages
WHERE montage_status = 'In Progress'
AND montages.montage_date_updated >= @d1 and montages.montage_date_updated < @d2

