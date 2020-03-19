USE Org_DB

SET XACT_ABORT ON

DECLARE @subject varchar(max)		= 'ANE-100XXX Add an Overpayment to receipt in which charge is missing.'
DECLARE @author varchar(max)		= 'Susan Huai'
DECLARE @created_date datetime		= '4/24/2019'
DECLARE @type varchar(max)			= 'Datafix' --Datafix or Rollback
DECLARE @description varchar(max)	= 'add $28 over payment transaction to receipt #1514141.001' --Put additional information if necessary.
DECLARE @org varchar(100) = DB_NAME()
DECLARE @return int
EXEC @return = rollbackdb.dbo.audit_datafix @org, @subject, @author, @created_date, @type, @description
IF @@ERROR > 0 OR @return = -1 RETURN


DECLARE @NUM INT;
SELECT @NUM=COUNT(*) FROM  GL_LEDGER_LOG WHERE [DESCRIPTION]='ANE_100XXX-Data-fix'

DECLARE @checknum int;
SELECT @checknum=COUNT(*) FROM  RECEIPTHEADERS WHERE RECEIPTHEADER_ID=3487431 AND RECEIPTNUMBER='1514141.001'

IF @checknum=0 BEGIN

PRINT 'Nothing to fix. Target data not found.'

END  ELSE
IF @NUM = 0 BEGIN



SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET XACT_ABORT ON




IF OBJECT_ID('TEMPDB..#backup_data') IS NOT NULL
    DROP TABLE #backup_data

CREATE TABLE #backup_data(
	DML     	VARCHAR(20),
	TABLENAME 	VARCHAR(50),    
	KEYVALUE 	VARCHAR(100),
	WHERECONDITION VARCHAR(100),
	ROLLBACKORDER INT
)

IF OBJECT_ID('TEMPDB..#tmp_overpayment') IS NOT NULL
    DROP TABLE #tmp_overpayment

CREATE TABLE #tmp_overpayment(
    RECEIPTNUMBER VARCHAR(50),     
    AMOUNT money,
	CCAMOUNT money,
	CCFEE Money,
	TRANFEE Money,
    COMPANY_ID int
)

INSERT INTO #tmp_overpayment(RECEIPTNUMBER,AMOUNT,CCAMOUNT,CCFEE,TRANFEE, COMPANY_ID)
VALUES
(1514141.001,28, 28, 0, 	0, NULL)

BEGIN TRANSACTION
--//CONST variables
 DECLARE @receiptnumber money=NULL,
 		 @desc varchar(64) ='Overpayment',
 		 @amt money=NULL,
 		 @convfee money=0.00,
 		 @transfee money=0.00,
		 @CCAMOUNT money=0.00,
 		 @ccfee money=0.00,
 		 @transactiontype int =21,  --overpayment
 		 @chargeid int = null,
 		 @quantity int =1,
 		 @company_id int = NULL,
 		 @GL_LOG_DESC VARCHAR(20) ='ANE_100XXX-Data-fix';----------HERE


DECLARE op_cursor CURSOR READ_ONLY FAST_FORWARD FOR
SELECT RECEIPTNUMBER,AMOUNT,CCAMOUNT, CCFEE,TRANFEE,COMPANY_ID
FROM #tmp_overpayment

OPEN op_cursor
FETCH NEXT FROM op_cursor INTO @receiptnumber,@amt,@CCAMOUNT,@CCFEE,@transfee, @company_id


WHILE @@FETCH_STATUS = 0
BEGIN


DECLARE   @receiptid int =NULL,
		  @receiptpaymentid int =NULL,
		  @customer_id int =NULL,
		  @siteid int=NULL,
		  @stationid int =NULL,
		  @systemuserid int =NULL,
		  @datestamp datetime=NULL,
		  @orderno int=0,
		  @glaccountID int =6;

SELECT TOP 1 @receiptid=rh.RECEIPTHEADER_ID,
			 @receiptpaymentid=p.RECEIPTPAYMENT_ID,
			 @customer_id=p.CUSTOMER_ID,
			 @siteid=p.SITE_ID,
			 @stationid=p.STATION_ID,
			 @systemuserid=p.SYSTEMUSER_ID,
			 @datestamp=rh.DATESTAMP
