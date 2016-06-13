set @d1 = '2013-06-05';
set @d2 = '2013-06-06';
SELECT COUNT(*)
FROM builds
WHERE builds.build_date_started between @d1 AND @d2
-- WHERE build_date_started between DATE(NOW()-INTERVAL 1 DAY) AND DATE(NOW()) 
-- WHERE build_date_started between CURRENT_DATE - INTERVAL 1 DAY AND CURRENT_DATE 
AND (builds.build_status = 'Pending')