--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  06/16/2015
--
-- Description: ANE-30888 INC2293106 - YMCA of Greater Seattle - Error seen on trying to update customer information
-- Rollback
--==================================================================================================================
USE SeattleYMCA

IF EXISTS(SELECT * FROM CUSTOMERLOGINS WHERE CUSTOMERLOGIN_ID  = 44409 AND LOGINNAME = ('MIRABELLA@COMCAST.NET' COLLATE Latin1_General_CS_AS)) BEGIN
	UPDATE CL SET LOGINNAME = BAK.LOGINNAME
	FROM CUSTOMERLOGINS CL, RollbackDB.dbo.CUSTOMERLOGINS_ANE_30888_20150618_UPDATE BAK
	WHERE CL.CUSTOMERLOGIN_ID = BAK.CUSTOMERLOGIN_ID

	PRINT 'Rollback is done'
END
ELSE BEGIN
	PRINT 'Nothing is rolled back. Data does not pass data validation.'
END