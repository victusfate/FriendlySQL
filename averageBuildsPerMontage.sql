set @d1 = '2013-10-09';
SELECT 
	avg(buildsPerMontage) as averageBuildsPerMontage,
	sum(buildsPerMontage) as totalBuilds
FROM(
	select count(*) as buildsPerMontage
	from builds
	left outer join montages
	on builds.montage_id = montages.montage_id
	where builds.build_date_started >= @d1
	and (montages.montage_status = 'Finished' or montages.montage_status = 'Shared')
	group by montages.montage_id
) iTable