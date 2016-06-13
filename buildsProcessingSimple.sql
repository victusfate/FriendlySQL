select
	*
from builds
where builds.build_date_started > CURRENT_TIMESTAMP - INTERVAL 1 HOUR
and build_status = 'Processing'