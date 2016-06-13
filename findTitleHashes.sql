set @d1 = '2013-10-09';
set @theme = '79de079587a755ba26c05285da3e168fef490a5a';
select user_posts.montage_id,montages.montage_hash,user_posts.file_hash_title, user_posts.post_id
from montages
left outer join user_posts
on montages.montage_id = user_posts.montage_id
where montages.montage_date_end >= @d1
and montages.theme_hash = @theme
and montages.montage_status = 'Shared'