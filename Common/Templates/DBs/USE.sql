--SELECT * FROM sys.databases

SET NOCOUNT ON

DECLARE @dbs TABLE(name nvarchar(255))
INSERT INTO @dbs (name) SELECT name FROM sys.databases
--SELECT * FROM @dbs

DECLARE @db_name nvarchar(255)
DECLARE @sql nvarchar(max) = ''

SET @db_name = (SELECT TOP 1 name FROM @dbs ORDER BY name)
WHILE @db_name IS NOT NULL BEGIN
	SET @sql = 'USE [' + @db_name + ']
		IF EXISTS(SELECT * FROM sys.tables WHERE name=''ACTIVITIES'') BEGIN
			--SELECT DB_NAME() AS [Database], VERISIGNEFTWAITDAYS FROM SYSTEM
			SELECT TOP 1 DB_NAME() AS [Database], CUSTOMER_ID, FIRSTNAME, LASTNAME FROM CUSTOMERS ORDER BY CUSTOMER_ID DESC
		END
		ELSE BEGIN
			PRINT '' Skipped '' + DB_NAME()
		END
	'
	EXEC sp_executesql @sql

	DELETE FROM @dbs WHERE name = @db_name
	SET @db_name = (SELECT TOP 1 name FROM @dbs ORDER BY name)
END
