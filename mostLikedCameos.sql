select
	concat('http://cameo.tv/c/', montage_hash) as 'URL', montage_date_updated AS 'Shared', m.montage_id, m.montage_title, count(*) as likeCount
from likes as l
left outer join montages as m
on l.montage_id = m.montage_id
where m.montage_status = 'shared'
and l.like_it = 'Yes'
and m.montage_date_updated > CURRENT_TIMESTAMP - INTERVAL 1 DAY
group by l.montage_id
order by likeCount desc
limit 50
