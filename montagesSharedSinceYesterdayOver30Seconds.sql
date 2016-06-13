SELECT 	m.`montage_id` AS 'Montage Id',  
	   	u.`username` AS 'User', 
	   	m.`montage_title` AS 'Title', 
	   	f.`file_length_ms`/1000 AS 'Video Length (sec)', 
	   	u.`user_date_added` AS 'User Since' 
FROM montages m
INNER JOIN files f
INNER JOIN users u
where f.file_hash = m.montage_file_hash_mp4 
AND m.`user_id` = u.user_id
AND m.montage_date_updated > subdate(current_date, 1) 
AND m.montage_status = 'Shared'
AND f.`file_length_ms`> 30000 
LIMIT 1000