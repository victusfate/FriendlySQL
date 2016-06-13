set @d1 = '2013-05-01';
set @d2 = '2013-06-09';

SELECT 
	COUNT(*)
FROM montages
WHERE montage_status = 'In Progress'
AND montages.montage_date_updated >= @d1 and montages.montage_date_updated < @d2
