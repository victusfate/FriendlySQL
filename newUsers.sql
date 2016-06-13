select
	count(*)
from users
where users.current_montage_id is not NULL
and users.user_date_added > CURRENT_TIMESTAMP - INTERVAL 1 DAY
