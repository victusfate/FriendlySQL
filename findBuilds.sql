SELECT builds.build_id, montages.montage_file_hash_mp4
FROM builds 
LEFT OUTER JOIN montages
ON builds.montage_id = montages.montage_id
WHERE builds.build_status = "PROCESSED"
AND builds.montage_id = 200 


-- SELECT builds.build_id
-- FROM builds 
-- WHERE builds.build_status = "PROCESSED"
-- AND builds.montage_id = 200 

