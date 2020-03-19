USE Org_DB

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-10002 Remove saved credit card'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '1/1/2017'
DECLARE @type varchar(max)			= 'Datafix' --Datafix or Rollback
DECLARE @description varchar(max)	= '' --Put additional information if necessary.
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

--Fixed
IF NOT EXISTS(SELECT * FROM CREDITCARDS WHERE CREDIT_CARD_ID = 3075) AND OBJECT_ID('rollbackdb.dbo.ANE_10002_CREDITCARDS') IS NOT NULL BEGIN
	PRINT 'Nothing to fix. The data fix had already been deployed.'
	RETURN
END
--Target exists
ELSE IF EXISTS(SELECT * FROM CREDITCARDS WHERE CREDIT_CARD_ID = 3075 AND CUSTOMER_ID = 1400) BEGIN
	IF OBJECT_ID('rollbackdb.dbo.ANE_10002_CREDITCARDS') IS NOT NULL AND DB_NAME() LIKE '%TRAINER' BEGIN
		PRINT 'Trainer was refreshed after data fix deployment. Dropping rollback table ...'
		DROP TABLE rollbackdb.dbo.ANE_10002_CREDITCARDS
		PRINT 'Drop is done.'
	END
END
--Invalid
ELSE BEGIN
	PRINT 'Nothing to fix. Target data not found.'
	RETURN
END

BEGIN TRANSACTION
	SELECT * INTO rollbackdb.dbo.ANE_10002_CREDITCARDS FROM CREDITCARDS WHERE CREDIT_CARD_ID = 3075
	
	UPDATE ARSCHEDULEHEADER SET SAVED_CREDITCARD_ID = NULL WHERE ARSCHEDULEHEADER_ID = 3214
	DELETE FROM CREDITCARDS WHERE CREDIT_CARD_ID = 3075
	
	PRINT char(10) + 'Done. Datafix deployed.'
COMMIT TRANSACTION
