set @d1 = '2013-10-05';
set @d2 = '2013-10-17';
select
	avg(sumDurationMS/1000) AS contentDurationSec
from(
	select
		SUM(files.file_length_ms) AS sumDurationMS
	from builds
	left outer join build_files
	on builds.build_id = build_files.build_id
	left outer join files
	on build_files.file_hash = files.file_hash
	where builds.build_date_finished > @d1 and builds.build_date_finished < @d2
	and builds.build_montage_status = 'In Progress'
	and build_files.build_bitrate = '1264000'
	group by builds.build_id
) iTable