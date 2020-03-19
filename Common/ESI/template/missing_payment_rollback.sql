USE Org_DB

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-ANE-100XXX Add a payment of "Refund to Account" to receipt'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '11/21/2019'
DECLARE @type varchar(max)			= 'Rollback' --Datafix or Rollback
DECLARE @description varchar(max)	= '' --Put additional information if necessary.
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

IF (SELECT SUM(PAYMENTAMOUNT) FROM RECEIPTPAYMENTS WHERE RECEIPTHEADER_ID = 478649) = 34899.67 OR OBJECT_ID('rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT') IS NULL BEGIN
	PRINT 'Nothing to roll back. Datafix has not been deployed yet.'
	RETURN
END

BEGIN TRANSACTION
	DELETE D
	FROM CUSTOMERACCOUNTS D
		INNER JOIN rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT BAK ON BAK.RECEIPTHEADER_ID = D.RECEIPTHEADER_ID AND BAK.RECEIPTPAYMENT_ID = D.RECEIPTPAYMENT_ID

	DELETE D
	FROM RECEIPTPAYMENTS D
		INNER JOIN rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT BAK ON BAK.RECEIPTHEADER_ID = D.RECEIPTHEADER_ID AND BAK.RECEIPTPAYMENT_ID = D.RECEIPTPAYMENT_ID

	UPDATE RECEIPTHEADERS SET RECEIPT_DETAIL_PAYMENT_GENERATED = '1899-12-30', AGENCY_RECEIPT_DETAIL_GENERATED = '1899-12-30' 
	WHERE RECEIPTHEADER_ID IN (SELECT BAK.RECEIPTHEADER_ID FROM rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT BAK)

	DECLARE @backup_table varchar(100) = 'ANE_100XXX_MISSING_PAYMENT'
	DECLARE @new_name varchar(100) = @backup_table + '_R_' + cast(@return as varchar)
	EXEC rollbackdb.sys.sp_rename @backup_table,  @new_name
	
	PRINT char(10) + 'Rollback is done.'
COMMIT TRANSACTION
