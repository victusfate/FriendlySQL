select
	count(distinct u.user_id)
from follows f1
left outer join users u
on f1.user_id = u.user_id
left outer join follows f2
on f2.follower_id = u.user_id

