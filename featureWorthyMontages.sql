SET @minLength = 25000;
SET @maxLength = 100000; -- max length 1:40
SET @hours = 12;
-- no reflection or 8mm
-- 8mm: 744dbcae93dfe5e5516994bdcba421981aeaf336
-- reflection: 79de079587a755ba26c05285da3e168fef490a5a

-- To Prep for Github Markdown output when querying in mysql client, replace pluses with pipes
-- |  Id	|	URL	|	Shared	|	Seconds	|	Post	|	Build	|	Likes	|	Comments	|
-- |  -----  |	-----	|	-----	|	-----	|	-----	|	-----	|	-----	|	-----	|

SELECT 
    '|',
        m.montage_id AS Id, 
    '|',
    concat('[![', montage_title, '](http://api.cameo.tv/file/', montage_file_hash_title_animation, ')](http://cameo.tv/c/', montage_hash, ')') AS Thumb, 
    '|',
    DATE_FORMAT(CONVERT_TZ(montage_date_updated,'+00:00','-04:00'), "%l:%i%p") AS Shared,
    '|',
    ROUND(f.file_length_ms/1000, 2) AS Seconds, 
    '|',
    COUNT(DISTINCT p.post_id) AS Post,
    '|',
    COUNT(DISTINCT b.build_id) AS Build,
    '|',
    COUNT(DISTINCT lYes.like_id) AS Likes,
    '|',
    COUNT(DISTINCT c.comment_id) AS Com,
    '|'
FROM montages m
LEFT OUTER JOIN files f ON m.montage_file_hash_mp4 = f.file_hash
LEFT OUTER JOIN channel_montages cm ON m.montage_id = cm.montage_id AND cm.channel_id = 1
LEFT OUTER JOIN builds b ON m.montage_id = b.montage_id
LEFT OUTER JOIN user_posts p ON m.montage_id = p.montage_id
LEFT OUTER JOIN likes lYes ON m.montage_id = lYes.montage_id AND lYes.like_it = 'Yes'
LEFT OUTER JOIN comments c ON m.montage_id = c.montage_id
WHERE montage_status = 'Shared' 
AND m.montage_date_updated > CURRENT_TIMESTAMP - INTERVAL @hours HOUR
AND f.file_length_ms > @minLength
AND f.file_length_ms < @maxLength
AND m.theme_hash <> '744dbcae93dfe5e5516994bdcba421981aeaf336' 
AND m.theme_hash <> '79de079587a755ba26c05285da3e168fef490a5a' 
AND cm.montage_id IS NULL
GROUP BY m.montage_id
HAVING Build > Post
ORDER BY m.montage_date_updated DESC
LIMIT 500;




--- Without the lines (for using directly in mysql client in terminal


SELECT 
    m.montage_id AS Id, 
    concat('[![', montage_title, '](http://api.cameo.tv/file/', montage_file_hash_title_animation, ')](http://cameo.tv/c/', montage_hash, ')') AS Thumb, 
    DATE_FORMAT(CONVERT_TZ(montage_date_updated,'+00:00','-04:00'), "%l:%i%p") AS Shared,
    ROUND(f.file_length_ms/1000, 2) AS Seconds, 
    COUNT(DISTINCT p.post_id) AS Post,
    COUNT(DISTINCT b.build_id) AS Build,
    COUNT(DISTINCT lYes.like_id) AS Likes,
    COUNT(DISTINCT c.comment_id) AS Com
FROM montages m
LEFT OUTER JOIN files f ON m.montage_file_hash_mp4 = f.file_hash
LEFT OUTER JOIN channel_montages cm ON m.montage_id = cm.montage_id AND cm.channel_id = 1
LEFT OUTER JOIN builds b ON m.montage_id = b.montage_id
LEFT OUTER JOIN user_posts p ON m.montage_id = p.montage_id
LEFT OUTER JOIN likes lYes ON m.montage_id = lYes.montage_id AND lYes.like_it = 'Yes'
LEFT OUTER JOIN comments c ON m.montage_id = c.montage_id
WHERE montage_status = 'Shared' 
AND m.montage_date_updated > CURRENT_TIMESTAMP - INTERVAL @hours HOUR
AND f.file_length_ms > @minLength
AND f.file_length_ms < @maxLength
AND m.theme_hash <> '744dbcae93dfe5e5516994bdcba421981aeaf336' 
AND m.theme_hash <> '79de079587a755ba26c05285da3e168fef490a5a' 
AND cm.montage_id IS NULL
GROUP BY m.montage_id
HAVING Build > Post
ORDER BY m.montage_date_updated DESC
LIMIT 500;
