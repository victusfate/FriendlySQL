set @minutes = 60;

select @minutes as 'Minutes', count(*) as 'new users', count(*)/(60*@minutes) as 'Users per second' from users 
where user_date_added > DATE_SUB(now(), INTERVAL @minutes MINUTE)
and current_montage_id is not null
