select * from SYSTEMINFO where KEYWORD like 'full_backup_unc%'

select * from SYSTEMINFO where KEYWORD = 'num_db_backup_allowed_per_day' -- default 2 if no record