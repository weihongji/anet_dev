--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  07/10/2015
--
-- Description: ANE-32200 INC2297907 - ESI - P1 - AR Summary does not match Account Distribution due to cancelled permits
--
--==================================================================================================================
Use cityofportcoquitlam

IF EXISTS(SELECT * FROM RollbackDB.sys.tables WHERE name = 'GL_LEDGER_ANE_32200_20150710_UPDATE') BEGIN
	UPDATE GL_LEDGER SET VOIDED = 0, VOIDEDBY = 0, VOIDEDON = '1899-12-30'
	WHERE GL_LEDGER_ID IN (SELECT GL_LEDGER_ID FROM RollbackDB.dbo.GL_LEDGER_ANE_32200_20150710_UPDATE) AND VOIDED = -1

	PRINT char(10) + 'Rollback is done'
END
ELSE BEGIN
	PRINT 'Nothing is rolled back. Data does not pass data validation.'
END
