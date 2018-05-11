USE vancouver

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-76662 P2 - ESI- Pending Enrollment was not cleared - activity #156781'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '5/11/2018'
DECLARE @type varchar(max)			= 'Datafix'
DECLARE @description varchar(max)	= ''
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

DECLARE @keyword varchar(50) = 'enable_init_integrity_checks'
DECLARE @prev_value varchar(50) = 'false'
DECLARE @new_value varchar(50) = 'true'

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = @keyword AND KEYWORDVALUE LIKE @new_value) BEGIN
	PRINT 'Nothing to fix. The keyword already has expected value.'
	RETURN
END

BEGIN TRANSACTION

	IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = @KEYWORD) BEGIN
		UPDATE SYSTEMINFO SET KEYWORDVALUE = @new_value WHERE KEYWORD = @KEYWORD AND KEYWORDVALUE LIKE @prev_value
	END
	ELSE BEGIN
		INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES (@KEYWORD, @new_value)
	END
	IF @@ROWCOUNT > 0 BEGIN
		INSERT INTO SYSTEMINFOLOG (KEYWORD, PREV_KEYWORD_VALUE, SYSTEMUSER_ID, DATESTAMP) VALUES (@KEYWORD, @prev_value, 0, GETDATE())
	END
	
	PRINT char(10) + 'Done. Datafix deployed.'
COMMIT TRANSACTION
