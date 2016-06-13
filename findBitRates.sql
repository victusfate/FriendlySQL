SELECT build_files.build_bitrate, files.file_bit_rate, build_files.file_hash
FROM build_files
LEFT OUTER JOIN files
ON build_files.file_hash = files.file_hash 
WHERE build_files.build_id = 19781 
AND build_files.build_bitrate = 1264000