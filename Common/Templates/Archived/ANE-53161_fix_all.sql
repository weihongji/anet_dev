--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  10/13/2016
--
-- Description: ANE-53161 Fix same issue in other orgs
-- Datafix
--==================================================================================================================

USE ActiveNetStaging

DECLARE	 @DBName NVARCHAR(255)
		,@SQL NVARCHAR(MAX)
		,@XMLstr XML = ''
		,@Delimiter CHAR(1) = ','
		,@DBString NVARCHAR(MAX) = 'AbingtonParksandRec,beulahparks,brearecsandbox,CedarHillPARD,CedarHillPARDsandbox,CityofDanaPoint,DarienParksandRec,MBXFoundation,PLAINTOWNSHIP,ymcabvsandbox,YMCAcommonconfig'
		,@DEBUG INT = 0 -- 1 to print and not execute sql script

SET NOCOUNT ON
SET XACT_ABORT ON

IF OBJECT_ID('RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD') IS NULL BEGIN
	CREATE TABLE RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD(
		DBName varchar(255),
		KEYWORD varchar(255),
		KEYWORDVALUE varchar(255),
		SYSTEMINFO_ID int
	)
END

IF OBJECT_ID('tempdb..#DBList') IS NOT NULL
	DROP TABLE #DBList

CREATE TABLE #DBList (
	DBName VARCHAR(255),
	IsValid BIT DEFAULT 0
)

--------------------------------------------------
-- Parse Database List
--------------------------------------------------
select @XMLstr = cast('<A>'+ replace(@DBString,@Delimiter,'</A><A>')+ '</A>' as xml)

INSERT INTO #DBList ( DBName )
select t.value('.', 'varchar(max)') as DBName
from @XMLstr.nodes('/A') as XMLstr(t) 

--------------------------------------------------
-- Check if the Databases are valid
--------------------------------------------------
UPDATE #DBList SET IsValid = 1
FROM #DBList Anet
INNER JOIN SYS.DATABASES DBs ON Anet.DBName = Dbs.Name and DBs.is_read_only=0

DECLARE crsrDBName CURSOR FOR SELECT DBName FROM #DBList WHERE IsValid = 1
OPEN crsrDBName
FETCH NEXT FROM crsrDBName INTO @DBName

WHILE @@fetch_status = 0 BEGIN
	SET @SQL = 'USE ' +  QUOTENAME(@DBName) +'
		DECLARE @folder varchar(255) = LOWER(DB_NAME())
		IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = ''full_backup_unc_remote'' AND KEYWORDVALUE LIKE ''W:\prod\SQLBACKUPS\burnaby36'') BEGIN

			UPDATE SYSTEMINFO SET KEYWORDVALUE = ''W:\prod\SQLBACKUPS\'' + @folder
			OUTPUT DB_NAME(), DELETED.KEYWORD, DELETED.KEYWORDVALUE, DELETED.SYSTEMINFO_ID INTO RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD(DBName, KEYWORD, KEYWORDVALUE, SYSTEMINFO_ID)
			WHERE KEYWORD = ''full_backup_unc_remote'' AND KEYWORDVALUE LIKE ''W:\prod\SQLBACKUPS\burnaby36''

			UPDATE SYSTEMINFO SET KEYWORDVALUE = ''/opt/active/ActiveNet/prod/SQLBACKUPS/'' + @folder
			OUTPUT DB_NAME(), DELETED.KEYWORD, DELETED.KEYWORDVALUE, DELETED.SYSTEMINFO_ID INTO RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD(DBName, KEYWORD, KEYWORDVALUE, SYSTEMINFO_ID)
			WHERE KEYWORD = ''full_backup_unc''
		END';
	
	IF @DEBUG = 1 BEGIN
		PRINT @SQL
	END
	ELSE BEGIN
		BEGIN TRY
			EXEC sp_executesql @SQL
		END TRY
		BEGIN CATCH
			PRINT 'Data fix failed on ' +  QUOTENAME(@DBName) 
		END CATCH
	END
	FETCH NEXT FROM crsrDBName INTO @DBName
END

CLOSE crsrDBName
DEALLOCATE crsrDBName
