SELECT 
  AVG( TIME_TO_SEC(TIMEDIFF(builds.build_date_finished, builds.build_date_started)) ) AS buildTimeSec
FROM builds
WHERE builds.build_date_started >= CURRENT_TIMESTAMP - INTERVAL 10 MINUTE
AND builds.build_montage_status = 'In Progress'
AND builds.build_status = 'Processed'
AND builds.build_date_finished is not NULL 
