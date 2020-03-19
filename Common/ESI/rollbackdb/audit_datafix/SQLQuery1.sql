--USE ActivenetDB
select * from rollbackdb.dbo.DATAFIX where Subject like 'ANE-10011%'
select * from rollbackdb.sys.tables where name like '%10011%'
--SELECT * FROM rollbackdb.sys.tables where name like '%!_R!_%' escape '!'
--truncate table rollbackdb.dbo.datafix

SELECT * FROM V1540_ActivenetDB.dbo.SYSTEMINFO order by SYSTEMINFO_ID
SELECT * FROM ActivenetDB.dbo.SYSTEMINFO order by SYSTEMINFO_ID
SELECT * FROM ActivenetDBtrainer.dbo.SYSTEMINFO order by SYSTEMINFO_ID


SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'enable_init_integrity_checks'
--UPDATE SYSTEMINFO SET KEYWORDVALUE = 'false' WHERE KEYWORD = 'enable_init_integrity_checks'


SELECT 'ActivenetDB' as db, SYSTEMINFO_ID, KEYWORD, cast(KEYWORDVALUE as varchar(255)) as KEYWORDVALUE, ROW_VERSION FROM ActivenetDB.dbo.SYSTEMINFO WHERE KEYWORD = 'enable_init_integrity_checks'
union
SELECT 'ActivenetDBtrainer' as db, SYSTEMINFO_ID, KEYWORD, cast(KEYWORDVALUE as varchar(255)) as KEYWORDVALUE, ROW_VERSION FROM ActivenetDBtrainer.dbo.SYSTEMINFO WHERE KEYWORD = 'enable_init_integrity_checks'
union
SELECT 'V1540_ActivenetDB' as db, SYSTEMINFO_ID, KEYWORD, cast(KEYWORDVALUE as varchar(255)) as KEYWORDVALUE, ROW_VERSION FROM V1540_ActivenetDB.dbo.SYSTEMINFO WHERE KEYWORD = 'enable_init_integrity_checks'

--select * from RollbackDB.dbo.ANE_10011_SYSTEMINFO

