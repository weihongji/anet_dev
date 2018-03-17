--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  09/12/2017
--
-- Description: ANE-66596 PDE Test
-- Rollback
--==================================================================================================================
USE burnaby87

SET XACT_ABORT ON

DECLARE @errorcode int =0
DECLARE @errorMsg  nvarchar(200) = NULL
DECLARE @loggingID int 
DECLARE @org NVARCHAR(200) =DB_NAME()
DECLARE @ticket NVARCHAR(200) ='ANE-66596'
DECLARE @filename NVARCHAR(500) ='ANE-66596_customers.sql'--must be data fix filenmae


EXEC PDE.dbo.P_PREROLLBACK @ticket,@org, @filename, @errorcode OUTPUT, @errorMsg output, @loggingID output
IF @errorcode <> '0'
    BEGIN
        PRINT @errorMsg
        SET NOEXEC ON
        RETURN
    END

BEGIN TRANSACTION
    BEGIN TRY
		IF OBJECT_ID('RollbackDB.dbo.ANE_66596_CUSTOMERS_20170912') IS NOT NULL BEGIN
			UPDATE CUSTOMERS SET BIRTHDATE = '2008-09-12' WHERE CUSTOMER_ID = 1152 AND BIRTHDATE = '2008-09-15'
			DROP TABLE RollbackDB.dbo.ANE_66596_CUSTOMERS_20170912
			
			PRINT 'Rollback is done.'
		END
		ELSE BEGIN
			PRINT 'Nothing to roll back. Datafix has not been applied yet.'
		END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SET @errorcode=ERROR_NUMBER()
        SET @errorMsg=ERROR_MESSAGE()
    END CATCH
COMMIT TRANSACTION


EXEC PDE.dbo.P_SCRIPT_LOGGING @loggingID,@errorcode,@errorMsg,'rollback'