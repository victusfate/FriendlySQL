select
	count(followerID)
from (
	select
		follows.follower_id as followerID,
		count(follows.user_id) as follows
	from follows
	group by follower_id
) iTable
where follows between 10 AND 49
order by follows desc

