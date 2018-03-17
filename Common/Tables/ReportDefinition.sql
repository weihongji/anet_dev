declare @P0 datetime,@P1 datetime,@P2 datetime,@P3 datetime,@P4 datetime,@P5 datetime
SELECT @P0 = '1899-12-30 00:00:00', @P1 = '2015-08-24 00:00:00', @P2 = '1899-12-30 00:00:00', @P3 = '2015-08-24 00:00:00', @P4 = '1899-12-30 00:00:00', @P5 = '2015-08-24 06:09:16'
select last_scheduled_run_date AS X, * from DBO.REPORTDEFINITION
where enable_schedule_report<>0
	and (schedule_from_date=@P0 or schedule_from_date<=@P1)
	and (schedule_to_date=@P2 or schedule_to_date>=@P3)
	and (last_scheduled_run_date=@P4 or last_scheduled_run_date<@P5)
	

SELECT enable_schedule_report, last_scheduled_run_date, * FROM REPORTDEFINITION

SELECT * FROM REPORT_DEFINITION_TIME

--UPDATE REPORTDEFINITION SET LAST_SCHEDULED_RUN_DATE = '2015-08-19 08:23:35.000' WHERE REPORTDEFINITION_ID = 5

SELECT name, address FROM FROMEMAILADDRESSES "FROMEMAILADDRESSES" WHERE fromemailaddress_id=1

select * from SYSTEMINFO where KEYWORD = 'Image_Storage_Path'
select * from SYSTEMINFO where KEYWORD = 'full_backup_unc'
select * from SYSTEMINFO where KEYWORD = 'full_backup_unc_remote'
--sdi.ini writefiledata
update SYSTEMINFO set KEYWORDVALUE = '\\WL00070239\AN_folders\image_storage_path' where KEYWORD = 'Image_Storage_Path' and KEYWORDVALUE like '\\WL00070239\filedata'
update SYSTEMINFO set KEYWORDVALUE = '\\WL00070239\AN_folders\full_backup_unc' where KEYWORD = 'full_backup_unc' and KEYWORDVALUE like '\\fs03\ActiveNetDBBackups\Burnaby36\'
insert into SYSTEMINFO(KEYWORD, KEYWORDVALUE) values ('full_backup_unc_remote', '\\WL00070239\AN_folders\full_backup_unc_remote')