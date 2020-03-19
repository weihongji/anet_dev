USE Org_DB

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-100XXX Add a payment of "Refund to Account" to receipt'
DECLARE @author varchar(max)		= 'Jesse Wei'
DECLARE @created_date datetime		= '11/21/2019'
DECLARE @type varchar(max)			= 'Datafix' --Datafix or Rollback
DECLARE @description varchar(max)	= '' --Put additional information if necessary.
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN

--Fixed
IF (SELECT SUM(PAYMENTAMOUNT) FROM RECEIPTPAYMENTS WHERE RECEIPTHEADER_ID = 478649) = 34827.67 AND OBJECT_ID('rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT') IS NOT NULL BEGIN
	PRINT 'Nothing to fix. The data fix had already been deployed.'
	RETURN
END
--Target exists
ELSE IF (SELECT SUM(PAYMENTAMOUNT) FROM RECEIPTPAYMENTS WHERE RECEIPTHEADER_ID = 478649) = 34899.67 BEGIN
	IF OBJECT_ID('rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT') IS NOT NULL AND DB_NAME() LIKE '%TRAINER' BEGIN
		PRINT 'Trainer was refreshed after data fix deployment. Dropping rollback table ...'
		DROP TABLE rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT
		PRINT 'Drop is done.'
	END
END
--Invalid
ELSE BEGIN
	PRINT 'Nothing to fix. Target data not found.'
	RETURN
END

CREATE TABLE rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT(
	RECEIPTNUMBER VARCHAR(50),
	AMOUNT money,
	CUSTOMER_ID int,
	COMPANY_ID int,		
	RECEIPTHEADER_ID int,
	RECEIPTPAYMENT_ID int,
	SITE_ID int,
	STATION_ID int,
	SYSTEMUSER_ID int,
	DATESTAMP datetime
)

INSERT INTO rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT (RECEIPTNUMBER, AMOUNT, CUSTOMER_ID, COMPANY_ID)
VALUES (1002981.336, 72.00, NULL, 916)

UPDATE BAK
SET RECEIPTHEADER_ID = RH.RECEIPTHEADER_ID,
	SITE_ID = RH.SITE_ID,
	STATION_ID = RH.STATION_ID,
	SYSTEMUSER_ID = RH.SYSTEMUSER_ID,
	DATESTAMP = RH.DATESTAMP
FROM rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT BAK INNER JOIN RECEIPTHEADERS RH ON RH.RECEIPTNUMBER = BAK.RECEIPTNUMBER

DECLARE @receiptheader_id int
DEClARE receipts CURSOR FOR SELECT RECEIPTHEADER_ID FROM rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT

BEGIN TRANSACTION
	OPEN receipts
	FETCH NEXT FROM receipts INTO @receiptheader_id
	WHILE @@fetch_status = 0 BEGIN
		INSERT INTO RECEIPTPAYMENTS (RECEIPTHEADER_ID, CUSTOMER_ID, COMPANY_ID, SITE_ID, STATION_ID, SYSTEMUSER_ID, PAYMENTTYPE_ID, DATESTAMP, PAYMENTAMOUNT, BANK_ACCOUNT_TYPE, COMPANY_AGENT_ID)
		SELECT RECEIPTHEADER_ID, CUSTOMER_ID, COMPANY_ID, SITE_ID, STATION_ID, SYSTEMUSER_ID, 10, DATESTAMP, -1 * AMOUNT,  'C', -1
		FROM rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT
		WHERE RECEIPTHEADER_ID = @receiptheader_id

		UPDATE rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT SET RECEIPTPAYMENT_ID = SCOPE_IDENTITY()
		WHERE RECEIPTHEADER_ID = @receiptheader_id

		INSERT INTO CUSTOMERACCOUNTS (RECEIPTHEADER_ID, RECEIPTPAYMENT_ID, CUSTOMER_ID, COMPANY_ID, SITE_ID, STATION_ID, SYSTEMUSER_ID, TRANSACTIONTYPE, AMOUNT, DESCRIPTION, DATESTAMP)
		SELECT RECEIPTHEADER_ID, RECEIPTPAYMENT_ID, CUSTOMER_ID, COMPANY_ID, SITE_ID, STATION_ID, SYSTEMUSER_ID, 2, -1 * AMOUNT, 'Refund to account', DATESTAMP
		FROM rollbackdb.dbo.ANE_100XXX_MISSING_PAYMENT
		WHERE RECEIPTHEADER_ID = @receiptheader_id

		UPDATE RECEIPTHEADERS SET RECEIPT_DETAIL_PAYMENT_GENERATED = '1899-12-30', AGENCY_RECEIPT_DETAIL_GENERATED = '1899-12-30'
		WHERE RECEIPTHEADER_ID = @receiptheader_id
		
		FETCH NEXT FROM receipts INTO @receiptheader_id
	END
	CLOSE receipts
	DEALLOCATE receipts
	
	PRINT char(10) + 'Done. Datafix deployed.'
COMMIT TRANSACTION
