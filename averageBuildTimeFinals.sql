set @d1 = '2013-09-20';
set @d2 = '2013-09-21';
SELECT 
-- 	AVG(buildTimeSec * 1000 / sumDurationMS) AS averageNormalizedScaleFactor,
	MIN(buildTimeSec) AS minimum,
	MAX(buildTimeSec) AS maximum,
	AVG(buildTimeSec) AS averageBuildTimeSec,
	AVG(sumDurationMS/1000) AS contentDurationSec
FROM(
	SELECT 
	  builds.build_id AS buildID,
	  TIME_TO_SEC(TIMEDIFF(builds.build_date_finished, builds.build_date_started)) AS buildTimeSec,
	  SUM(files.file_length_ms) AS sumDurationMS
	FROM builds
	LEFT OUTER JOIN build_files
	on build_files.build_id = builds.build_id
	LEFT OUTER JOIN files
	on build_files.file_hash = files.file_hash
	WHERE builds.build_date_started >= @d1 and builds.build_date_started < @d2
	AND (builds.build_montage_status = 'Finished' OR builds.build_montage_status = 'Shared')
	AND TIMEDIFF(builds.build_date_finished, builds.build_date_started) < '01:00:00'
	AND build_files.build_bitrate = '1264000'
	GROUP BY buildID
) iTable
