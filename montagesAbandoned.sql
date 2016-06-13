set @d1 = '2013-05-01';
set @d2 = '2013-06-09';
set @abandoned = 14;

SELECT COUNT(*)
FROM montages
WHERE montage_status = 'In Progress'
AND DATEDIFF(CURRENT_DATE, montage_date_updated) > @abandoned
AND montages.montage_date_start >= @d1 and montages.montage_date_start < @d2
