USE ActiveNetLogs

select COUNT(*) from APPLICATION_LOG
select COUNT(*) from DDRELATIONS
select COUNT(*) from DEPLOYMENT_BATCHES
select COUNT(*) from DEPLOYMENT_JOBS
select COUNT(*) from SERVLET_FUNCTION_STATISTICS1
select COUNT(*) from UPSIZEERRORS

select top 1000 * from APPLICATION_LOG where EVENT_TIME_UTC < '20150816' order by APPLICATION_LOG_ID desc
select * from DDRELATIONS
select * from DEPLOYMENT_BATCHES
select * from DEPLOYMENT_JOBS
select * from SERVLET_FUNCTION_STATISTICS1
select * from UPSIZEERRORS

--enable debug logs
select * from ActivenetDB.dbo.SYSTEMINFO where KEYWORD = 'servlet_app_logging_msg_types'
/*
insert into ActivenetDB.dbo.SYSTEMINFO(KEYWORD, KEYWORDVALUE) values ('servlet_app_logging_msg_types', '190')
update ActivenetDB.dbo.SYSTEMINFO set KEYWORDVALUE = '190' where KEYWORD = 'servlet_app_logging_msg_types'
*/


--Customer change/creattion log
/*
SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'log_account_record'
INSERT INTO SYSTEMINFO(KEYWORD, KEYWORDVALUE) VALUES ('log_account_record', 'true') --UI Path: Administration Home -> System Settings -> Configuration - General -> Change Log -> Account records

Make sure ChangeLogQManager is running. (Not commented out in startBackgroundThreads() from ActiveNetServlet.java
*/