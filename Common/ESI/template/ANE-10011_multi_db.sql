USE ActiveNetStaging

DECLARE @audit_subject varchar(max)		= 'ANE-10011 Set systeminfo value in multiple DBs'
DECLARE @audit_author varchar(max)		= 'Jesse Wei'
DECLARE @audit_created_date varchar(max)= '1/1/2018'
DECLARE @audit_type varchar(max)		= 'Datafix' --Datafix or Rollback
DECLARE @audit_description varchar(max)	= '' --Put additional information if necessary.

DECLARE	 @DBName NVARCHAR(255)
		,@SQL NVARCHAR(MAX)
		,@PoolName NVARCHAR(255) = control.getSystemStringByName('PoolName') -- 'DBANET10VS'
		,@XMLstr XML = ''
		,@Delimiter CHAR(1) = ','
		,@DBString NVARCHAR(MAX) = 'All'	-- All OR Comma delimited List of Databases
		,@DEBUG INT = 0 -- 1 to print and not execute sql script

SET NOCOUNT ON
SET XACT_ABORT ON

IF OBJECT_ID('RollbackDB.dbo.ANE_10011_SYSTEMINFO') IS NULL BEGIN
	CREATE TABLE RollbackDB.dbo.ANE_10011_SYSTEMINFO(
		DBName varchar(255),
		KEYWORD varchar(300),
		KEYWORDVALUE varchar(MAX),
		UpdateRecord bit
	)
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
	INNER JOIN SYS.DATABASES DBs ON Anet.DBName = Dbs.Name AND DBs.is_read_only = 0

DECLARE crsrDBName CURSOR FOR SELECT DBName FROM #DBList WHERE IsValid = 1
OPEN crsrDBName
FETCH NEXT FROM crsrDBName INTO @DBName

WHILE @@fetch_status = 0 BEGIN
	SET @SQL = 'USE ' + QUOTENAME(@DBName) + CAST('
	BEGIN TRANSACTION
	DECLARE @changed bit = 0
	
	DECLARE @keyword varchar(300) = ''enable_init_integrity_checks''
	DECLARE @new_value varchar(max) = ''true''
	DECLARE @prev_value varchar(max) = (SELECT KEYWORDVALUE FROM SYSTEMINFO WHERE KEYWORD = @keyword)

	IF @prev_value IS NULL BEGIN
		INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE)
		OUTPUT DB_NAME(), Inserted.KEYWORD, Inserted.KEYWORDVALUE, 0 INTO RollbackDB.dbo.ANE_10011_SYSTEMINFO(DBName, KEYWORD, KEYWORDVALUE, UpdateRecord)
		VALUES (@keyword, @new_value)

		IF @@ROWCOUNT > 0 BEGIN
			INSERT INTO SYSTEMINFOLOG (KEYWORD, PREV_KEYWORD_VALUE, SYSTEMUSER_ID, DATESTAMP) VALUES (@keyword, ISNULL(@prev_value, ''''), 0, GETDATE())
			SET @changed = 1
		END
	END
	ELSE IF @prev_value <> @new_value BEGIN
		UPDATE SYSTEMINFO SET KEYWORDVALUE = @new_value
		OUTPUT DB_NAME(), Deleted.KEYWORD, Deleted.KEYWORDVALUE, 1 INTO RollbackDB.dbo.ANE_10011_SYSTEMINFO(DBName, KEYWORD, KEYWORDVALUE, UpdateRecord)
		WHERE KEYWORD = @keyword AND KEYWORDVALUE NOT LIKE @new_value

		IF @@ROWCOUNT > 0 BEGIN
			INSERT INTO SYSTEMINFOLOG (KEYWORD, PREV_KEYWORD_VALUE, SYSTEMUSER_ID, DATESTAMP) VALUES (@keyword, ISNULL(@prev_value, ''''), 0, GETDATE())
			SET @changed = 1
		END
	END
	
	/* Put fix of other keywords here if any */
	
	IF @changed = 1 BEGIN
		EXEC rollbackdb.dbo.audit_datafix ''' AS NVARCHAR(MAX)) + @DBName + ''', ''' + @audit_subject + ''', ''' + @audit_author + ''', ''' + @audit_created_date + ''', ''' + @audit_type + ''', ''' + @audit_description + '''
	END
	COMMIT TRANSACTION
	';
	
	IF @DEBUG = 1
		PRINT @SQL
	ELSE
		BEGIN TRY
			EXEC sp_executesql @SQL
		END TRY
		BEGIN CATCH
			PRINT 'Data fix failed on ' + QUOTENAME(@DBName)
		END CATCH

	FETCH NEXT FROM crsrDBName INTO @DBName
END
CLOSE crsrDBName
DEALLOCATE crsrDBName

IF @DEBUG = 0 BEGIN
	PRINT char(10) + 'Done. Datafix deployed.'
END