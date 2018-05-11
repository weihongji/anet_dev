USE vancouver

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-76662 P2 - ESI- Pending Enrollment was not cleared - activity #156781'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '5/11/2018'
DECLARE @type varchar(max)			= 'Rollback'
DECLARE @description varchar(max)	= ''
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

DECLARE @keyword varchar(50) = 'enable_init_integrity_checks'
DECLARE @prev_value varchar(50) = 'false'
DECLARE @new_value varchar(50) = 'true'

--No record
IF NOT EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = @keyword) BEGIN
	PRINT 'Nothing to roll back. Datafix has not been deployed yet.'
	RETURN
END
--Not fixed
IF NOT EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = @keyword AND KEYWORDVALUE LIKE @new_value) BEGIN
	PRINT 'Nothing to roll back. Current value is not the new value.'
	RETURN
END
ELSE BEGIN
	DECLARE @last_log_id int = (SELECT MAX(SYSTEM_INFO_LOG_ID) FROM SYSTEMINFOLOG WHERE KEYWORD = @keyword)
	--The last change is NOT made by our data fix
	IF NOT EXISTS (SELECT * FROM SYSTEMINFOLOG WHERE SYSTEM_INFO_LOG_ID = @last_log_id AND PREV_KEYWORD_VALUE LIKE @prev_value AND SYSTEMUSER_ID = 0) BEGIN
		PRINT 'Nothing to roll back. Haven''t found the fix.'
		RETURN
	END
END

BEGIN TRANSACTION
	UPDATE SYSTEMINFO SET KEYWORDVALUE = @prev_value WHERE KEYWORD = @KEYWORD AND KEYWORDVALUE LIKE @new_value
	INSERT INTO SYSTEMINFOLOG (KEYWORD, PREV_KEYWORD_VALUE, SYSTEMUSER_ID, DATESTAMP) VALUES (@KEYWORD, @new_value, 0, GETDATE())
	
	PRINT char(10) + 'Rollback is done.'
COMMIT TRANSACTION
