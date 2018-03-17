--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  06/22/2017
--
-- Description: ANE-61873 ESI - Custom list is not loading data properly
-- Rollback
--==================================================================================================================
USE princealbert --CA

SET XACT_ABORT ON
SET NOCOUNT OFF

IF OBJECT_ID('RollbackDB.dbo.ANE_61873_CUSTOMLISTINCLUDES') IS NULL BEGIN
	PRINT 'Nothing to roll back. Datafix has not been applied yet.'
	RETURN
END
ELSE IF EXISTS(
		SELECT * FROM CUSTOMLISTINCLUDES
		WHERE REPORT_DEFINITION_ID = 91
			AND CUSTOMER_ID IN (SELECT CUSTOMER_ID FROM RollbackDB.dbo.ANE_61873_CUSTOMLISTINCLUDES)
	) BEGIN
	PRINT 'Roll back cannot be run because data is change. Please revisit the rollback script.'
	RETURN
END

BEGIN TRANSACTION
	SET IDENTITY_INSERT CUSTOMLISTINCLUDES ON

	INSERT INTO CUSTOMLISTINCLUDES (CUSTOM_LIST_INCLUDE_ID, REPORT_DEFINITION_ID, CUSTOMER_ID, INCLUDE_CUSTOMER, IS_PAYER)
	SELECT CUSTOM_LIST_INCLUDE_ID, REPORT_DEFINITION_ID, CUSTOMER_ID, INCLUDE_CUSTOMER, IS_PAYER FROM RollbackDB.dbo.ANE_61873_CUSTOMLISTINCLUDES

	SET IDENTITY_INSERT CUSTOMLISTINCLUDES OFF

	DROP TABLE RollbackDB.dbo.ANE_61873_CUSTOMLISTINCLUDES
	PRINT 'Rollback is done.'
COMMIT TRANSACTION
