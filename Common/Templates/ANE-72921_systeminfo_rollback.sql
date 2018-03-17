USE cranberrytownship

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-72921 P2 - ESI - receipts not printing when membership is scanned'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '2/5/2018'
DECLARE @type varchar(max)			= 'Rollback'
DECLARE @description varchar(max)	= ''
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

DECLARE @keyword varchar(50) = 'enable_java_applet'
DECLARE @prev_value varchar(50) = 'false'
DECLARE @new_value varchar(50) = 'true'

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = @keyword AND KEYWORDVALUE LIKE @prev_value) BEGIN
	PRINT 'Nothing to roll back. Datafix has not been deployed yet.'
	RETURN
END
ELSE IF (SELECT TOP 1 SYSTEMUSER_ID FROM SYSTEMINFOLOG WHERE KEYWORD = @keyword AND PREV_KEYWORD_VALUE LIKE @prev_value ORDER BY SYSTEM_INFO_LOG_ID DESC) = 0 BEGIN
	PRINT 'Have found the fix. Rolling back...'
END
ELSE BEGIN
	PRINT 'Nothing to roll back. Datafix has not been deployed yet or already been rolled back.'
	RETURN
END

BEGIN TRANSACTION

	UPDATE SYSTEMINFO SET KEYWORDVALUE = @prev_value WHERE KEYWORD = @KEYWORD AND KEYWORDVALUE LIKE @new_value
	INSERT INTO SYSTEMINFOLOG (KEYWORD, PREV_KEYWORD_VALUE, SYSTEMUSER_ID, DATESTAMP) VALUES (@KEYWORD, @new_value, 0, GETDATE())
	
	PRINT char(10) + 'Rollback is done.'
COMMIT TRANSACTION
