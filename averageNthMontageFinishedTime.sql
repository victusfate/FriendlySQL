set @d1 = '2013-04-01';
set @d2 = '2013-07-29';

SELECT 
	users.username AS userName,
	montages.user_id AS userID, 
	montages.montage_id AS montageID, 
	TIMEDIFF( montages.montage_date_end , montages.montage_date_start) AS buildTime,
	montages.montage_date_start AS startDate,
	montages.montage_date_end AS endDate,
	users.user_date_added AS userAdded
FROM users
LEFT OUTER JOIN montages
ON montages.user_id = users.user_id
WHERE montage_status = 'Shared'
AND users.user_date_added >= @d1 and users.user_date_added < @d2
ORDER BY users.user_id,montages.montage_id



/*
-- too fancy
-- work in progress
-- references
-- http://stackoverflow.com/questions/14857159/mysql-difference-between-two-rows-of-a-select-statement
-- http://sqlfiddle.com/#!2/b9eb1/8
-- http://sqlfiddle.com/#!2/500db/4

set @d1 = '2013-04-01';
set @d2 = '2013-07-29';
set @n 	= 1;

SELECT *
FROM (
	SELECT 
		users.username AS userName,
		montages.user_id AS userID, 
		montages.montage_id AS montageID, 
		TIMEDIFF( montages.montage_date_end , montages.montage_date_start) AS buildTime,
		montages.montage_date_start AS startDate,
		montages.montage_date_end AS endDate,
		users.user_date_added AS userAdded
	FROM users
	LEFT OUTER JOIN montages
	ON montages.user_id = users.user_id
	WHERE montage_status = 'Shared'
	AND users.user_date_added >= @d1 and users.user_date_added < @d2
	ORDER BY users.user_id,montages.montage_id
) iTable
WHERE (
	SELECT COUNT(*) from iTable as i
	i.montage_date_end < montages.montage_date_end
) == @n;

*/
