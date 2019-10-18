--SELECT * FROM sys.databases

SET NOCOUNT ON

DECLARE @dbs TABLE(name nvarchar(255))
INSERT INTO @dbs (name) SELECT name FROM sys.databases where is_read_only = 0 and name not in ('ActiveNetStaging', 'ANET_Restore', 'model', 'RollbackDB', 'SysAdmin', 'Jeffersonvilleparksrec')
--SELECT * FROM @dbs

DECLARE @db_name nvarchar(255)
DECLARE @sql nvarchar(max) = ''
DECLARE @sql_db nvarchar(max) = ''
DECLARE @parameter nvarchar(255) = N' @row_count INT OUTPUT'
DECLARE @row_count int = 0

SET @db_name = (SELECT TOP 1 name FROM @dbs ORDER BY name)
WHILE @db_name IS NOT NULL BEGIN
	SET @sql_db = 'SET @row_count = (SELECT COUNT(*) FROM [' + @db_name + '].sys.tables WHERE name in (''ACTIVITIES'', ''SYSTEMINFO''))'
	EXEC sp_executesql @sql_db, @parameter, @row_count OUTPUT

	IF @row_count = 2 BEGIN
		IF LEN(@sql) > 0 BEGIN
			SET @sql = @sql + CHAR(10) + 'UNION ALL' + CHAR(10)
		END
		SET @sql = @sql + 'SELECT ''' + @db_name + ''' AS [Database], CUSTOMER_ID, FIRSTNAME, LASTNAME FROM [' + @db_name + '].dbo.CUSTOMERS WHERE CUSTOMER_ID = (SELECT MAX(CUSTOMER_ID) FROM [' + @db_name + '].dbo.CUSTOMERS)'
	END
	ELSE BEGIN
		PRINT 'Skipped ' + @db_name
	END

	DELETE FROM @dbs WHERE name = @db_name
	SET @db_name = (SELECT TOP 1 name FROM @dbs ORDER BY name)
END

IF LEN(@sql) > 0 BEGIN
	EXEC sp_executesql @sql
END
ELSE BEGIN
	PRINT CHAR(10) + 'No ActiveNet database is found.'
END
