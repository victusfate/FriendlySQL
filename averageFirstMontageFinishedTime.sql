set @d1 = '2013-04-01';
set @d2 = '2013-07-29';

SELECT 
	users.username,
	montages.user_id AS userID, 
	montages.montage_id AS montageID, 
	TIMEDIFF( montages.montage_date_end , users.user_date_added) AS firstBuildTime,
	montages.montage_date_end AS endDate,
	users.user_date_added AS userAdded
FROM users
LEFT OUTER JOIN montages
ON montages.user_id = users.user_id
WHERE montage_status = 'Shared'
AND users.user_date_added >= @d1 and users.user_date_added < @d2
GROUP BY users.user_id
ORDER BY montages.montage_id




