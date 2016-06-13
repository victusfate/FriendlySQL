set @d1 = '2013-10-09';
set @d2 = '2014-10-24';

SELECT COUNT(*)
FROM montages
WHERE montages.montage_date_start >= @d1 and montages.montage_date_start < @d2
