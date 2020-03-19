USE Org_DB

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-10001 Re-open processed cash summary sheet.'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '1/1/2017'
DECLARE @type varchar(max)			= 'Datafix' --Datafix or Rollback
DECLARE @description varchar(max)	= '' --Put additional information if necessary.
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

IF EXISTS(select * from cash_summary_sheets where cash_summary_sheet_id = 24 and status = 0) BEGIN
	PRINT 'Nothing to fix. The data fix had already been deployed.'
	RETURN
END
ELSE IF NOT EXISTS(select * from cash_summary_sheets where cash_summary_sheet_id = 24 and status = 3) BEGIN
	PRINT 'Nothing to fix. Target data not found.'
	RETURN
END

BEGIN TRANSACTION
	update cash_summary_sheets set status = 0 where cash_summary_sheet_id = 24 and status = 3
	
	PRINT char(10) + 'Done. Datafix deployed.'
COMMIT TRANSACTION
