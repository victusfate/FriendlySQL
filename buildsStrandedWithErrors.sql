SELECT 
   montages.montage_id, 
   montages.montage_status,
   montages.build_id AS montage_build_id,
   COUNT(user_posts.post_id) AS post_count,
   builds.build_id,
   builds.build_status,
   TIMESTAMPDIFF(SECOND, builds.build_date_started, NOW()) AS seconds_since_started,
   montages.soundtrack_file_hash,
   files.file_status,
   users.user_id,
   users.username,
   users.user_email,
   montages.montage_title
FROM montages
LEFT OUTER JOIN files ON montages.soundtrack_file_hash = files.file_hash
LEFT OUTER JOIN users ON montages.user_id = users.user_id
LEFT OUTER JOIN user_posts ON montages.montage_id = user_posts.montage_id
LEFT OUTER JOIN builds ON montages.montage_id = builds.montage_id AND builds.build_id =  (
   SELECT MAX(build_id) FROM builds WHERE builds.montage_id = montages.montage_id LIMIT 1
)
WHERE montages.montage_id > 4500
AND 
   (
      (  montages.montage_status NOT IN ("New", "Archived", "Shared")
         AND builds.build_status != "Processed"
         AND user_posts.post_status = "Montage"
      )  
      OR 
      montages.montage_status = "Finished"
   )
GROUP BY montages.montage_id
HAVING seconds_since_started > 300 AND post_count > 0
ORDER BY file_status;