FROM RECEIPTHEADERS rh (NOLOCK)
LEFT JOIN RECEIPTPAYMENTS p (NOLOCK) on rh.RECEIPTHEADER_ID=p.RECEIPTHEADER_ID AND p.VOIDED=0 and p.PAYMENTTYPE_ID<>12
WHERE rh.RECEIPTNUMBER=@receiptnumber;

IF @company_id IS NOT NULL
	SET @customer_id = NULL

--//TRANSACTIONS
INSERT INTO TRANSACTIONS(CUSTOMER_ID, COMPANY_ID, RECEIPTHEADER_ID, SITE_ID, STATION_ID, SYSTEMUSER_ID, DATESTAMP,
        EVENTNAME,QUANTITY,TRANSACTIONTYPE,ABSORBED_CONVENIENCE_FEE, CREDIT_CARD_AMOUNT,APPLIED_AMOUNT, SUBSYSTEM_CODE, RESERVATION_PERIOD_UNIT
        ,CONVENIENCE_FEE,TRANSACTION_FEE,CREDIT_CARD_FEE)
VALUES (@customer_id, @company_id, @receiptid , @siteid, @stationid, @systemuserid,@datestamp,
        @desc,@quantity,@transactiontype,0.00,0.00,@amt,1,1
        ,@convfee,@transfee,@ccfee)

DECLARE @transactionid int =SCOPE_IDENTITY()
UPDATE TRANSACTIONS  SET  ORIGINALTRANSACTION_ID = @transactionid,ROOTTRANSACTION_ID = @transactionid, 
CREDIT_CARD_AMOUNT=@CCAMOUNT, CREDIT_CARD_FEE=@ccfee,
TRANSACTION_FEE =@transfee
WHERE TRANSACTION_ID = @transactionid

SET @orderno=@orderno+1;
INSERT INTO #backup_data(DML,TABLENAME,KEYVALUE,WHERECONDITION,ROLLBACKORDER)
VALUES('DELETE FROM ','TRANSACTIONS ',' ',CONCAT(' WHERE TRANSACTION_ID=',@transactionid),@orderno);

--//RECEIPTDETAIS
INSERT INTO RECEIPTDETAILS (TRANSACTION_ID, ORIGINALTRANSACTION_ID, GLACCOUNT_ID, CHARGE_ID, DESCRIPTION, 
			AMOUNT, APPLIEDAMOUNT, UNITFEE, QUANTITY,SITE_ID, STATION_ID, SYSTEMUSER_ID, DISCOUNTABLE) 
	values (@transactionid, @transactionid, @glaccountID, @chargeid, @desc, 
			@amt,@amt,@amt,@quantity,@siteid, @stationid, @systemuserid,0) 

DECLARE  @receiptdetailid int  = SCOPE_IDENTITY()
UPDATE RECEIPTDETAILS SET ORIGINALRECEIPTDETAIL_ID = @receiptdetailid, 
ROOTRECEIPTDETAIL_ID = @receiptdetailid, 
CREDIT_CARD_AMOUNT=@CCAMOUNT,
CREDIT_CARD_FEE=@ccfee,
TRANSACTION_FEE=@transfee 
WHERE RECEIPTDETAIL_ID = @receiptdetailid

SET @orderno=@orderno+1;
INSERT INTO #backup_data(DML,TABLENAME,KEYVALUE,WHERECONDITION,ROLLBACKORDER)
VALUES('DELETE FROM ','RECEIPTDETAILS ',' ',CONCAT(' WHERE RECEIPTDETAIL_ID=',@receiptdetailid),@orderno);

--//GL_LEDGER
--gl
set @glaccountID = 20
insert into GL_LEDGER (RECEIPTDETAIL_ID,GLACCOUNT_ID,SITE_ID,STATION_ID,SYSTEMUSER_ID,AMOUNT,DATESTAMP,RCIAACTIVATIONDATE,ADJUSTED_AMOUNT, IS_INCOME_ACCOUNT)
values(@receiptdetailid, @glaccountID, @siteid, @stationid, @systemuserid,@amt, @datestamp, '1899-12-30 00:00:00.000', @amt, -1)

DECLARE @glid int = SCOPE_IDENTITY()

SET @orderno=@orderno+1;
INSERT INTO #backup_data(DML,TABLENAME,KEYVALUE,WHERECONDITION,ROLLBACKORDER)
VALUES('DELETE FROM ','GL_LEDGER ',' ',CONCAT(' WHERE GL_LEDGER_ID=',@glid),@orderno);

