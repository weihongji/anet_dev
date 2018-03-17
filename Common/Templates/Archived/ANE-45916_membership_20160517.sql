--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  05/17/2016
--
-- Description: ANE-45916 P2 - Bug - Memberships sold yesterday auto cancelled today - YMCA Detroit.
-- Datafix
--==================================================================================================================
USE ymcadetroit

SET XACT_ABORT ON
SET NOCOUNT OFF

IF OBJECT_ID('RollbackDB.dbo.ANE_45916_CUSTOMER_MEMBERSHIP_DATES') IS NULL BEGIN
	CREATE TABLE RollbackDB.dbo.ANE_45916_CUSTOMER_MEMBERSHIP_DATES(
		ID INT IDENTITY(1,1), DBName varchar(100),
		CUSTOMER_MEMBERSHIP_DATE_ID int, EXPIRATION_DATE datetime, EXPIRATION_DATE_TO datetime, TERMINATION_DATE datetime,
		DateStamp datetime default(getdate()), RolledBack datetime
	)
END

BEGIN TRANSACTION

	UPDATE CMD
	SET EXPIRATION_DATE = FX.DateExpiresTo, TERMINATION_DATE = '1899-12-30'
	OUTPUT DB_NAME(), DELETED.CUSTOMER_MEMBERSHIP_DATE_ID, DELETED.EXPIRATION_DATE, INSERTED.EXPIRATION_DATE, DELETED.TERMINATION_DATE
	INTO RollbackDB.dbo.ANE_45916_CUSTOMER_MEMBERSHIP_DATES(DBName, CUSTOMER_MEMBERSHIP_DATE_ID, EXPIRATION_DATE, EXPIRATION_DATE_TO, TERMINATION_DATE)
	FROM CUSTOMER_MEMBERSHIP_DATES CMD
		INNER JOIN RollbackDB.dbo.ANE_45916_MEMBERSHIPS_20160511 FX ON FX.MEMBERSHIP_ID = CMD.MEMBERSHIP_ID
	WHERE CMD.EXPIRATION_DATE = FX.DateExpiresFrom
		AND CMD.TERMINATION_DATE >= '2016-05-04'

	PRINT 'Done. Datafix applied.'
	--PRINT 'Nothing to fix. Datafix had already been applied before.'

COMMIT TRANSACTION
