--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  06/22/2017
--
-- Description: ANE-61873 ESI - Custom list is not loading data properly
-- Datafix
--==================================================================================================================
USE princealbert --CA

SET XACT_ABORT ON
SET NOCOUNT OFF

IF OBJECT_ID('RollbackDB.dbo.ANE_61873_CUSTOMLISTINCLUDES') IS NOT NULL BEGIN
	PRINT 'Nothing to fix. Datafix had already been applied before.'
	RETURN
END

BEGIN TRANSACTION
	SELECT * INTO RollbackDB.dbo.ANE_61873_CUSTOMLISTINCLUDES FROM CUSTOMLISTINCLUDES WHERE REPORT_DEFINITION_ID = 91 AND INCLUDE_CUSTOMER != 0
	DELETE FROM CUSTOMLISTINCLUDES WHERE CUSTOM_LIST_INCLUDE_ID IN (SELECT CUSTOM_LIST_INCLUDE_ID FROM RollbackDB.dbo.ANE_61873_CUSTOMLISTINCLUDES)

	PRINT 'Done. Datafix applied.'
COMMIT TRANSACTION
