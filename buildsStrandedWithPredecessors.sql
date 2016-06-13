select
	b1.build_id,
	b1.build_date_started,
	b2.build_id,
	b2.build_status,
	b2.build_date_started, 
	b2.build_date_started > b1.build_date_started AND b2.build_status = 'Processed' as predecessorGood
from builds as b1
left outer join builds as b2
on b1.montage_id = b2.montage_id
where b1.build_date_started > CURRENT_TIMESTAMP - INTERVAL 1 HOUR
and b1.build_status = 'Processing'
and b2.build_date_started > b1.build_date_started