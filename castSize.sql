set @d1 = '2013-10-24';
set @d2 = '2014-11-05';
SELECT 
	count(distinct montageID) AS numCameos
FROM ( 
	select 
		count(c.montage_id) as castSize,
		c.montage_id as montageID
	from montages m
	left outer join casts c
	on m.montage_id = c.montage_id
	where m.montage_date_start >= @d1
	and m.montage_date_start < @d2
	and c.cast_status != 'Expired' 
	and c.cast_status != 'Denied'
	group by c.montage_id
) iTable
where castSize = 4