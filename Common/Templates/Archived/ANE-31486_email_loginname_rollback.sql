--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  07/22/2015
--
-- Description: ANE-31486 INC2295478 - P2-Login Name did not changed when email address was changed for a customer
--
--==================================================================================================================
Use Athensparks

SET XACT_ABORT ON

BEGIN TRANSACTION

IF NOT EXISTS(SELECT * FROM CUSTOMERLOGINS WHERE CUSTOMERLOGIN_ID = 2195) BEGIN

	SET IDENTITY_INSERT CUSTOMERLOGINS ON

	INSERT INTO CUSTOMERLOGINS (CUSTOMERLOGIN_ID, CUSTOMER_ID, LOGINNAME) VALUES (2195, 10967, 'FWITTMCMAHAN823@GMAIL.COM')
	INSERT INTO CUSTOMERLOGINS (CUSTOMERLOGIN_ID, CUSTOMER_ID, LOGINNAME) VALUES (2442, 12337, 'FRANNYMAC')

	SET IDENTITY_INSERT CUSTOMERLOGINS OFF

	PRINT char(10) + 'Rollback is done'
END
ELSE BEGIN
	PRINT 'Nothing is rolled back. Data does not pass data validation.'
END

COMMIT TRANSACTION