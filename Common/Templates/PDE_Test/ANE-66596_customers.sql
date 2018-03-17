--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  09/12/2017
--
-- Description: ANE-66596 PDE Test
-- Datafix
--==================================================================================================================
USE burnaby87

SET XACT_ABORT ON

DECLARE @errorcode int =NULL
DECLARE @errorMsg  nvarchar(200) = NULL
DECLARE @loggingID int 
DECLARE @org NVARCHAR(200) =DB_NAME()
DECLARE @ticket NVARCHAR(200) ='ANE-66596'
DECLARE @filename NVARCHAR(500) ='ANE-66596_customers.sql' --data fix filenmae

EXEC PDE.dbo.P_PREDATAFIX @ticket,@org,@filename,@errorcode OUTPUT,@errorMsg  OUTPUT,@loggingID OUTPUT
IF @errorcode <> 0
    BEGIN
        PRINT @errorMsg
        SET NOEXEC ON
        RETURN
    END

BEGIN TRANSACTION
    BEGIN TRY
		IF EXISTS(SELECT * FROM CUSTOMERS WHERE CUSTOMER_ID = 1152 AND BIRTHDATE = '2008-09-12') BEGIN
			--Back up existing data in the RollbackDB
			SELECT CUSTOMER_ID, FIRSTNAME, LASTNAME, BIRTHDATE INTO RollbackDB.dbo.ANE_66596_CUSTOMERS_20170912 FROM CUSTOMERS WHERE CUSTOMER_ID = 1152 AND BIRTHDATE = '2008-09-12'

			--Datafix
			UPDATE CUSTOMERS SET BIRTHDATE = '2008-09-15' WHERE CUSTOMER_ID = 1152 AND BIRTHDATE = '2008-09-12'

			PRINT 'Datafix applied.'
		END
		ELSE BEGIN
			PRINT 'Nothing to fix.'
		END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SET @errorcode=ERROR_NUMBER()
        SET @errorMsg=ERROR_MESSAGE()
    END CATCH
COMMIT TRANSACTION


EXEC PDE.dbo.P_SCRIPT_LOGGING @loggingID,@errorcode,@errorMsg