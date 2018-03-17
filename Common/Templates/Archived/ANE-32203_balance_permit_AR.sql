--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  07/20/2015
--
-- Description: ANE-32203 INC2295093 - A/R Sumamry report showing customer creditd in A/R column, but customers do not have a credit on account
--
--==================================================================================================================
Use Marana

SET XACT_ABORT ON

BEGIN TRANSACTION

IF EXISTS(SELECT GL_LEDGER_ID, GLACCOUNT_ID, ARSCHEDULEHEADER_ID FROM GL_LEDGER WHERE ARSCHEDULEHEADER_ID IS NULL AND GL_LEDGER_ID IN (108503)) BEGIN
	-- Audit changes
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203. Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (108503)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (110679, 110681)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (110885, 110887)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (109734)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (108817)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (109039)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (109934)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (109922)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (110671)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (110182)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (110266, 110638)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (107433)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (107347)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (108200)
	INSERT INTO GL_LEDGER_LOG (GL_LEDGER_ID, TYPE_ID, DESCRIPTION, DATE_STAMP)
	SELECT GL_LEDGER_ID, 7, 'ANE-32203, Original values: GLACCOUNT_ID = ' + CAST(GLACCOUNT_ID AS varchar) + ', ARSCHEDULEHEADER_ID = ' + ISNULL(CAST(ARSCHEDULEHEADER_ID AS varchar), 'NULL'), GETDATE() FROM GL_LEDGER WHERE GL_LEDGER_ID IN (110341)


	-- Datafix
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4096 WHERE GL_LEDGER_ID IN (108503)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4275 WHERE GL_LEDGER_ID IN (110679, 110681)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4292 WHERE GL_LEDGER_ID IN (110885, 110887)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4197 WHERE GL_LEDGER_ID IN (109734)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4133 WHERE GL_LEDGER_ID IN (108817)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4076 WHERE GL_LEDGER_ID IN (109039)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 3899 WHERE GL_LEDGER_ID IN (109934)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 3938 WHERE GL_LEDGER_ID IN (109922)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4281 WHERE GL_LEDGER_ID IN (110671)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4238 WHERE GL_LEDGER_ID IN (110182)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4022 WHERE GL_LEDGER_ID IN (110266, 110638)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 3855 WHERE GL_LEDGER_ID IN (107433)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 3959 WHERE GL_LEDGER_ID IN (107347)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4051 WHERE GL_LEDGER_ID IN (108200)
	UPDATE GL_LEDGER SET GLACCOUNT_ID = 59, ARSCHEDULEHEADER_ID = 4203 WHERE GL_LEDGER_ID IN (110341)
	
	PRINT char(10) + 'Datafix is done'
END
ELSE BEGIN
	PRINT 'Nothing is changed. Data does not pass data validation.'
END
COMMIT TRANSACTION
