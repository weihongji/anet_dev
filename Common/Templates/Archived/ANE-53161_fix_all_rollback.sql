--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  10/13/2016
--
-- Description: ANE-53161 Fix same issue in other orgs
-- Rollback
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
	PRINT 'Nothing to roll back. Datafix has not been applied yet.'
	RETURN
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
INNER JOIN ROLLBACKDB.DBO.ANE_53154_SYSTEMINFO_UPD bak ON Anet.DBName = bak.DBName


DECLARE crsrDBName CURSOR FOR SELECT DBName FROM #DBList WHERE IsValid = 1
OPEN crsrDBName
FETCH NEXT FROM crsrDBName INTO @DBName

WHILE @@fetch_status = 0 BEGIN

	SET @SQL = 'USE ' +  QUOTENAME(@DBName) +'
		IF OBJECT_ID(''RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD'') IS NOT NULL BEGIN
			UPDATE SYSTEMINFO SET KEYWORDVALUE = FX.KEYWORDVALUE
			FROM RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD FX
			WHERE FX.DBName = DB_NAME() AND SYSTEMINFO.KEYWORD = FX.KEYWORD
		END
		DELETE FROM RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD WHERE DBName = DB_NAME()
		';
	
	IF @DEBUG = 1 BEGIN
		PRINT @SQL
	END
	ELSE BEGIN
		BEGIN TRY
			EXEC sp_executesql @SQL
			PRINT 'Rollback is done.'
		END TRY
		BEGIN CATCH
			PRINT 'Rollback failed on ' +  QUOTENAME(@DBName) 
		END CATCH
	END
	FETCH NEXT FROM crsrDBName INTO @DBName
END

CLOSE crsrDBName
DEALLOCATE crsrDBName

IF NOT EXISTS(SELECT * FROM RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD WHERE DBName = DB_NAME()) BEGIN
	DROP TABLE RollbackDB.dbo.ANE_53154_SYSTEMINFO_UPD
END
