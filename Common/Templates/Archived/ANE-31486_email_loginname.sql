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

IF EXISTS(SELECT * FROM CUSTOMERLOGINS WHERE CUSTOMERLOGIN_ID = 2195 AND CUSTOMER_ID = 10967) BEGIN
	DELETE FROM CUSTOMERLOGINS WHERE CUSTOMERLOGIN_ID IN (2195, 2442)
	
	PRINT char(10) + 'Datafix is done'
END
ELSE BEGIN
	PRINT 'Nothing is changed. Data does not pass data validation.'
END
COMMIT TRANSACTION
