set @d1 = '2013-10-09';
set @d2 = '2013-10-25';

select
	aDate,
	avg(buildsPerMontage) as averageBuildsPerMontage,
	sum(buildsPerMontage) as totalBuilds
from(
	select 
		count(*) as buildsPerMontage,
		concat(YEAR(builds.build_date_started),'-',MONTH(builds.build_date_started),'-',DAY(builds.build_date_started)) as aDate,
		DAY(builds.build_date_started) as aDay	
	from builds
	left outer join montages
	on builds.montage_id = montages.montage_id
	where builds.build_date_started >= @d1 and builds.build_date_started < @d2
	and montages.montage_status = 'Shared'
	group by montages.montage_id
) iTable
group by aDate
order by aDay