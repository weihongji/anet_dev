USE cranberrytownship

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-72921 P2 - ESI - receipts not printing when membership is scanned'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '2/5/2018'
DECLARE @type varchar(max)			= 'Datafix'
DECLARE @description varchar(max)	= ''
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

DECLARE @keyword varchar(50) = 'enable_java_applet'
DECLARE @prev_value varchar(50) = 'false'
DECLARE @new_value varchar(50) = 'true'

IF NOT EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = @keyword AND KEYWORDVALUE LIKE @prev_value) BEGIN
	PRINT 'Nothing to fix.'
	RETURN
END

BEGIN TRANSACTION

	UPDATE SYSTEMINFO SET KEYWORDVALUE = @new_value WHERE KEYWORD = @KEYWORD AND KEYWORDVALUE LIKE @prev_value
	INSERT INTO SYSTEMINFOLOG (KEYWORD, PREV_KEYWORD_VALUE, SYSTEMUSER_ID, DATESTAMP) VALUES (@KEYWORD, @prev_value, 0, GETDATE())
	
	PRINT char(10) + 'Done. Datafix deployed.'
COMMIT TRANSACTION
