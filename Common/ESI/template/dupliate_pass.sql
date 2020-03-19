USE Org_DB

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-100XXX Remove redundant passes if customer has more than one pass on a membership'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '7/22/2019'
DECLARE @type varchar(max)			= 'Datafix' --Datafix or Rollback
DECLARE @description varchar(max)	= '' --Put additional information if necessary.
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

--Fixed
IF NOT EXISTS(SELECT * FROM MEMBERSHIP_PASSES WHERE MEMBERSHIP_ID = 15622 AND PASS_ID = 8889) AND OBJECT_ID('rollbackdb.dbo.ANE_100XXX_MEMBERSHIP_PASSES') IS NOT NULL BEGIN
	PRINT 'Nothing to fix. The data fix had already been deployed.'
	RETURN
END
--Target exists
ELSE IF EXISTS(SELECT * FROM MEMBERSHIP_PASSES WHERE MEMBERSHIP_ID = 15622 AND PASS_ID = 8889) BEGIN
	IF OBJECT_ID('rollbackdb.dbo.ANE_100XXX_MEMBERSHIP_PASSES') IS NOT NULL AND DB_NAME() LIKE '%TRAINER' BEGIN
		PRINT 'Trainer was refreshed after data fix deployment. Dropping rollback table ...'
		DROP TABLE rollbackdb.dbo.ANE_100XXX_MEMBERSHIP_PASSES
		PRINT 'Drop is done.'
	END
END
--Invalid
ELSE BEGIN
	PRINT 'Nothing to fix. Target data not found.'
	RETURN
END

BEGIN TRANSACTION
	SELECT * INTO rollbackdb.dbo.ANE_100XXX_MEMBERSHIP_PASSES FROM MEMBERSHIP_PASSES WHERE MEMBERSHIP_ID = 15622 AND PASS_ID = 8889
	DELETE FROM MEMBERSHIP_PASSES WHERE MEMBERSHIP_PASS_ID IN (SELECT R.MEMBERSHIP_PASS_ID FROM rollbackdb.dbo.ANE_100XXX_MEMBERSHIP_PASSES R)
	
	PRINT char(10) + 'Done. Datafix deployed.'
COMMIT TRANSACTION
