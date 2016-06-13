set @d1 = '2013-05-17';
set @d2 = '2013-06-01';
SELECT 
	AVG(files.file_length_ms)/1000
FROM montages
LEFT OUTER JOIN files
ON montages.montage_file_hash_mp4 = files.file_hash
WHERE montages.montage_date_end >= @d1 and montages.montage_date_end < @d2
AND montages.montage_status = 'Shared'