INSERT INTO GL_LEDGER_LOG(GL_LEDGER_ID,DATE_STAMP,[DESCRIPTION],TYPE_ID) 
VALUES(@glid,GETDATE(),@GL_LOG_DESC,2);

SET @orderno=@orderno+1;
INSERT INTO #backup_data(DML,TABLENAME,KEYVALUE,WHERECONDITION,ROLLBACKORDER)
VALUES('DELETE FROM ','GL_LEDGER_LOG ',' ',CONCAT(' WHERE GL_LEDGER_LOG_ID=',@@IDENTITY),@orderno);


set @glaccountID = 6
set @amt=-1*@amt
insert into GL_LEDGER (RECEIPTDETAIL_ID,GLACCOUNT_ID,SITE_ID,STATION_ID,SYSTEMUSER_ID,AMOUNT,DATESTAMP,RCIAACTIVATIONDATE,ADJUSTED_AMOUNT, IS_INCOME_ACCOUNT)
values(@receiptdetailid, @glaccountID, @siteid, @stationid, @systemuserid,@amt, @datestamp, '1899-12-30 00:00:00.000', @amt, 0)

set @glid = SCOPE_IDENTITY()

SET @orderno=@orderno+1;
INSERT INTO #backup_data(DML,TABLENAME,KEYVALUE,WHERECONDITION,ROLLBACKORDER)
VALUES('DELETE FROM ','GL_LEDGER ',' ',CONCAT(' WHERE GL_LEDGER_ID=',@glid),@orderno);

INSERT INTO GL_LEDGER_LOG(GL_LEDGER_ID,DATE_STAMP,[DESCRIPTION],TYPE_ID) 
VALUES(@glid,GETDATE(),@GL_LOG_DESC,2);

SET @orderno=@orderno+1;
INSERT INTO #backup_data(DML,TABLENAME,KEYVALUE,WHERECONDITION,ROLLBACKORDER)
VALUES('DELETE FROM ','GL_LEDGER_LOG ',' ',CONCAT(' WHERE GL_LEDGER_LOG_ID=',@@IDENTITY),@orderno);

--//customeraccounts

DECLARE @ctransactiontype int;           
set @ctransactiontype =1
set @amt=-1*abs(@amt)

INSERT INTO customeraccounts (receiptheader_id, receiptpayment_id, CUSTOMER_ID, COMPANY_ID, site_id, station_id, systemuser_id, transactiontype, amount, description, datestamp)
VALUES (@receiptid, @receiptpaymentid,  @customer_id, @company_id, @siteid, @stationid, @systemuserid, @ctransactiontype, @amt, @desc, @datestamp)


SET @orderno=@orderno+1;
INSERT INTO #backup_data(DML,TABLENAME,KEYVALUE,WHERECONDITION,ROLLBACKORDER)
VALUES('DELETE FROM ','customeraccounts ',' ',CONCAT(' WHERE CUSTOMERACCOUNT_ID=',@@IDENTITY),@orderno);


FETCH NEXT FROM op_cursor INTO @receiptnumber,@amt,@CCAMOUNT,@CCFEE,@transfee, @company_id

END;

CLOSE op_cursor
DEALLOCATE op_cursor

UPDATE TRANSACTIONS SET CREDIT_CARD_AMOUNT=28 WHERE TRANSACTION_ID=6761762 AND RECEIPTHEADER_ID=3487431
UPDATE RECEIPTDETAILS SET CREDIT_CARD_AMOUNT=28 WHERE RECEIPTDETAIL_ID=8665304 AND TRANSACTION_ID=6761762

UPDATE RECEIPTHEADERS
SET  RECEIPT_DETAIL_PAYMENT_GENERATED='1899-12-30 00:00:00', AGENCY_RECEIPT_DETAIL_GENERATED='1899-12-30 00:00:00'
WHERE RECEIPTHEADER_ID=3487431 AND RECEIPTNUMBER='1514141.001'

COMMIT TRANSACTION

SELECT *
INTO ROLLBACKDB.DBO.ANE_100XXX_OVERPAYMENT_DEL_20190424 --------------------------------------------HERE
FROM #backup_data

 PRINT char(10) + 'Done. Datafix deployed.'
      
END
ELSE 
BEGIN

 PRINT 'Nothing to fix. The DataFix had already been deployed.'

END 