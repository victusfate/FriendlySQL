set @d1 = '2013-10-09';

select
	mstatus,
	sum(good) as sum
from ( 
	select
		montages.montage_status as mstatus,
	    count(*) >= 3 as good
	from montages
	left outer join user_posts
	on montages.montage_id = user_posts.montage_id
	where montages.montage_date_start >= @d1
	group by montages.montage_id
) iTable
group by mstatus