set @d1 = '2013-10-17';
set @d2 = '2013-10-24';

SELECT montage_status, COUNT(*)
FROM montages
where montages.montage_date_updated >= @d1 and montages.montage_date_updated < @d2
group by montage_status