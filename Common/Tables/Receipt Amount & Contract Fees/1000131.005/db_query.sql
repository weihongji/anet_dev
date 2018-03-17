DECLARE @receiptheader_id int
SELECT @receiptheader_id = RECEIPTHEADER_ID FROM RECEIPTHEADERS WHERE RECEIPTNUMBER = 1000131.005
SELECT TOTALFEE, TRANSACTIONFEE, CONVENIENCEFEE, CREDITCARDFEE,  CREDITCARDAMOUNT, * FROM RECEIPTHEADERS where RECEIPTHEADER_ID = @receiptheader_id
SELECT APPLIED_AMOUNT, TRANSACTION_FEE, CONVENIENCE_FEE, CREDIT_CARD_FEE, * FROM TRANSACTIONS where RECEIPTHEADER_ID = @receiptheader_id
SELECT APPLIEDAMOUNT, AMOUNT, TRANSACTION_FEE, CREDIT_CARD_FEE, CONVENIENCE_FEE, CREDIT_CARD_AMOUNT, UNITFEE, QUANTITY, * FROM RECEIPTDETAILS WHERE TRANSACTION_ID IN (SELECT TRANSACTION_ID FROM TRANSACTIONS where RECEIPTHEADER_ID = @receiptheader_id) ORDER BY RECEIPTDETAIL_ID
SELECT PAYMENTAMOUNT, * FROM RECEIPTPAYMENTS WHERE RECEIPTHEADER_ID = @receiptheader_id
