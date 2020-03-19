USE ActiveNetStaging

DECLARE @audit_subject varchar(max)		= 'ANE-10011 Set systeminfo value in multiple DBs'
DECLARE @audit_author varchar(max)		= 'Jesse Wei'
DECLARE @audit_created_date varchar(max)= '1/1/2020'
DECLARE @audit_type varchar(max)		= 'Rollback' --Datafix or Rollback
DECLARE @audit_description varchar(max)	= '' --Put additional information if necessary.

DECLARE	 @DBName NVARCHAR(255)
		,@SQL NVARCHAR(MAX)
		,@PoolName NVARCHAR(255) = control.getSystemStringByName('PoolName') -- 'DBANET20VS'
		,@XMLstr XML = ''
		,@Delimiter CHAR(1) = ','
		,@DBString NVARCHAR(MAX) = 'All'	-- All OR Comma delimited List of Databases
		,@DEBUG INT = 0 -- 1 to print and not execute sql script

SET NOCOUNT ON
SET XACT_ABORT ON

IF OBJECT_ID('RollbackDB.dbo.ANE_10011_SYSTEMINFO') IS NULL BEGIN
	PRINT 'Nothing to roll back. Datafix has not been deployed yet.'
	RETURN
END

IF OBJECT_ID('tempdb..#DBList') IS NOT NULL BEGIN
	DROP TABLE #DBList
END

CREATE TABLE #DBList (
	DBName VARCHAR(255),
	IsValid BIT DEFAULT 0
)

--------------------------------------------------
-- Parse Database List
--------------------------------------------------
IF @DBString = 'ALL' BEGIN
	INSERT INTO #DBList(DBName)
	SELECT CASE WHEN os1.TRAINER = 0 THEN or1.SITE_URL ELSE or1.SITE_URL+'Trainer' END AS SITE_URL
	FROM dbo.orgs or1
		INNER JOIN dbo.orgsites os1 ON(os1.org_id = or1.org_id)
		LEFT JOIN dbo.pools po1 ON(os1.databasepool_id = po1.pool_id)
	WHERE po1.POOLNAME = @PoolName
		AND or1.RETIRED = 0
		--AND or1.TEST_SITE = 0
END
ELSE BEGIN
	SELECT @XMLstr = CAST('<A>'+ REPLACE(@DBString,@Delimiter,'</A><A>')+ '</A>' AS xml)

	INSERT INTO #DBList (DBName)
	SELECT t.value('.', 'varchar(max)') AS DBName
	FROM @XMLstr.nodes('/A') AS XMLstr(t)
END

--------------------------------------------------
-- Check if the Databases are valid
--------------------------------------------------
UPDATE #DBList SET IsValid = 1
FROM #DBList Anet
	INNER JOIN SYS.DATABASES DBs ON Anet.DBName = Dbs.Name and DBs.is_read_only = 0
	INNER JOIN ROLLBACKDB.DBO.ANE_10011_SYSTEMINFO bak ON Anet.DBName = bak.DBName

DECLARE crsrDBName CURSOR FOR SELECT DBName FROM #DBList WHERE IsValid = 1
OPEN crsrDBName
FETCH NEXT FROM crsrDBName INTO @DBName

WHILE @@fetch_status = 0 BEGIN
	SET @SQL = 'USE ' + QUOTENAME(@DBName) + '
		BEGIN TRANSACTION
		DECLARE @changed bit = 0
		
		IF EXISTS(SELECT * FROM RollbackDB.dbo.ANE_10011_SYSTEMINFO WHERE DBName = DB_NAME() AND UpdateRecord = 0) BEGIN
			INSERT INTO SYSTEMINFOLOG (KEYWORD, PREV_KEYWORD_VALUE, SYSTEMUSER_ID, DATESTAMP)
			SELECT s.KEYWORD, s.KEYWORDVALUE, 0, GETDATE()
			FROM SYSTEMINFO s INNER JOIN RollbackDB.dbo.ANE_10011_SYSTEMINFO bak ON bak.KEYWORD = s.KEYWORD AND bak.DBName = DB_NAME()
			WHERE bak.UpdateRecord = 0

			DELETE s FROM SYSTEMINFO s INNER JOIN RollbackDB.dbo.ANE_10011_SYSTEMINFO bak ON bak.KEYWORD = s.KEYWORD AND bak.DBName = DB_NAME()
			WHERE bak.UpdateRecord = 0

			SET @changed = 1
		END
		
		IF EXISTS(SELECT * FROM RollbackDB.dbo.ANE_10011_SYSTEMINFO WHERE DBName = DB_NAME() AND UpdateRecord = 1) BEGIN
			INSERT INTO SYSTEMINFOLOG (KEYWORD, PREV_KEYWORD_VALUE, SYSTEMUSER_ID, DATESTAMP)
			SELECT s.KEYWORD, s.KEYWORDVALUE, 0, GETDATE()
			FROM SYSTEMINFO s INNER JOIN RollbackDB.dbo.ANE_10011_SYSTEMINFO bak ON bak.KEYWORD = s.KEYWORD AND bak.DBName = DB_NAME()
			WHERE bak.UpdateRecord = 1

			UPDATE s SET s.KEYWORDVALUE = bak.KEYWORDVALUE
			FROM SYSTEMINFO s INNER JOIN RollbackDB.dbo.ANE_10011_SYSTEMINFO bak ON bak.KEYWORD = s.KEYWORD AND bak.DBName = DB_NAME()
			WHERE bak.UpdateRecord = 1

			SET @changed = 1
		END
		
		IF @changed = 1 BEGIN
			IF NOT EXISTS(SELECT * FROM RollbackDB.sys.tables WHERE NAME = ''ANE_10011_SYSTEMINFO_COPY'') BEGIN
				SELECT * INTO RollbackDB.dbo.ANE_10011_SYSTEMINFO_COPY FROM RollbackDB.dbo.ANE_10011_SYSTEMINFO
			END
			DELETE FROM RollbackDB.dbo.ANE_10011_SYSTEMINFO WHERE DBName = DB_NAME()

			IF NOT EXISTS(SELECT * FROM RollbackDB.dbo.ANE_10011_SYSTEMINFO) BEGIN
				DROP TABLE RollbackDB.dbo.ANE_10011_SYSTEMINFO
				PRINT char(10) + ''Rollback is done.''
			END

			EXEC rollbackdb.dbo.audit_datafix ''' + @DBName + ''', ''' + @audit_subject + ''', ''' + @audit_author + ''', ''' + @audit_created_date + ''', ''' + @audit_type + ''', ''' + @audit_description + '''
		END
		COMMIT TRANSACTION
		';
	
	IF @DEBUG = 1
		PRINT @SQL
	ELSE BEGIN
		BEGIN TRY
			EXEC sp_executesql @SQL
		END TRY
		BEGIN CATCH
			PRINT 'Rollback failed on ' + QUOTENAME(@DBName)
		END CATCH
	END
	FETCH NEXT FROM crsrDBName INTO @DBName
END
CLOSE crsrDBName
DEALLOCATE crsrDBName
