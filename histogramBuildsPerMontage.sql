set @d1 = '2013-10-05';
set @d2 = '2013-10-07';


select
 	concat(YEAR(builds.build_date_finished),'-',MONTH(builds.build_date_finished),'-',DAY(builds.build_date_finished),':',HOUR(builds.build_date_finished),':',FLOOR(MINUTE(builds.build_date_finished)/10)*10) as buildTime,
	count(*) as buildsPerInterval
from builds
where builds.build_date_started >= @d1 and builds.build_date_started < @d2
and builds.build_montage_status = 'In Progress' 
and TIMEDIFF(builds.build_date_finished, builds.build_date_started) < '01:00:00'
group by DAY(builds.build_date_finished),HOUR(builds.build_date_finished),FLOOR(MINUTE(builds.build_date_finished)/10)
order by builds.build_date_finished

