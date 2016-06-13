select
	userID,
	followers
from (
	select
		follows.user_id as userID,
		count(follows.follower_id) as followers
	from follows
	group by user_id
) iTable
where followers between 50 AND 99
order by followers desc
