--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  06/16/2015
--
-- Description: ANE-30888 INC2293106 - YMCA of Greater Seattle - Error seen on trying to update customer information
-- Datafix
--==================================================================================================================
USE SeattleYMCA


SET XACT_ABORT ON

BEGIN TRANSACTION 

	IF EXISTS(SELECT * FROM CUSTOMERLOGINS WHERE CUSTOMERLOGIN_ID  = 44409 AND LOGINNAME = ('mirabella@comcast.net' COLLATE Latin1_General_CS_AS)) BEGIN
		--Back up existing data in the RollbackDB
		SELECT CUSTOMERLOGIN_ID, LOGINNAME INTO RollbackDB.dbo.CUSTOMERLOGINS_ANE_30888_20150618_UPDATE FROM CUSTOMERLOGINS
		WHERE CHARINDEX('@', loginname)>0 AND LOGINNAME != (UPPER(LOGINNAME) COLLATE Latin1_General_CS_AS)

		--Datafix
		UPDATE CUSTOMERLOGINS SET LOGINNAME = UPPER(LOGINNAME)
		WHERE CHARINDEX('@', loginname)>0 AND LOGINNAME != (UPPER(LOGINNAME) COLLATE Latin1_General_CS_AS)

		PRINT 'Email update is done'
	END
	ELSE BEGIN
		PRINT 'Nothing is updated. Data does not pass data validation.'
	END

COMMIT TRANSACTION
