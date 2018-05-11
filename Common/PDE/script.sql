USE [master]
GO
/****** Object:  Database [PDE]    Script Date: 5/7/2018 1:45:04 PM ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'PDE')
BEGIN
CREATE DATABASE [PDE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PDE', FILENAME = N'D:\Store\Database\PDE.mdf' , SIZE = 541696KB , MAXSIZE = UNLIMITED, FILEGROWTH = 524288KB )
 LOG ON 
( NAME = N'PDE_log', FILENAME = N'D:\Store\Database\PDE_log.ldf' , SIZE = 65416KB , MAXSIZE = 2048GB , FILEGROWTH = 262144KB )
 COLLATE SQL_Latin1_General_CP1_CI_AS
END

GO
ALTER DATABASE [PDE] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PDE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PDE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PDE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PDE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PDE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PDE] SET ARITHABORT OFF 
GO
ALTER DATABASE [PDE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PDE] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [PDE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PDE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PDE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PDE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PDE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PDE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PDE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PDE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PDE] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PDE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PDE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PDE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PDE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PDE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PDE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PDE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PDE] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PDE] SET  MULTI_USER 
GO
ALTER DATABASE [PDE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PDE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PDE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PDE] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'PDE', N'ON'
GO
USE [PDE]
GO
/****** Object:  User [RecWare]    Script Date: 5/7/2018 1:45:07 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'RecWare')
CREATE USER [RecWare] FOR LOGIN [recware] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [mkassow]    Script Date: 5/7/2018 1:45:08 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'mkassow')
CREATE USER [mkassow] FOR LOGIN [mkassow] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ANET_Deployer]    Script Date: 5/7/2018 1:45:08 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'ANET_Deployer')
CREATE USER [ANET_Deployer] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [active\djensen]    Script Date: 5/7/2018 1:45:08 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'active\djensen')
CREATE USER [active\djensen] FOR LOGIN [active\djensen] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [active\dbeng]    Script Date: 5/7/2018 1:45:09 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'active\dbeng')
CREATE USER [active\dbeng] FOR LOGIN [ACTIVE\dbeng] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ACTIVE\.ANET.DB.Deploy]    Script Date: 5/7/2018 1:45:09 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'ACTIVE\.ANET.DB.Deploy')
CREATE USER [ACTIVE\.ANET.DB.Deploy] FOR LOGIN [ACTIVE\.ANET.DB.Deploy] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [DB_Executor]    Script Date: 5/7/2018 1:45:10 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'DB_Executor' AND type = 'R')
CREATE ROLE [DB_Executor]
GO
/****** Object:  DatabaseRole [ANET_Core_Role]    Script Date: 5/7/2018 1:45:10 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'ANET_Core_Role' AND type = 'R')
CREATE ROLE [ANET_Core_Role]
GO
ALTER ROLE [ANET_Core_Role] ADD MEMBER [RecWare]
GO
ALTER ROLE [DB_Executor] ADD MEMBER [RecWare]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [RecWare]
GO
ALTER ROLE [db_datareader] ADD MEMBER [RecWare]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [RecWare]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [mkassow]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [mkassow]
GO
ALTER ROLE [db_datareader] ADD MEMBER [mkassow]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [mkassow]
GO
ALTER ROLE [ANET_Core_Role] ADD MEMBER [ANET_Deployer]
GO
ALTER ROLE [DB_Executor] ADD MEMBER [ANET_Deployer]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [ANET_Deployer]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [ANET_Deployer]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ANET_Deployer]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ANET_Deployer]
GO
ALTER ROLE [db_datareader] ADD MEMBER [active\djensen]
GO
ALTER ROLE [db_owner] ADD MEMBER [active\dbeng]
GO
ALTER ROLE [db_datareader] ADD MEMBER [active\dbeng]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [ACTIVE\.ANET.DB.Deploy]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ACTIVE\.ANET.DB.Deploy]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ACTIVE\.ANET.DB.Deploy]
GO
ALTER ROLE [DB_Executor] ADD MEMBER [ANET_Core_Role]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ANET_Core_Role]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ANET_Core_Role]
GO
/****** Object:  Schema [sweeper]    Script Date: 5/7/2018 1:45:13 PM ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'sweeper')
EXEC sys.sp_executesql N'CREATE SCHEMA [sweeper]'

GO
/****** Object:  StoredProcedure [dbo].[usp_getDBTS]    Script Date: 5/7/2018 1:45:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_getDBTS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_getDBTS]
	@sweeper_client_id INT,
	@to_rv BINARY(8) OUTPUT,
	@DEBUG BIT = 0
AS
SET NOCOUNT ON;
SET DEADLOCK_PRIORITY LOW;
SET LOCK_TIMEOUT 0;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF @DEBUG = 1
BEGIN
	PRINT ''=================================================='';
	PRINT OBJECT_NAME(@@PROCID)
	PRINT ''=================================================='';
END;

DECLARE
	@database SYSNAME = (SELECT client_db_name FROM sweeper.sweeper_clients WHERE id = @sweeper_client_id),
	@params NVARCHAR(MAX) = ''@to_rv BINARY(8) OUTPUT'',
	@SQL NVARCHAR(MAX) = 
''USE %database%; 
SELECT @to_rv = @@DBTS;'';

SET @SQL = REPLACE(@SQL, ''%database%'', @database);

IF @DEBUG = 1
	PRINT @SQL;

EXEC sp_executesql @SQL, @params, @to_rv = @to_rv OUTPUT;

RETURN 0;
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_process_batch_log]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_process_batch_log]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[usp_process_batch_log](
	@sweeper_distribution_id BIGINT,
    @sweeper_client_id BIGINT,
	@batch_id BIGINT,
	@status NVARCHAR(50),
	@process_from_rv BINARY(8),
	@process_to_rv BINARY(8),
	@step_name NVARCHAR(255),
	@started_by NVARCHAR(50),
	@started_dt DATETIME,
	@completed_dt DATETIME,
	@comments NVARCHAR(2000) = NULL,
	@version NVARCHAR(50) = NULL
    )
AS

MERGE dbo.process_batches AS target
USING (VALUES(
		@sweeper_distribution_id,
        @sweeper_client_id,
		@batch_id,
		@status,
		@process_from_rv,
		@process_to_rv,
		@step_name,
		@started_dt,
		@started_by,
		@completed_dt,
		@comments,
		@version
	)) AS src(sweeper_distribution_id, sweeper_client_id, batch_id, status, process_from_rv, process_to_rv,  
                step_name, started_dt, started_by, completed_dt, comments, version)
ON target.sweeper_distribution_id = src.sweeper_distribution_id AND target.batch_id = src.batch_id AND target.sweeper_client_id = src.sweeper_client_id
WHEN MATCHED THEN
    UPDATE SET batch_status = src.status,
    	target.process_from_rv = src.process_from_rv,
		target.process_to_rv = src.process_to_rv,
		step_name = src.step_name,
		started_dt = src.started_dt,
		started_by = src.started_by,
		completed_dt = src.completed_dt,
		batch_comments = src.comments,
		process_version = COALESCE(src.version, process_version)
WHEN NOT MATCHED THEN
    INSERT (sweeper_distribution_id, sweeper_client_id, batch_id, batch_status, process_from_rv, process_to_rv, 
                step_name, started_dt, started_by, completed_dt, batch_comments, process_version) VALUES(
		src.sweeper_distribution_id,
        src.sweeper_client_id,
		src.batch_id,
		src.status,
		src.process_from_rv,
		src.process_to_rv,
		src.step_name,
		src.started_dt,
		src.started_by,
		src.completed_dt,
		src.comments,
		src.version
	);

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_process_batch_step_log]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_process_batch_step_log]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[usp_process_batch_step_log](
	@sweeper_distribution_id BIGINT,
    @sweeper_client_id BIGINT,
	@batch_id BIGINT,
	@status NVARCHAR(50),
	@step_name NVARCHAR(255),
	@started_by NVARCHAR(50),
	@started_dt DATETIME,
	@completed_dt DATETIME,
	@records BIGINT,
	@comments NVARCHAR(2000) = NULL
    )
AS

MERGE dbo.process_batch_steps AS target
USING (VALUES(
		@sweeper_distribution_id,
        @sweeper_client_id,
		@batch_id,
		@status,
		@step_name,
		@started_dt,
		@started_by,
		@completed_dt,
		@records,
		@comments
	)) AS src(sweeper_distribution_id, sweeper_client_id, batch_id, status,   
                step_name, started_dt, started_by, completed_dt, records, comments)
ON target.sweeper_distribution_id = src.sweeper_distribution_id AND target.batch_id = src.batch_id 
    AND target.step_name = src.step_name
    AND target.sweeper_client_id = src.sweeper_client_id
WHEN MATCHED THEN
    UPDATE SET step_status = src.status,
		step_name = src.step_name,
		started_dt = src.started_dt,
		started_by = src.started_by,
		completed_dt = src.completed_dt,
		records = src.records,
		step_comments = src.comments
WHEN NOT MATCHED THEN
    INSERT (sweeper_distribution_id, sweeper_client_id, batch_id, step_status,
                step_name, started_dt, started_by, completed_dt, records, step_comments) VALUES(
		src.sweeper_distribution_id,
        src.sweeper_client_id,
		src.batch_id,
		src.status,
		src.step_name,
		src.started_dt,
		src.started_by,
		src.completed_dt,
		src.records,
		src.comments
	);

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_process_error_log]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_process_error_log]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[usp_process_error_log](
	@sweeper_distribution_id BIGINT,
    @sweeper_client_id BIGINT,
	@batch_id BIGINT,
	@step_name NVARCHAR(255),
	@error_dt DATETIME,
	@error_message NVARCHAR(2000),
	@error_number NVARCHAR(50)
	)
AS

IF (NOT EXISTS(SELECT sweeper_distribution_id, sweeper_client_id, batch_id, step_name 
            FROM dbo.process_errors 
            WHERE sweeper_distribution_id = @sweeper_distribution_id AND batch_id = @batch_id 
                AND error_dt = @error_dt AND sweeper_client_id = @sweeper_client_id))
BEGIN
    BEGIN TRY
	INSERT INTO PDE.dbo.process_errors(
		sweeper_distribution_id,
        sweeper_client_id,
		batch_id,
		step_name,
		error_dt,
		[error_message],
		[error_number]
	)
	VALUES(
		@sweeper_distribution_id,
        @sweeper_client_id,
		@batch_id,
		@step_name,
		@error_dt,
		@error_message,
		@error_number
	)
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
ELSE
BEGIN
	UPDATE dbo.process_errors
	SET error_message = @error_message,
		error_number = @error_number
	WHERE sweeper_distribution_id = @sweeper_distribution_id
		AND batch_id = @batch_id
		AND error_dt = @error_dt
        AND sweeper_client_id = @sweeper_client_id;
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_process_log]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_process_log]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[usp_process_log](
	@process_name NVARCHAR(255),
    @sweeper_distribution_id BIGINT = NULL,
    @sweeper_client_id BIGINT = NULL,
	@status NVARCHAR(50),
    @processed_from_dt DATETIME = NULL,
    @processed_to_dt DATETIME = NULL,
	@processed_from_rv BINARY(8) = NULL,
	@processed_to_rv BINARY(8) = NULL,
	@last_batch_id BIGINT,
	@working_batch_id BIGINT,
	@started_by NVARCHAR(50),
	@started_dt DATETIME,
	@completed_dt DATETIME,
	@comments NVARCHAR(2000) = NULL,
	@version NVARCHAR(50) = NULL
    )
AS

MERGE dbo.sweeper_processes AS target
USING (VALUES(
		@process_name,
        @sweeper_distribution_id,
        @sweeper_client_id,
		@status,
        @processed_from_dt,
        @processed_to_dt,
        @processed_from_rv,
		@processed_to_rv,
		@last_batch_id,
		@working_batch_id,
		@started_dt,
		@started_by,
		@completed_dt,
		@comments,
		@version
	)) AS src(process_name, sweeper_distribution_id, sweeper_client_id, status, processed_from_dt, processed_to_dt, processed_from_rv, processed_to_rv, last_batch_id, working_batch_id, 
                started_dt, started_by, completed_dt, comments, version)
ON target.process_name = src.process_name AND (target.sweeper_client_id = src.sweeper_client_id OR src.sweeper_client_id IS NULL)
WHEN MATCHED THEN
    UPDATE SET process_status = src.status,
        target.processed_from_dt = src.processed_from_dt,
        target.processed_to_dt = src.processed_to_dt,
        target.processed_from_rv = src.processed_from_rv,
		target.processed_to_rv = src.processed_to_rv,
		target.last_batch_id = COALESCE(src.last_batch_id, target.last_batch_id),
		working_batch_id = src.working_batch_id,
		started_dt = src.started_dt,
		started_by = src.started_by,
		completed_dt = src.completed_dt,
		process_comments = src.comments,
		process_version = COALESCE(src.version, process_version)
WHEN NOT MATCHED THEN
    INSERT (process_name, sweeper_distribution_id, sweeper_client_id, process_status, processed_from_dt, processed_to_dt, processed_from_rv, processed_to_rv, last_batch_id, working_batch_id, 
                started_dt, started_by, completed_dt, process_comments, process_version) VALUES(
		src.process_name,
        src.sweeper_distribution_id,
        src.sweeper_client_id,
		src.status,
        src.processed_from_dt,
        src.processed_to_dt,
        src.processed_from_rv,
		src.processed_to_rv,
		src.last_batch_id,
		src.working_batch_id,
		src.started_dt,
		src.started_by,
		src.completed_dt,
		src.comments,
		src.version
	);

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_sweeper_drop_in_customer_with_balance]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_sweeper_drop_in_customer_with_balance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[usp_sweeper_drop_in_customer_with_balance](
	@db_name varchar(255),
    @distribution_id BIGINT = NULL, --only for logging purpose
	@process_from_rv BINARY(8) = NULL,
	@process_to_rv BINARY(8) = NULL,
	@started_by NVARCHAR(50) = NULL,
	@parseToXml bit = 0, --return result as xml datetype
    @version NVARCHAR(50) = ''0.0.0.1'',
    @debug BIT = 0
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

BEGIN TRY

DECLARE
    @sweeper_client_id BIGINT

--#region initialization
DECLARE 
    @batch_completed_dt DATETIME,
    @batch_status NVARCHAR(50),
    @last_batch_id BIGINT,
    @max_capture_dt DATETIME,
    @process_comments NVARCHAR(2000),
    @process_name NVARCHAR(255),
    @processed_from_rv BINARY(8),
    @processed_to_rv BINARY(8),
    @records BIGINT,
    @started_dt DATETIME,
    @step_completed_dt DATETIME,
    @step_name NVARCHAR(255),
    @step_status NVARCHAR(50),
    @step_started_dt DATETIME,
    @working_batch_id BIGINT,
    @error_dt DATETIME,
    @error_message NVARCHAR(2048),
    @error_number NVARCHAR(50),
    @error_severity int,
    @error_state int;

--use dm_processes structure to log beginning of execution, update dm_processes and dm_process_batches
SET @started_dt = GETUTCDATE();
SET @process_name = OBJECT_NAME(@@PROCID);
IF (@process_name IS NULL) SET @process_name = ''usp_sweeper_drop_in_customer_with_balance''
IF (@started_by IS NULL) SET @started_by = SYSTEM_USER;

SELECT @sweeper_client_id = id FROM sweeper.sweeper_clients WHERE client_db_name = @db_name

SELECT 
    @batch_status = process_status, 
    @last_batch_id = last_batch_id, 
    @processed_to_rv = processed_to_rv
FROM PDE.dbo.sweeper_processes 
WHERE process_name = @process_name AND (sweeper_distribution_id = @distribution_id OR @distribution_id IS NULL)
AND sweeper_client_id = @sweeper_client_id

SET @working_batch_id = COALESCE(@last_batch_id, 0) + 1;

IF @DEBUG = 0 BEGIN
	SET @batch_status = ''STARTED''
	BEGIN TRANSACTION;
	--#region batch logging
    EXEC PDE.dbo.usp_process_batch_log
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@batch_id = @working_batch_id,
		@status = @batch_status,
		@process_from_rv = @process_from_rv,
		@process_to_rv = @process_to_rv,
		@step_name = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
	    @version = @version;

	EXEC PDE.dbo.usp_process_log
		@process_name = @process_name,
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@status = @batch_status,
        @processed_from_rv = @process_from_rv,
		@processed_to_rv = @process_to_rv,
		@last_batch_id = @last_batch_id,
		@working_batch_id = @working_batch_id,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
		@version = @version;


	COMMIT TRANSACTION;
END; -- @DEBUG = 0

IF @process_to_rv IS NULL
	EXEC dbo.usp_getDBTS
		@sweeper_client_id = @sweeper_client_id, 
		@to_rv = @process_to_rv OUTPUT,
		@debug = @debug;
IF @process_from_rv IS NULL
    SET @process_from_rv = @processed_to_rv

IF @DEBUG = 0 BEGIN
	BEGIN TRANSACTION;
	--#region batch logging
    EXEC PDE.dbo.usp_process_batch_log
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@batch_id = @working_batch_id,
		@status = @batch_status,
		@process_from_rv = @process_from_rv,
		@process_to_rv = @process_to_rv,
		@step_name = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
	    @version = @version;

	COMMIT TRANSACTION;
END; -- @DEBUG = 0

IF @DEBUG = 1 BEGIN
    PRINT @process_name + '' - '' + CONVERT(VARCHAR(50), @started_dt, 121)
    PRINT ''@process_from_rv - '' + ISNULL(CONVERT(VARCHAR(30), @process_from_rv, 1), ''NULL'')
    PRINT ''@process_to_rv - '' + ISNULL(CONVERT(VARCHAR(30), @process_to_rv, 1), ''NULL'')
    PRINT @process_comments
END; -- @DEBUG = 1

--#region SAFEGUARDS
IF @DEBUG = 0 BEGIN
-- retry if the process is already running
	IF dbo.udf_get_proc_running_cnt(DB_ID(), @@PROCID) > 1 OR(dbo.udf_get_proc_running_cnt(DB_ID(), @@PROCID) IS NULL AND @batch_status = ''STARTED'')
	BEGIN				
		SET @error_message = ''Process %s is in %s state. Processing Halted.''
		SET @batch_status = ''STARTED''
        SET @error_number = 50000
	
		RAISERROR(
			@error_message,
			16, -- Severity.
			1, -- State.
			@process_name,
			@batch_status
		);
	END
END; -- @DEBUG = 0
--#endregion

--region log order capture start
SELECT 
	@step_name = ''1. Capture data'',
	@step_status = ''STARTED'',
	@step_started_dt = GETUTCDATE(),
	@records = 0,
	@step_completed_dt = NULL

DECLARE @sql NVARCHAR(MAX) = '''',
    @WhereAnd NVARCHAR(MAX) = '''';

IF OBJECT_ID(''tempdb.dbo.#temp'') IS NULL
    CREATE TABLE #temp(data XML)

SET @sql = ''
SELECT tgt.receiptheader_id, rh.receiptnumber, tgt.datestamp
FROM dbo.customeraccounts tgt (NOLOCK)
LEFT JOIN dbo.receiptheaders rh (NOLOCK) ON rh.receiptheader_id = tgt.receiptheader_id
WHERE tgt.customer_id = 1 AND tgt.voided = 0
%WhereAnd%''

IF @parseToXml = 1
    SET @sql = ''INSERT INTO #temp SELECT ('' + @sql + CHAR(10) + ''FOR XML PATH(''''node''''), TYPE)''

SET @sql = ''USE %DatabaseName%'' +CHAR(10) + @sql
SET @sql = REPLACE(@sql,''%DatabaseName%'',@db_name)

IF @process_from_rv IS NOT NULL
	SET @whereand = ''    AND tgt.row_version BETWEEN @process_from_rv AND @process_to_rv'';
ELSE
	SET @WhereAnd = ''    AND tgt.row_version <= @process_to_rv'';

SET @sql = REPLACE(@sql,''%WhereAnd%'',@whereand)

IF @DEBUG = 1 PRINT @SQL

EXEC sp_executeSQL @SQL, N''@process_from_rv BINARY(8), @process_to_rv BINARY(8)'', @process_from_rv, @process_to_rv

SELECT 
	@records = @@rowcount,
	@step_status = ''COMPLETED'',
	@step_completed_dt = GETUTCDATE()

IF @DEBUG = 0 BEGIN
	SET @step_status = ''COMPLETED''
	BEGIN TRANSACTION;
	--#region batch logging
    EXEC PDE.dbo.usp_process_batch_step_log
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@batch_id = @working_batch_id,
		@status = @step_status,
		@step_name = @step_name,
		@started_by = @started_by,
		@started_dt = @started_dt,
        @records = @records,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments;
	COMMIT TRANSACTION;
END; -- @DEBUG = 0

END TRY
BEGIN CATCH
    SELECT
		@error_dt = GETUTCDATE(),
		@error_message = ERROR_MESSAGE(),
		@error_number = ERROR_NUMBER(),
        @error_severity = ERROR_SEVERITY(),
        @error_state = ERROR_STATE();
	
    IF @@TRANCOUNT> 0 
		ROLLBACK TRANSACTION;

	IF @step_name is null
		SET @step_name = ''''
	PRINT ''ERROR: '' + @process_name + '' - '' + @step_name + '' - '' + CONVERT(VARCHAR(50), @error_number) + '' '' + CONVERT(VARCHAR(2048), @error_message)				
		
    GOTO ERROR_HANDLER
END CATCH


--#region ERROR HANDLING
ERROR_HANDLER:
IF @error_number <> 0 
BEGIN
	IF @step_name IS NULL SET @step_name =''UNKNOWN''

	IF @DEBUG = 0
	BEGIN
        --PRINT ''In ERROR_HANDLER'';
        --PRINT @batch_status
        --PRINT ''TRANSACTION count; '' + CAST(@@trancount as varchar(20))
	    EXEC dbo.usp_process_error_log
            @sweeper_distribution_id = @distribution_id,
            @sweeper_client_id = @sweeper_client_id,
		    @batch_id = @working_batch_id,
		    @step_name = @step_name,
		    @error_dt = @error_dt,
		    @error_message = @error_message,
		    @error_number = @error_number

	    IF @batch_status = ''STARTED''
        BEGIN         
	        SET @batch_status = ''FAILED''
            --#region batch logging
	        EXEC PDE.dbo.usp_process_batch_log
                @sweeper_distribution_id = @distribution_id,
                @sweeper_client_id = @sweeper_client_id,
		        @batch_id = @working_batch_id,
		        @status = @batch_status,
		        @process_from_rv = @process_from_rv,
		        @process_to_rv = @process_to_rv,
		        @step_name = NULL,
		        @started_by = @started_by,
		        @started_dt = @started_dt,
		        @completed_dt = @batch_completed_dt,
		        @comments = @process_comments,
	            @version = @version;

	        EXEC PDE.dbo.usp_process_log
		        @process_name = @process_name,
                @sweeper_distribution_id = @distribution_id,
                @sweeper_client_id = @sweeper_client_id,
		        @status = @batch_status,
		        @processed_from_rv = @process_from_rv,
		        @processed_to_rv = @process_to_rv,
		        @last_batch_id = @working_batch_id,
		        @working_batch_id = NULL,
		        @started_by = @started_by,
		        @started_dt = @started_dt,
		        @completed_dt = @batch_completed_dt,
		        @comments = @process_comments,
		        @version = @version;
            --#endregion
        END
    END; -- @DEBUG = 0
    ELSE PRINT ''Error ''+@error_message+'' in '' + @step_name + '' at '' + CONVERT(VARCHAR(50), GETUTCDATE(), 121)

    RAISERROR(@error_message, @error_severity, @error_state);
	RETURN 1;
END
--#endregion
	
IF @DEBUG = 0 BEGIN
	SELECT @batch_status = ''COMPLETED'',
        @batch_completed_dt = GETUTCDATE()

	BEGIN TRANSACTION;
	--#region batch logging

    EXEC PDE.dbo.usp_process_batch_log
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@batch_id = @working_batch_id,
		@status = @batch_status,
		@process_from_rv = @process_from_rv,
		@process_to_rv = @process_to_rv,
		@step_name = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
		@version = @version;

	EXEC PDE.dbo.usp_process_log
		@process_name = @process_name,
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@status = @batch_status,
		@processed_from_rv = @process_from_rv,
		@processed_to_rv = @process_to_rv,
		@last_batch_id = @working_batch_id,
		@working_batch_id = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
		@version = @version;

	COMMIT TRANSACTION;
END; -- @DEBUG = 0
RETURN
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_sweeper_permit_without_transactiontype_22]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_sweeper_permit_without_transactiontype_22]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[usp_sweeper_permit_without_transactiontype_22](
	@db_name varchar(255),
    @distribution_id BIGINT = NULL, --only for logging purpose
	@process_from_rv BINARY(8) = NULL,
	@process_to_rv BINARY(8) = NULL,
	@started_by NVARCHAR(50) = NULL,
	@parseToXml bit = 0, --return result as xml datetype
    @version NVARCHAR(50) = ''0.0.0.1'',
    @debug BIT = 0
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

BEGIN TRY

DECLARE
    @sweeper_client_id BIGINT

--#region initialization
DECLARE 
    @batch_completed_dt DATETIME,
    @batch_status NVARCHAR(50),
    @last_batch_id BIGINT,
    @max_capture_dt DATETIME,
    @process_comments NVARCHAR(2000),
    @process_name NVARCHAR(255),
    @processed_from_rv BINARY(8),
    @processed_to_rv BINARY(8),
    @records BIGINT,
    @started_dt DATETIME,
    @step_completed_dt DATETIME,
    @step_name NVARCHAR(255),
    @step_status NVARCHAR(50),
    @step_started_dt DATETIME,
    @working_batch_id BIGINT,
    @error_dt DATETIME,
    @error_message NVARCHAR(2048),
    @error_number NVARCHAR(50),
    @error_severity int,
    @error_state int;

--use dm_processes structure to log beginning of execution, update dm_processes and dm_process_batches
SET @started_dt = GETUTCDATE();
SET @process_name = OBJECT_NAME(@@PROCID);
IF (@process_name IS NULL) SET @process_name = ''usp_sweeper_permit_without_transactiontype_22''
IF (@started_by IS NULL) SET @started_by = SYSTEM_USER;

SELECT @sweeper_client_id = id FROM sweeper.sweeper_clients WHERE client_db_name = @db_name

SELECT 
    @batch_status = process_status, 
    @last_batch_id = last_batch_id, 
    @processed_to_rv = processed_to_rv
FROM PDE.dbo.sweeper_processes 
WHERE process_name = @process_name AND (sweeper_distribution_id = @distribution_id OR @distribution_id IS NULL)
AND sweeper_client_id = @sweeper_client_id

SET @working_batch_id = COALESCE(@last_batch_id, 0) + 1;

IF @DEBUG = 0 BEGIN
	SET @batch_status = ''STARTED''
	BEGIN TRANSACTION;
	--#region batch logging
    EXEC PDE.dbo.usp_process_batch_log
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@batch_id = @working_batch_id,
		@status = @batch_status,
		@process_from_rv = @process_from_rv,
		@process_to_rv = @process_to_rv,
		@step_name = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
	    @version = @version;

	EXEC PDE.dbo.usp_process_log
		@process_name = @process_name,
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@status = @batch_status,
        @processed_from_rv = @process_from_rv,
		@processed_to_rv = @process_to_rv,
		@last_batch_id = @last_batch_id,
		@working_batch_id = @working_batch_id,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
		@version = @version;


	COMMIT TRANSACTION;
END; -- @DEBUG = 0

IF @process_to_rv IS NULL
	EXEC dbo.usp_getDBTS
		@sweeper_client_id = @sweeper_client_id, 
		@to_rv = @process_to_rv OUTPUT,
		@debug = @debug;
IF @process_from_rv IS NULL
    SET @process_from_rv = @processed_to_rv

IF @DEBUG = 0 BEGIN
	BEGIN TRANSACTION;
	--#region batch logging
    EXEC PDE.dbo.usp_process_batch_log
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@batch_id = @working_batch_id,
		@status = @batch_status,
		@process_from_rv = @process_from_rv,
		@process_to_rv = @process_to_rv,
		@step_name = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
	    @version = @version;

	COMMIT TRANSACTION;
END; -- @DEBUG = 0

IF @DEBUG = 1 BEGIN
    PRINT @process_name + '' - '' + CONVERT(VARCHAR(50), @started_dt, 121)
    PRINT ''@process_from_rv - '' + ISNULL(CONVERT(VARCHAR(30), @process_from_rv, 1), ''NULL'')
    PRINT ''@process_to_rv - '' + ISNULL(CONVERT(VARCHAR(30), @process_to_rv, 1), ''NULL'')
    PRINT @process_comments
END; -- @DEBUG = 1

--#region SAFEGUARDS
IF @DEBUG = 0 BEGIN
-- retry if the process is already running
	IF dbo.udf_get_proc_running_cnt(DB_ID(), @@PROCID) > 1 OR(dbo.udf_get_proc_running_cnt(DB_ID(), @@PROCID) IS NULL AND @batch_status = ''STARTED'')
	BEGIN				
		SET @error_message = ''Process %s is in %s state. Processing Halted.''
		SET @batch_status = ''STARTED''
        SET @error_number = 50000
	
		RAISERROR(
			@error_message,
			16, -- Severity.
			1, -- State.
			@process_name,
			@batch_status
		);
	END
END; -- @DEBUG = 0
--#endregion

--region log order capture start
SELECT 
	@step_name = ''1. Capture data'',
	@step_status = ''STARTED'',
	@step_started_dt = GETUTCDATE(),
	@records = 0,
	@step_completed_dt = NULL

DECLARE @sql NVARCHAR(MAX) = '''',
    @WhereAnd NVARCHAR(MAX) = '''';

IF OBJECT_ID(''tempdb.dbo.#temp'') IS NULL
    CREATE TABLE #temp(data XML)

SET @sql = ''
SELECT tgt.permitnumber
FROM permits tgt (NOLOCK)
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.PERMIT_ID = tgt.PERMIT_ID
    AND t.TRANSACTIONTYPE = 22)
%WhereAnd%''

IF @parseToXml = 1
    SET @sql = ''INSERT INTO #temp SELECT ('' + @sql + CHAR(10) + ''FOR XML PATH(''''node''''), TYPE)''

SET @sql = ''USE %DatabaseName%'' +CHAR(10) + @sql
SET @sql = REPLACE(@sql,''%DatabaseName%'',@db_name)

IF @process_from_rv IS NOT NULL
	SET @whereand = ''    AND tgt.row_version BETWEEN @process_from_rv AND @process_to_rv'';
ELSE
	SET @WhereAnd = ''    AND tgt.row_version <= @process_to_rv'';

SET @sql = REPLACE(@sql,''%WhereAnd%'',@whereand)

IF @DEBUG = 1 PRINT @SQL

EXEC sp_executeSQL @SQL, N''@process_from_rv BINARY(8), @process_to_rv BINARY(8)'', @process_from_rv, @process_to_rv

SELECT 
	@records = @@rowcount,
	@step_status = ''COMPLETED'',
	@step_completed_dt = GETUTCDATE()

IF @DEBUG = 0 BEGIN
	SET @step_status = ''COMPLETED''
	BEGIN TRANSACTION;
	--#region batch logging
    EXEC PDE.dbo.usp_process_batch_step_log
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@batch_id = @working_batch_id,
		@status = @step_status,
		@step_name = @step_name,
		@started_by = @started_by,
		@started_dt = @started_dt,
        @records = @records,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments;
	COMMIT TRANSACTION;
END; -- @DEBUG = 0

END TRY
BEGIN CATCH
    SELECT
		@error_dt = GETUTCDATE(),
		@error_message = ERROR_MESSAGE(),
		@error_number = ERROR_NUMBER(),
        @error_severity = ERROR_SEVERITY(),
        @error_state = ERROR_STATE();
	
    IF @@TRANCOUNT> 0 
		ROLLBACK TRANSACTION;

	IF @step_name is null
		SET @step_name = ''''
	PRINT ''ERROR: '' + @process_name + '' - '' + @step_name + '' - '' + CONVERT(VARCHAR(50), @error_number) + '' '' + CONVERT(VARCHAR(2048), @error_message)				
		
    GOTO ERROR_HANDLER
END CATCH


--#region ERROR HANDLING
ERROR_HANDLER:
IF @error_number <> 0 
BEGIN
	IF @step_name IS NULL SET @step_name =''UNKNOWN''

	IF @DEBUG = 0
	BEGIN
        --PRINT ''In ERROR_HANDLER'';
        --PRINT @batch_status
        --PRINT ''TRANSACTION count; '' + CAST(@@trancount as varchar(20))
	    EXEC dbo.usp_process_error_log
            @sweeper_distribution_id = @distribution_id,
            @sweeper_client_id = @sweeper_client_id,
		    @batch_id = @working_batch_id,
		    @step_name = @step_name,
		    @error_dt = @error_dt,
		    @error_message = @error_message,
		    @error_number = @error_number

	    IF @batch_status = ''STARTED''
        BEGIN         
	        SET @batch_status = ''FAILED''
            --#region batch logging
	        EXEC PDE.dbo.usp_process_batch_log
                @sweeper_distribution_id = @distribution_id,
                @sweeper_client_id = @sweeper_client_id,
		        @batch_id = @working_batch_id,
		        @status = @batch_status,
		        @process_from_rv = @process_from_rv,
		        @process_to_rv = @process_to_rv,
		        @step_name = NULL,
		        @started_by = @started_by,
		        @started_dt = @started_dt,
		        @completed_dt = @batch_completed_dt,
		        @comments = @process_comments,
	            @version = @version;

	        EXEC PDE.dbo.usp_process_log
		        @process_name = @process_name,
                @sweeper_distribution_id = @distribution_id,
                @sweeper_client_id = @sweeper_client_id,
		        @status = @batch_status,
		        @processed_from_rv = @process_from_rv,
		        @processed_to_rv = @process_to_rv,
		        @last_batch_id = @working_batch_id,
		        @working_batch_id = NULL,
		        @started_by = @started_by,
		        @started_dt = @started_dt,
		        @completed_dt = @batch_completed_dt,
		        @comments = @process_comments,
		        @version = @version;
            --#endregion
        END
    END; -- @DEBUG = 0
    ELSE PRINT ''Error ''+@error_message+'' in '' + @step_name + '' at '' + CONVERT(VARCHAR(50), GETUTCDATE(), 121)

    RAISERROR(@error_message, @error_severity, @error_state);
	RETURN 1;
END
--#endregion
	
IF @DEBUG = 0 BEGIN
	SELECT @batch_status = ''COMPLETED'',
        @batch_completed_dt = GETUTCDATE()

	BEGIN TRANSACTION;
	--#region batch logging

    EXEC PDE.dbo.usp_process_batch_log
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@batch_id = @working_batch_id,
		@status = @batch_status,
		@process_from_rv = @process_from_rv,
		@process_to_rv = @process_to_rv,
		@step_name = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
		@version = @version;

	EXEC PDE.dbo.usp_process_log
		@process_name = @process_name,
        @sweeper_distribution_id = @distribution_id,
        @sweeper_client_id = @sweeper_client_id,
		@status = @batch_status,
		@processed_from_rv = @process_from_rv,
		@processed_to_rv = @process_to_rv,
		@last_batch_id = @working_batch_id,
		@working_batch_id = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
		@version = @version;

	COMMIT TRANSACTION;
END; -- @DEBUG = 0
RETURN
' 
END
GO
/****** Object:  StoredProcedure [sweeper].[usp_PDE_ANET_sweeper]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[usp_PDE_ANET_sweeper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [sweeper].[usp_PDE_ANET_sweeper](
    @started_by NVARCHAR(50) = NULL,
    @version NVARCHAR(50) = ''0.0.0.1'',
    @DEBUG BIT = 0,
    @TaskName NVARCHAR(100)=NULL,
    @DBName NVARCHAR(100)=NULL
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
--#region documentation
-- SOURCE svn path
-- DATABASE PDE
-- SCHEMA sweeper
-- PROCEDURE executor
-- PARAMETERS
--  @DEBUG               - do not modify database, only output records and statistics
--
-- PROCESSING
-- execute all sweeper procedures that are due for execution based on schedulues
-- 
--
-- TABLES
-- DATABASE PDE
--  sweeper_issue_type
--  sweeper_issue_severity
--  sweeper_issue_clients
--  sweeper_issue_tasks
--  sweeper_results
--  sweeper_processes
--
-- FUTURE DEVELOPMENT 
--
-- CHANGE LOG
-- 2015-08-XX - dellis - Created

--#endregion

--#region initialization
DECLARE 
    @batch_completed_dt DATETIME,
    @batch_status NVARCHAR(50),
    @error_dt DATETIME,
    @error_message NVARCHAR(2048),
    @error_number NVARCHAR(50),
    @last_batch_id BIGINT,
    @max_capture_dt DATETIME,
    @process_comments NVARCHAR(2000),
    @process_name NVARCHAR(255),
    @processed_from_rv BINARY(8),
    @processed_to_rv BINARY(8),
    @process_from_rv BINARY(8),
    @process_to_rv BINARY(8),
    @records BIGINT,
    @started_dt DATETIME,
    @step_completed_dt DATETIME,
    @step_name NVARCHAR(255),
    @step_status NVARCHAR(50),
    @step_started_dt DATETIME,
    @working_batch_id BIGINT;


--use dm_processes structure to log beginning of execution, update dm_processes and dm_process_batches
SET @started_dt = GETUTCDATE();
SET @process_name = OBJECT_NAME(@@PROCID);
IF (@process_name IS NULL) SET @process_name = ''usp_PDE_ANET_sweeper''
IF (@started_by IS NULL) SET @started_by = SYSTEM_USER;

SELECT 
    @batch_status = process_status, 
    @last_batch_id = last_batch_id
FROM PDE.dbo.sweeper_processes 
WHERE process_name = @process_name AND sweeper_client_id IS NULL;

SET @working_batch_id = COALESCE(@last_batch_id, 0) + 1;

IF @DEBUG = 1 BEGIN
    PRINT @process_name + '' - '' + CONVERT(VARCHAR(50), @started_dt, 121)
    PRINT @process_comments
END; -- @DEBUG = 1

IF @DEBUG = 0 BEGIN
    SET @batch_status = ''STARTED''
    BEGIN TRANSACTION;
    --#region batch logging
    EXEC PDE.dbo.usp_process_log
        @process_name = @process_name,
        @status = @batch_status,
        @processed_from_rv = @processed_from_rv,
        @processed_to_rv = @processed_to_rv,
        @last_batch_id = @last_batch_id,
        @working_batch_id = @working_batch_id,
        @started_by = @started_by,
        @started_dt = @started_dt,
        @completed_dt = @batch_completed_dt,
        @comments = @process_comments,
        @version = @version;

    COMMIT TRANSACTION;
END; -- @DEBUG = 0


--select processes that currently need to run
--based on next_execution_dt in distribution table
--if next_execution_dt < getutcdate() then execution it
DECLARE @stored_procedure_name VARCHAR(100),
        @sweeper_task_id BIGINT,
        @sweeper_client_id BIGINT,
        @is_all_clients BIT,
        @client_db_name NVARCHAR(100),
        @distribution_id BIGINT,
        @frequency_type NVARCHAR(10),
        @frequency_interval INT;
        
DECLARE
    @SQL NVARCHAR(MAX) = '''',
    @object_id INT

DECLARE tasks_cursor CURSOR READ_ONLY FAST_FORWARD
FOR
    SELECT st.id, st.stored_procedure_name, c.id sweeper_client_id, c.client_db_name, d.id distribution_id, 
        d.frequency_type, d.frequency_interval, sp.processed_to_rv
    FROM sweeper.sweeper_tasks st
    INNER JOIN sweeper.distributions d ON st.id = d.sweeper_task_id
    INNER JOIN sweeper.sweeper_clients c ON c.id = d.sweeper_client_id
    LEFT JOIN dbo.sweeper_processes sp ON sp.sweeper_distribution_id = d.id AND c.id = sp.sweeper_client_id 
    WHERE @started_dt BETWEEN active_start_dt AND ISNULL(active_end_dt,''2020-12-31'')
        AND next_run_dt <= @started_dt
        AND d.enabled = 1
        --Add new parameter to pass task name 
        AND (st.sweeper_name=@TaskName OR @TaskName IS NULL)
        AND (c.client_db_name = @DBName OR @DBName IS NULL)
    UNION
    SELECT st.id, st.stored_procedure_name, c.id sweeper_client_id, c.client_db_name, d.id distribution_id, 
        d.frequency_type, d.frequency_interval, sp.processed_to_rv
    FROM sweeper.sweeper_tasks st
    INNER JOIN sweeper.distributions d ON st.id = d.sweeper_task_id
    CROSS JOIN sweeper.sweeper_clients c 
    LEFT JOIN sweeper_processes sp ON sp.sweeper_distribution_id = d.id AND c.id = sp.sweeper_client_id
    WHERE @started_dt BETWEEN active_start_dt AND ISNULL(active_end_dt,''2020-12-31'')
        AND next_run_dt <= @started_dt
        AND d.enabled = 1
        AND d.is_all_clients = 1
        --Add new parameter to pass task name 
        AND (st.sweeper_name=@TaskName OR @TaskName IS NULL)


OPEN tasks_cursor
FETCH NEXT FROM tasks_cursor 
INTO @sweeper_task_id, @stored_procedure_name, @sweeper_client_id, @client_db_name, @distribution_id, 
    @frequency_type, @frequency_interval, @process_from_rv

IF OBJECT_ID(''tempdb.dbo.#temp'') IS NOT NULL
    DROP TABLE #temp

CREATE TABLE #temp(data XML)

WHILE @@FETCH_STATUS = 0
BEGIN

    SET @started_dt = GETUTCDATE();

    SET @object_id = object_id(''dbo.'' + @stored_procedure_name);

    IF @object_id IS NOT NULL
    BEGIN

        BEGIN TRY       

            -- clean-up
            DELETE FROM #temp

            -- populate temp table                
            IF @DEBUG = 1 PRINT ''populate temp table''

            SET @SQL = ''EXEC dbo.'' + @stored_procedure_name 
                    + '' @db_name = ''''''+ @client_db_name 
                    + '''''',@distribution_id = '' + CAST(@distribution_id AS VARCHAR(20)) 
                    + '',@process_from_rv = '' + ISNULL(CONVERT(VARCHAR(30), @process_from_rv, 1), ''NULL'') 
                    + '',@started_by = '''''' + @started_by 
                    + '''''',@parseToXml = '' + ''1''

            IF @DEBUG = 1 
            BEGIN
                SET @SQL = @SQL + '', @debug = 1''
            END

            PRINT @SQL
            EXEC(@SQL);

            SET @step_completed_dt = GETUTCDATE();

            --Debugging mode
            IF @DEBUG=1 
                SELECT data FROM #temp
            ELSE
            BEGIN
                IF EXISTS(SELECT 1 FROM #temp WHERE data IS NOT NULL)
                BEGIN
                    INSERT INTO dbo.sweeper_results
                            (sweeper_distribution_id, sweeper_task_id, sweeper_client_id, client_db_name, 
                           started_dt, completed_dt, data)
                    SELECT @distribution_id, @sweeper_task_id, @sweeper_client_id, @client_db_name, 
                        @started_dt, @step_completed_dt, data
                    FROM #temp
                END
            END

            --update next run date for current task
            SET @SQL = '''';
            SET @SQL = ''UPDATE sweeper.distributions
                SET next_run_dt = (select dateadd('' + @frequency_type + '','' + cast(@frequency_interval as nvarchar) 
                + '','''''' + cast(@started_dt as nvarchar) + '''''')),
                    last_run_dt = '''''' + cast(@started_dt as nvarchar) + ''''''
                WHERE id = '' + cast(@distribution_id as nvarchar)
                
            IF @DEBUG=0 EXEC(@SQL);

            SET @step_completed_dt = GETUTCDATE();
        
        END TRY

        BEGIN CATCH
            WHILE @@trancount > 0 ROLLBACK TRANSACTION;
            --THROW;
        END CATCH
            
    END

    FETCH NEXT FROM tasks_cursor 
    INTO @sweeper_task_id, @stored_procedure_name, @sweeper_client_id, @client_db_name, @distribution_id, 
            @frequency_type, @frequency_interval, @process_from_rv
END  

CLOSE tasks_cursor  
DEALLOCATE tasks_cursor 


IF @DEBUG = 0 BEGIN
    SET @batch_status = ''COMPLETED''
    SET @step_completed_dt = GETUTCDATE();
    BEGIN TRANSACTION;
    --#region batch logging
    EXEC PDE.dbo.usp_process_log
        @process_name = @process_name,
        @status = @batch_status,
        @processed_from_rv = @processed_from_rv,
        @processed_to_rv = @processed_to_rv,
        @last_batch_id = @working_batch_id,
        @working_batch_id = NULL,
        @started_by = @started_by,
        @started_dt = @started_dt,
        @completed_dt = @step_completed_dt,
        @comments = @process_comments,
        @version = @version;

    COMMIT TRANSACTION;
END; -- @DEBUG = 0

RETURN
' 
END
GO
/****** Object:  StoredProcedure [sweeper].[usp_PDE_ANET_sweeper_email_results]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[usp_PDE_ANET_sweeper_email_results]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [sweeper].[usp_PDE_ANET_sweeper_email_results](
	@process_from_dt DATETIME = NULL,
	@process_to_dt DATETIME = NULL,
	@started_by NVARCHAR(50) = NULL,
	@severity_ids VARCHAR(50) = ''1,2,3,4'',
	@version NVARCHAR(50) = ''0.0.0.1'',
	@DEBUG BIT = 0
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON


--#region initialization
DECLARE 
    @batch_completed_dt DATETIME,
    @batch_status NVARCHAR(50),
    @error_dt DATETIME,
    @error_message NVARCHAR(2048),
    @error_number NVARCHAR(50),
    @last_batch_id BIGINT,
    @max_capture_dt DATETIME,
    @process_comments NVARCHAR(2000),
    @process_name NVARCHAR(255),
    @processed_to_dt DATETIME,
    @records BIGINT,
    @started_dt DATETIME,
    @step_completed_dt DATETIME,
    @step_name NVARCHAR(255),
    @step_status NVARCHAR(50),
    @step_started_dt DATETIME,
    @working_batch_id BIGINT;

CREATE TABLE #task_output_columns (
    th_name varchar(100),
    parse_from_xml bit --identity if it''s a column for xml parse
    --,UNIQUE (th_name) WITH(IGNORE_DUP_KEY=ON)
    )

--use dm_processes structure to log beginning of execution, update dm_processes and dm_process_batches
SET @started_dt = GETUTCDATE();
SET @process_name = OBJECT_NAME(@@PROCID);
IF (@process_name IS NULL) SET @process_name = ''usp_PDE_ANET_sweeper_email_results''
IF (@started_by IS NULL) SET @started_by = SYSTEM_USER;

SELECT 
    @batch_status = process_status, 
    @last_batch_id = last_batch_id, 
    @processed_to_dt = processed_to_dt 
FROM PDE.dbo.sweeper_processes 
WHERE process_name = @process_name;

IF (@process_from_dt IS NULL) SET @process_from_dt = COALESCE(@processed_to_dt, ''2007-01-01'');
IF (@process_to_dt IS NULL) SET @process_to_dt = @started_dt;
SET @working_batch_id = COALESCE(@last_batch_id, 0) + 1;

IF @DEBUG = 1 BEGIN
    PRINT @process_name + '' - '' + CONVERT(VARCHAR(50), @started_dt, 121)
    PRINT ''@process_from_dt - '' + CAST(@process_from_dt AS VARCHAR(50))
    PRINT ''@process_to_dt - '' + CAST(@process_to_dt AS VARCHAR(50))
    PRINT @process_comments
END; -- @DEBUG = 1

IF @DEBUG = 0 BEGIN
	SET @batch_status = ''STARTED''
	BEGIN TRANSACTION;
	--#region batch logging
    EXEC PDE.dbo.usp_process_log
		@process_name = @process_name,
		@status = @batch_status,
		@processed_to_dt = @processed_to_dt,
		@last_batch_id = @last_batch_id,
		@working_batch_id = @working_batch_id,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
		@version = @version;

	COMMIT TRANSACTION;
END; -- @DEBUG = 0


DECLARE @body NVARCHAR(MAX),
		@recipient_list NVARCHAR(MAX),
		@cc_list NVARCHAR(MAX);
DECLARE @html NVARCHAR(MAX) = NULL,
        @th_html NVARCHAR(MAX) = '''';
DECLARE @task_html NVARCHAR(MAX) = NULL;
DECLARE @sweeper_issue_type_id INT;
DECLARE @sweeper_issue_type_name NVARCHAR(100);
DECLARE @sweeper_task_id INT;
DECLARE @sweeper_task_name NVARCHAR(100);
DECLARE @sweeper_severity VARCHAR(50);
DECLARE @email_subject NVARCHAR(100);
DECLARE @issuetype_fetch_status INT;
DECLARE @tasks_fetch_status INT;
DECLARE @sql NVARCHAR(MAX);

--we''ll send one email per issue type (eg. Data Quality issues are all in one email).  Only send emails if there are subscribers, hence the following cursor.
DECLARE task_cusor CURSOR READ_ONLY FAST_FORWARD
FOR
	SELECT DISTINCT s.sweeper_issue_type_id, si.type_name, s.sweeper_task_id, st.sweeper_name
	FROM sweeper.sweeper_subscriptions s
	INNER JOIN sweeper.sweeper_issue_type si ON s.sweeper_issue_type_id = si.parent_issue_type_id
	INNER JOIN sweeper.sweeper_tasks st ON st.issue_type_id = si.id AND st.id = s.sweeper_task_id
	INNER JOIN dbo.sweeper_results sr ON sr.sweeper_task_id = st.id
	WHERE sr.started_dt >= @process_from_dt
			AND sr.started_dt <  @process_to_dt
			AND si.severity_id in (SELECT string FROM PDE.dbo.fnParseString(@severity_ids, '',''))

OPEN task_cusor
FETCH NEXT FROM task_cusor INTO @sweeper_issue_type_id, @sweeper_issue_type_name, @sweeper_task_id, @sweeper_task_name

WHILE @@FETCH_STATUS = 0
BEGIN
    
    SET @html = '''';
    SET @sql = '''';
    SET @task_html = '''';
    SET @th_html = '''';

	SET @body = ''<html><head>'' + ''<style>'' + ''table, td, th ''
			+ ''{border:1px solid black;} ''
            + ''table {border-collapse: collapse} ''
			+ ''th {background-color:#D0D0D0;color:black;font-size:9pt}''
			+ ''td {background-color:#F0F0F0;color:black;font-size:9pt}'' + ''</style>''
			+ ''</head>'' + ''<body><H2>ActiveNet Sweeper Results</H2>

		<H4>'' + CONVERT(VARCHAR(10), COALESCE(@process_from_dt,0), 101) + '' - ''
			+ CONVERT(VARCHAR(10), COALESCE(@process_to_dt,0), 101)
			+ ''</H4>''

        DELETE FROM #task_output_columns

        INSERT INTO #task_output_columns
        SELECT ''Client Name'', 0

        INSERT INTO #task_output_columns
        SELECT cols.value(''local-name(.)[1]'', ''varchar(100)''), 1
        FROM (SELECT TOP 1 data FROM sweeper_results sr WHERE sr.sweeper_task_id = @sweeper_task_id ORDER BY sr.id DESC) AS result(data)
        CROSS APPLY data.nodes(''//node[1]/child::node()'') AS ext(cols)

        SELECT @th_html = CONCAT(@th_html, ''<th>'', th_name, ''</th>'') FROM #task_output_columns

        SELECT @sql = CONCAT(@sql, '', ''''<td>'''', cols.value(''''('', th_name, '')[1]'''', ''''varchar(100)''''), ''''</td>'''''' )
        FROM #task_output_columns
        WHERE parse_from_xml = 1

        SET @sql = CONCAT(''SELECT @task_html = CONCAT(@task_html,CONCAT(''''<tr><td>'''',sr.client_db_name, ''''</td>'''''', @sql, 
            '',''''</tr>''''), CHAR(10)) 
            from sweeper_results sr 
            INNER JOIN sweeper.sweeper_tasks st ON sr.sweeper_task_id = st.id
			INNER JOIN sweeper.sweeper_clients sc ON sr.sweeper_client_id = sc.id
			INNER JOIN sweeper.sweeper_issue_type si ON st.issue_type_id = si.id
            CROSS APPLY data.nodes(''''//node'''') AS ext(cols)
			WHERE si.parent_issue_type_id = @sweeper_issue_type_id
                AND st.id = @sweeper_task_id
				AND sr.started_dt >= @process_from_dt
				AND sr.started_dt <  @process_to_dt
				AND si.severity_id in (SELECT string FROM PDE.dbo.fnParseString(@severity_ids, '''','''')) '')
              
        EXEC sys.sp_executesql @sql, N''@sweeper_issue_type_id INT, @sweeper_task_id INT, @process_from_dt DATETIME, @process_to_dt DATETIME, @severity_ids VARCHAR(50), @task_html NVARCHAR(MAX) OUTPUT'', 
                                @sweeper_issue_type_id, @sweeper_task_id, @process_from_dt, @process_to_dt, @severity_ids, @task_html = @task_html OUTPUT

		IF @task_html <> '''' 
        BEGIN
            SET @body = @body + ''<h3>'' + @sweeper_issue_type_name + ''</h3>'';
            SET @task_html = ''<h4>'' + @sweeper_task_name + ''</h4><table border=1><thead><tr>'' + @th_html + ''</tr></thead><tbody>''+ @task_html + ''</tbody></table>'';
		    SET @html = COALESCE(@html,N'''') + @task_html;
		    SET @body = @body + @html + ''</body></html>'';

		    SET @recipient_list = (SELECT sweeper.getSweeperSubscriptionRecipients(@sweeper_task_id, ''TO'') AS to_list)
            SET @cc_list =  (SELECT sweeper.getSweeperSubscriptionRecipients(@sweeper_task_id, ''CC'') AS to_list)
		    SET @email_subject = CAST(@sweeper_issue_type_name AS NVARCHAR) + '' - '' + CAST(@sweeper_task_name AS NVARCHAR(50)) + '' Issues'' 
                                    + '' - '' + CAST(@@servername AS NVARCHAR);
			EXEC msdb.dbo.sp_send_dbmail
				@profile_name = ''DB Messaging'', 
				@body = @body,
				@body_format = ''HTML'',
				@recipients = @recipient_list,
				@copy_recipients = @cc_list,
				@subject = @email_subject;
        END

	FETCH NEXT FROM task_cusor INTO @sweeper_issue_type_id, @sweeper_issue_type_name, @sweeper_task_id, @sweeper_task_name
END  

CLOSE task_cusor  
DEALLOCATE task_cusor 

SET @batch_completed_dt = GETUTCDATE();

IF @DEBUG = 0 BEGIN
	SET @batch_status = ''COMPLETED''
	BEGIN TRANSACTION;

    --#region batch logging
    EXEC PDE.dbo.usp_process_log
		@process_name = @process_name,
		@status = @batch_status,
        @processed_from_dt = @processed_to_dt,
		@processed_to_dt = @process_to_dt,
		@last_batch_id = @working_batch_id,
		@working_batch_id = NULL,
		@started_by = @started_by,
		@started_dt = @started_dt,
		@completed_dt = @batch_completed_dt,
		@comments = @process_comments,
		@version = @version;

	COMMIT TRANSACTION;
END; -- @DEBUG = 0

RETURN' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnParseString]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnParseString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fnParseString] (@string NVARCHAR(MAX),@separator NCHAR(1))
RETURNS @parsedString TABLE(string NVARCHAR(MAX))
AS 
BEGIN
	DECLARE @position int = 1;
	SET @string = @string + @separator;

	WHILE CHARINDEX(@separator, @string, @position) <> 0
		BEGIN
			INSERT into @parsedString SELECT SUBSTRING(@string, @position, CHARINDEX(@separator, @string, @position) - @position);
			SET @position = CHARINDEX(@separator, @string, @position) + 1;
		END;

	RETURN;
END;
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[udf_get_proc_running_cnt]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_get_proc_running_cnt]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[udf_get_proc_running_cnt](
    @db_id INT,
    @obj_id INT
)
RETURNS INT -- count of requests executing the object
AS
BEGIN
    RETURN(
        SELECT COUNT(*) 
        FROM sys.dm_exec_requests AS re1 CROSS APPLY sys.dm_exec_sql_text(re1.sql_handle) AS st1
        WHERE st1.objectid = @obj_id AND st1.dbid = @db_id
    )
END
' 
END

GO
/****** Object:  UserDefinedFunction [sweeper].[getSweeperSubscriptionRecipients]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[getSweeperSubscriptionRecipients]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [sweeper].[getSweeperSubscriptionRecipients](
	@sweeper_task_id BIGINT,
    @type varchar(20)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
RETURN
 	STUFF((			 
		SELECT '';'' + email
		FROM  [sweeper].[sweeper_subscriptions]
		WHERE 
			sweeper_task_id = @sweeper_task_id
			AND enabled = 1
            AND type = @type
		ORDER BY id
		FOR XML PATH('''')
		), 
		1, 1, ''''
	);
END;

' 
END

GO
/****** Object:  Table [dbo].[emily]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[emily]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[emily](
	[ORG_ID] [int] NOT NULL,
	[ACTIVITY_PACKAGE_CATEGORIES_ID] [int] NOT NULL,
	[ACTIVITY_PACKAGE_ID] [int] NULL,
	[RG_CATEGORY_ID] [int] NULL,
	[RG_SUB_CATEGORY_ID] [int] NULL,
	[NUM_ACTIVITIES_TO_ENROLL] [int] NULL,
	[NUM_ACTIVITIES_TO_ENROLL_MAX] [int] NULL,
	[ROW_VERSION] [binary](8) NULL,
	[meta_created] [datetime] NOT NULL,
	[meta_updated] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KitManagerValidation]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KitManagerValidation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[KitManagerValidation](
	[ID] [int] IDENTITY(100,1) NOT NULL,
	[ServerName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DatabaseName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedBy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[process_batch_steps]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[process_batch_steps]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[process_batch_steps](
	[sweeper_distribution_id] [bigint] NOT NULL,
	[sweeper_client_id] [bigint] NOT NULL,
	[batch_id] [bigint] NOT NULL,
	[step_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[step_status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[started_by] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[started_dt] [datetime] NOT NULL,
	[completed_dt] [datetime] NULL,
	[records] [bigint] NULL,
	[step_comments] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_dm_process_batch_steps] PRIMARY KEY CLUSTERED 
(
	[sweeper_distribution_id] ASC,
	[sweeper_client_id] ASC,
	[batch_id] ASC,
	[step_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[process_batches]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[process_batches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[process_batches](
	[sweeper_distribution_id] [bigint] NOT NULL,
	[sweeper_client_id] [bigint] NOT NULL,
	[batch_id] [bigint] NOT NULL,
	[batch_status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[process_from_rv] [binary](8) NULL,
	[process_to_rv] [binary](8) NULL,
	[step_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[started_by] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[started_dt] [datetime] NOT NULL,
	[completed_dt] [datetime] NULL,
	[batch_comments] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[process_version] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_dm_process_batches] PRIMARY KEY CLUSTERED 
(
	[sweeper_distribution_id] ASC,
	[sweeper_client_id] ASC,
	[batch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[process_errors]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[process_errors]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[process_errors](
	[sweeper_distribution_id] [bigint] NOT NULL,
	[sweeper_client_id] [bigint] NOT NULL,
	[batch_id] [bigint] NOT NULL,
	[step_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[error_dt] [datetime] NOT NULL,
	[error_message] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[error_number] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_process_errors] PRIMARY KEY CLUSTERED 
(
	[sweeper_distribution_id] ASC,
	[sweeper_client_id] ASC,
	[batch_id] ASC,
	[step_name] ASC,
	[error_dt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[sweeper_processes]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sweeper_processes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[sweeper_processes](
	[process_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sweeper_distribution_id] [bigint] NULL,
	[sweeper_client_id] [bigint] NULL,
	[process_status] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processed_from_dt] [datetime] NULL,
	[processed_to_dt] [datetime] NULL,
	[processed_from_rv] [binary](8) NULL,
	[processed_to_rv] [binary](8) NULL,
	[last_batch_id] [bigint] NULL,
	[working_batch_id] [bigint] NULL,
	[started_by] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[started_dt] [datetime] NULL,
	[completed_dt] [datetime] NULL,
	[process_comments] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[process_version] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sweeper_results]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sweeper_results]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[sweeper_results](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[sweeper_distribution_id] [bigint] NOT NULL,
	[sweeper_task_id] [bigint] NOT NULL,
	[sweeper_client_id] [bigint] NOT NULL,
	[client_db_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[started_dt] [datetime] NULL,
	[completed_dt] [datetime] NULL,
	[data] [xml] NULL,
 CONSTRAINT [PK_sweeper_result] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[System_Strings]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_Strings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_Strings](
	[Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Value] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Created_By] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Created_DT] [datetime] NOT NULL,
	[Modified_By] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Modified_DT] [datetime] NOT NULL,
 CONSTRAINT [System_Strings_pk] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [sweeper].[distributions]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[distributions]') AND type in (N'U'))
BEGIN
CREATE TABLE [sweeper].[distributions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[sweeper_task_id] [bigint] NOT NULL,
	[sweeper_client_id] [bigint] NULL,
	[is_all_clients] [bit] NULL,
	[enabled] [bit] NOT NULL,
	[frequency_type] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[frequency_interval] [int] NULL,
	[active_start_dt] [datetime] NULL,
	[active_end_dt] [datetime] NULL,
	[last_run_dt] [datetime] NULL,
	[next_run_dt] [datetime] NULL,
	[created_dt] [datetime] NULL,
	[modified_dt] [datetime] NULL,
	[created_by] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[modified_by] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_distributions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [sweeper].[sweeper_clients]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[sweeper_clients]') AND type in (N'U'))
BEGIN
CREATE TABLE [sweeper].[sweeper_clients](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[client_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[client_db_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_dt] [datetime] NULL,
	[modified_dt] [datetime] NULL,
	[created_by] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[modified_by] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_sweeper_clients] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [sweeper].[sweeper_issue_severity]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[sweeper_issue_severity]') AND type in (N'U'))
BEGIN
CREATE TABLE [sweeper].[sweeper_issue_severity](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[type] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_sweeper_issue_severity] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sweeper].[sweeper_issue_type]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[sweeper_issue_type]') AND type in (N'U'))
BEGIN
CREATE TABLE [sweeper].[sweeper_issue_type](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[type_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[type_description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_issue_type_id] [bigint] NULL,
	[severity_id] [tinyint] NULL,
	[created_dt] [datetime] NOT NULL,
	[modified_dt] [datetime] NOT NULL,
	[created_by] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[modified_by] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_sweeper_issue_type] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [sweeper].[sweeper_subscriptions]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[sweeper_subscriptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [sweeper].[sweeper_subscriptions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[sweeper_issue_type_id] [bigint] NULL,
	[sweeper_task_id] [bigint] NULL,
	[email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[enabled] [bit] NULL,
	[created_dt] [datetime] NULL,
	[modified_dt] [datetime] NULL,
	[created_by] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[modified_by] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_sweeper_subscriptions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sweeper].[sweeper_tasks]    Script Date: 5/7/2018 1:45:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sweeper].[sweeper_tasks]') AND type in (N'U'))
BEGIN
CREATE TABLE [sweeper].[sweeper_tasks](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[sweeper_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[issue_type_id] [bigint] NULL,
	[issue_description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stored_procedure_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_sweeper_tasks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[System_Strings_Created_By_df]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[System_Strings] ADD  CONSTRAINT [System_Strings_Created_By_df]  DEFAULT (original_login()) FOR [Created_By]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[System_Strings_Created_DT_df]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[System_Strings] ADD  CONSTRAINT [System_Strings_Created_DT_df]  DEFAULT (sysutcdatetime()) FOR [Created_DT]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sweeper].[DF__distribut__is_al__1ED998B2]') AND type = 'D')
BEGIN
ALTER TABLE [sweeper].[distributions] ADD  DEFAULT ((0)) FOR [is_all_clients]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_sweeper_result_sweeper_task_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[sweeper_results]'))
ALTER TABLE [dbo].[sweeper_results]  WITH CHECK ADD  CONSTRAINT [FK_sweeper_result_sweeper_task_id] FOREIGN KEY([sweeper_task_id])
REFERENCES [sweeper].[sweeper_tasks] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_sweeper_result_sweeper_task_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[sweeper_results]'))
ALTER TABLE [dbo].[sweeper_results] CHECK CONSTRAINT [FK_sweeper_result_sweeper_task_id]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_distributions_sweeper_client_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[distributions]'))
ALTER TABLE [sweeper].[distributions]  WITH CHECK ADD  CONSTRAINT [FK_distributions_sweeper_client_id] FOREIGN KEY([sweeper_client_id])
REFERENCES [sweeper].[sweeper_clients] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_distributions_sweeper_client_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[distributions]'))
ALTER TABLE [sweeper].[distributions] CHECK CONSTRAINT [FK_distributions_sweeper_client_id]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_distributions_sweeper_task_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[distributions]'))
ALTER TABLE [sweeper].[distributions]  WITH CHECK ADD  CONSTRAINT [FK_distributions_sweeper_task_id] FOREIGN KEY([sweeper_task_id])
REFERENCES [sweeper].[sweeper_tasks] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_distributions_sweeper_task_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[distributions]'))
ALTER TABLE [sweeper].[distributions] CHECK CONSTRAINT [FK_distributions_sweeper_task_id]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_sweeper_issue_type_issue_type_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[sweeper_issue_type]'))
ALTER TABLE [sweeper].[sweeper_issue_type]  WITH CHECK ADD  CONSTRAINT [FK_sweeper_issue_type_issue_type_id] FOREIGN KEY([parent_issue_type_id])
REFERENCES [sweeper].[sweeper_issue_type] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_sweeper_issue_type_issue_type_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[sweeper_issue_type]'))
ALTER TABLE [sweeper].[sweeper_issue_type] CHECK CONSTRAINT [FK_sweeper_issue_type_issue_type_id]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_sweeper_issue_type_severity_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[sweeper_issue_type]'))
ALTER TABLE [sweeper].[sweeper_issue_type]  WITH CHECK ADD  CONSTRAINT [FK_sweeper_issue_type_severity_id] FOREIGN KEY([severity_id])
REFERENCES [sweeper].[sweeper_issue_severity] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_sweeper_issue_type_severity_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[sweeper_issue_type]'))
ALTER TABLE [sweeper].[sweeper_issue_type] CHECK CONSTRAINT [FK_sweeper_issue_type_severity_id]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_sweeper_tasks_issue_sub_type_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[sweeper_tasks]'))
ALTER TABLE [sweeper].[sweeper_tasks]  WITH CHECK ADD  CONSTRAINT [FK_sweeper_tasks_issue_sub_type_id] FOREIGN KEY([issue_type_id])
REFERENCES [sweeper].[sweeper_issue_type] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[sweeper].[FK_sweeper_tasks_issue_sub_type_id]') AND parent_object_id = OBJECT_ID(N'[sweeper].[sweeper_tasks]'))
ALTER TABLE [sweeper].[sweeper_tasks] CHECK CONSTRAINT [FK_sweeper_tasks_issue_sub_type_id]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[sweeper].[chk_frequency_type]') AND parent_object_id = OBJECT_ID(N'[sweeper].[distributions]'))
ALTER TABLE [sweeper].[distributions]  WITH CHECK ADD  CONSTRAINT [chk_frequency_type] CHECK  (([frequency_type]='n' OR [frequency_type]='mi' OR [frequency_type]='hh' OR [frequency_type]='ww' OR [frequency_type]='wk' OR [frequency_type]='d' OR [frequency_type]='dd' OR [frequency_type]='m' OR [frequency_type]='mm' OR [frequency_type]='q' OR [frequency_type]='qq' OR [frequency_type]='yyyy' OR [frequency_type]='yy'))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[sweeper].[chk_frequency_type]') AND parent_object_id = OBJECT_ID(N'[sweeper].[distributions]'))
ALTER TABLE [sweeper].[distributions] CHECK CONSTRAINT [chk_frequency_type]
GO
USE [master]
GO
ALTER DATABASE [PDE] SET  READ_WRITE 
GO
