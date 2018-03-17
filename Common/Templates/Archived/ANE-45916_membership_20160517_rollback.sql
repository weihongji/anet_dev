--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  05/17/2016
--
-- Description: ANE-45916 P2 - Bug - Memberships sold yesterday auto cancelled today - YMCA Detroit.
-- Rollback
--==================================================================================================================
USE ymcadetroit

SET XACT_ABORT ON
SET NOCOUNT OFF

DECLARE @affected table (
	KeyID int
)

IF OBJECT_ID('RollbackDB.dbo.ANE_45916_CUSTOMER_MEMBERSHIP_DATES') IS NOT NULL BEGIN
	BEGIN TRANSACTION

	-- Revert data
	UPDATE CMD
	SET EXPIRATION_DATE = FX.EXPIRATION_DATE, TERMINATION_DATE = FX.TERMINATION_DATE
	OUTPUT INSERTED.CUSTOMER_MEMBERSHIP_DATE_ID INTO @affected
	FROM CUSTOMER_MEMBERSHIP_DATES CMD
		INNER JOIN RollbackDB.dbo.ANE_45916_CUSTOMER_MEMBERSHIP_DATES AS FX ON CMD.CUSTOMER_MEMBERSHIP_DATE_ID = FX.CUSTOMER_MEMBERSHIP_DATE_ID
	WHERE FX.DBName = DB_NAME()
		AND FX.RolledBack IS NULL
		AND CMD.TERMINATION_DATE = '1899-12-30'
		AND CMD.EXPIRATION_DATE = FX.EXPIRATION_DATE_TO

	-- Set RolledBack flag
	UPDATE RollbackDB.dbo.ANE_45916_CUSTOMER_MEMBERSHIP_DATES
	SET RolledBack = GETDATE()
	WHERE DBName = DB_NAME()
		AND RolledBack IS NULL
		AND CUSTOMER_MEMBERSHIP_DATE_ID IN (SELECT KeyID FROM @affected)

	PRINT 'Rollback is done.'

	COMMIT TRANSACTION
END
ELSE BEGIN
	PRINT 'Nothing to roll back. Datafix has not been applied yet.'
END
