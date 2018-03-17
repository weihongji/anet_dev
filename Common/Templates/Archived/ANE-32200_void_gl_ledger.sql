--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  07/10/2015
--
-- Description: ANE-32200 INC2297907 - ESI - P1 - AR Summary does not match Account Distribution due to cancelled permits
--
--==================================================================================================================
Use cityofportcoquitlam


SET XACT_ABORT ON

BEGIN TRANSACTION 

	IF NOT EXISTS(SELECT * FROM RollbackDB.sys.tables WHERE name = 'GL_LEDGER_ANE_32200_20150710_UPDATE') BEGIN
		CREATE TABLE RollbackDB.dbo.GL_LEDGER_ANE_32200_20150710_UPDATE(
			GL_LEDGER_ID int NOT NULL,
			DATESTAMP smalldatetime NOT NULL DEFAULT (GETDATE())
		)
	END

	--Back up existing data in the RollbackDB
	INSERT INTO RollbackDB.dbo.GL_LEDGER_ANE_32200_20150710_UPDATE (GL_LEDGER_ID)
	SELECT DISTINCT GL.GL_LEDGER_ID
	FROM ARTRANSACTIONS AT INNER JOIN GL_LEDGER GL ON AT.RECEIPTDETAIL_ID = GL.RECEIPTDETAIL_ID
	WHERE AT.VOIDED = -1 AND GL.VOIDED = 0
		AND GL.GL_LEDGER_ID NOT IN (SELECT GL_LEDGER_ID FROM RollbackDB.dbo.GL_LEDGER_ANE_32200_20150710_UPDATE)

	--Datafix
	UPDATE GL SET GL.VOIDED = -1, GL.VOIDEDBY = ART.VOIDEDBY, GL.VOIDEDON = ART.VOIDEDON
	FROM GL_LEDGER GL INNER JOIN ARTRANSACTIONS ART ON GL.RECEIPTDETAIL_ID = ART.RECEIPTDETAIL_ID
	WHERE GL_LEDGER_ID IN (SELECT GL_LEDGER_ID FROM RollbackDB.dbo.GL_LEDGER_ANE_32200_20150710_UPDATE) AND GL.VOIDED = 0
	
	PRINT char(10) + 'Datafix is done'

COMMIT TRANSACTION
