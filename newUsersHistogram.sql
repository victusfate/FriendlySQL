select
	concat(YEAR(users.user_date_added),'-',MONTH(users.user_date_added),'-',DAY(users.user_date_added),':',HOUR(users.user_date_added),':00') as userTime,
	count(*) as usersAddedPerInterval
from users
where users.current_montage_id is not NULL
and users.user_date_added > CURRENT_TIMESTAMP - INTERVAL 14 DAY
group by DAY(users.user_date_added),HOUR(users.user_date_added)
order by users.user_date_added
