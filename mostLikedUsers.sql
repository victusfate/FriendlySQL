select
u.username,
count(*) as likeCount
from likes as l
left outer join montages as m
on l.montage_id = m.montage_id
left outer join users as u
on m.user_id = u.user_id
where m.montage_status = 'shared'
and l.like_it = 'Yes'
group by u.user_id
order by likeCount desc
limit 50
