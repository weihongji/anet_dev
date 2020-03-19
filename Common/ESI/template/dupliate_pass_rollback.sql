USE Org_DB

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-100XXX Remove redundant passes if customer has more than one pass on a membership'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '7/22/2019'
DECLARE @type varchar(max)			= 'Rollback' --Datafix or Rollback
DECLARE @description varchar(max)	= '' --Put additional information if necessary.
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

IF EXISTS(SELECT * FROM MEMBERSHIP_PASSES WHERE MEMBERSHIP_ID = 15622 AND PASS_ID = 8889) OR OBJECT_ID('rollbackdb.dbo.ANE_100XXX_MEMBERSHIP_PASSES') IS NULL BEGIN
	PRINT 'Nothing to roll back. Datafix has not been deployed yet.'
	RETURN
END

BEGIN TRANSACTION
	SET IDENTITY_INSERT MEMBERSHIP_PASSES ON
	INSERT INTO MEMBERSHIP_PASSES (MEMBERSHIP_PASS_ID, MEMBERSHIP_ID, PASS_ID, DATESUSPENDEDTO, DATESUSPENDEDFROM, EXTENDFORSUSPENDEDTIME, IS_DEFAULT_MEMBERSHIP)
	SELECT MEMBERSHIP_PASS_ID, MEMBERSHIP_ID, PASS_ID, DATESUSPENDEDTO, DATESUSPENDEDFROM, EXTENDFORSUSPENDEDTIME, IS_DEFAULT_MEMBERSHIP
	FROM rollbackdb.dbo.ANE_100XXX_MEMBERSHIP_PASSES
	SET IDENTITY_INSERT MEMBERSHIP_PASSES OFF

	DECLARE @backup_table varchar(100) = 'ANE_100XXX_MEMBERSHIP_PASSES'
	DECLARE @new_name varchar(100) = @backup_table + '_R_' + cast(@return as varchar)
	EXEC rollbackdb.sys.sp_rename @backup_table,  @new_name
	
	PRINT char(10) + 'Rollback is done.'
COMMIT TRANSACTION
