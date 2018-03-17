--use uregina
DECLARE @date smalldatetime = '20180301'

SELECT C.CUSTOMER_ID, C.FIRSTNAME, C.LASTNAME, H.RECEIPTNUMBER, H.RECEIPTHEADER_ID, AH.*
FROM ARSCHEDULEHEADER AH
	INNER JOIN DBO.RECEIPTPAYMENTS RP ON AH.RECEIPTPAYMENT_ID = RP.RECEIPTPAYMENT_ID
	INNER JOIN RECEIPTHEADERS H ON H.RECEIPTHEADER_ID = RP.RECEIPTHEADER_ID
	INNER JOIN CUSTOMERS C ON AH.CUSTOMER_ID = C.CUSTOMER_ID
WHERE 1=1
	AND SUSPEND_AUTO_PAY = 0
	AND AUTO_PAYMENT_TYPE IN (1,2,3) AND AUTO_PAYMENT_STATUS IN (0, 10, 11)
	AND ARSCHEDULEHEADER_ID IN (
		SELECT H.ARSCHEDULEHEADER_ID
		FROM (
				SELECT DISTINCT ARSCHEDULEHEADER_ID FROM ARSCHEDULEDETAIL WHERE DATEDUE = @date
			) AS H
			OUTER APPLY (
				SELECT SUM(AMOUNTDUE) AMOUNT_FUTURE FROM ARSCHEDULEDETAIL WHERE ARSCHEDULEHEADER_ID = H.ARSCHEDULEHEADER_ID AND DATEDUE > @date
			) AS S
			OUTER APPLY (
				SELECT SUM(AMOUNT) AS AMOUNT_DUE FROM ARTRANSACTIONS WHERE ARSCHEDULEHEADER_ID = H.ARSCHEDULEHEADER_ID AND DATESTAMP <= DATEADD(HOUR, 4, @date) --We think auto-charge completed before 4:00 AM.
			) AS T
		WHERE ISNULL(S.AMOUNT_FUTURE, 0) < ISNULL(T.AMOUNT_DUE, 0)
	)
ORDER BY C.CUSTOMER_ID, AH.ARSCHEDULEHEADER_ID
