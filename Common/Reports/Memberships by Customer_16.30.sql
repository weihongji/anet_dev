SELECT PACKAGES.PACKAGE_ID, PACKAGES.PACKAGENAME, PACKAGES.NO_EXPIRY, PACKAGES.MAXPASSES, PACKAGES.AGESMAX, PACKAGES.MAXUSES, PACKAGES.MAX_SELLABLE_USES, MEMBERSHIPS.MEMBERSHIP_ID
	, MEMBERSHIPS.DATESUSPENDEDFROM, MEMBERSHIPS.DATESUSPENDEDTO, MEMBERSHIPS.DATESOLD, MEMBERSHIPS.DATEEFFECTIVE, MEMBERSHIPS.DATEEXPIRES, MEMBERSHIPS.STATUS, MEMBERSHIPS.PASSES_SOLD
	, NOTPRIMARYMEMBER = ABS(MEMBERSHIPS.PRIMARYMEMBERCUSTOMER_ID - CUSTOMERS.CUSTOMER_ID)
	, MEMBERNAME = CUSTOMERS.LASTNAME + ', '
		+ CASE WHEN CUSTOMER_TITLES.DESCRIPTION IS NULL OR LEN(CUSTOMER_TITLES.DESCRIPTION) = 0 THEN '' ELSE CUSTOMER_TITLES.DESCRIPTION + ' 'END
		+ CUSTOMERS.FIRSTNAME
		+ CASE WHEN CUSTOMERS.MIDDLENAME IS NULL OR LEN(CUSTOMERS.MIDDLENAME) = 0 THEN '' ELSE ' ' + CUSTOMERS.MIDDLENAME END
	, CUSTOMERS.LASTNAME, CUSTOMERS.FIRSTNAME, CUSTOMERS.GENDER, CUSTOMERS.RESIDENT, CUSTOMERS.BIRTHDATE, AGE_CATEGORIES.LOWER_AGE, AGE_CATEGORIES.UPPER_AGE, CUSTOMERS.HOMEPHONE, CUSTOMERS.WORKPHONE, CUSTOMERS.CELLPHONE
	, SITES.STATE AS PACKAGESTATE, SITES.COUNTRY AS PACKAGECOUNTRY
	, PRIMARYMEMBERNAME = PMCUST.LASTNAME
		+ ', ' +CASE WHEN PMCUST_TITLES.DESCRIPTION IS NULL OR LEN(PMCUST_TITLES.DESCRIPTION) = 0 THEN '' ELSE PMCUST_TITLES.DESCRIPTION + ' 'END
		+ PMCUST.FIRSTNAME
		+ CASE WHEN PMCUST.MIDDLENAME IS NULL OR LEN(PMCUST.MIDDLENAME) = 0 THEN '' ELSE ' ' + PMCUST.MIDDLENAME END
	, PMCUST.CUSTOMER_ID AS PMCUSTOMER_ID, PASSES.PASSNUMBER, PASSES.PASS_ID
	, AMOUNTDUEFORFAMILY = (
		CASE
			WHEN (CASE WHEN (MEMBERSHIPS.PRIMARYMEMBERCUSTOMER_ID - CUSTOMERS.CUSTOMER_ID) <> 0 THEN 1 ELSE 0 END) = 1 THEN 0
			ELSE
				CASE
					WHEN TRANSACTIONS.TRANSACTIONTYPE = 12 THEN
						(
							SELECT SUM(RD.AMOUNT + RD.TAXAMOUNT1 + RD.TAXAMOUNT2 + RD.TAXAMOUNT3 + RD.TAXAMOUNT4 + RD.TAXAMOUNT5 + RD.TAXAMOUNT6 + RD.TAXAMOUNT7 + RD.TAXAMOUNT8) - SUM(RD.APPLIEDAMOUNT + RD.TAXAPPLIEDAMOUNT1 + RD.TAXAPPLIEDAMOUNT2 + RD.TAXAPPLIEDAMOUNT3 + RD.TAXAPPLIEDAMOUNT4 + RD.TAXAPPLIEDAMOUNT5 + RD.TAXAPPLIEDAMOUNT6 + RD.TAXAPPLIEDAMOUNT7 + RD.TAXAPPLIEDAMOUNT8) FROM RECEIPTDETAILS RD WHERE RD.TRANSACTION_ID IN ( SELECT T.TRANSACTION_ID FROM TRANSACTIONS T  WHERE T.RECEIPTHEADER_ID IN (SELECT T.RECEIPTHEADER_ID FROM TRANSACTIONS T WHERE T.TRANSACTION_ID = TRANSACTIONS.TRANSACTION_ID))
						)
					ELSE (
							RECEIPTDETAILS.AMOUNT + RECEIPTDETAILS.TAXAMOUNT1 + RECEIPTDETAILS.TAXAMOUNT2 + RECEIPTDETAILS.TAXAMOUNT3 + RECEIPTDETAILS.TAXAMOUNT4 + RECEIPTDETAILS.TAXAMOUNT5 + RECEIPTDETAILS.TAXAMOUNT6 + RECEIPTDETAILS.TAXAMOUNT7 + RECEIPTDETAILS.TAXAMOUNT8
						)
						- (
							RECEIPTDETAILS.APPLIEDAMOUNT + RECEIPTDETAILS.TAXAPPLIEDAMOUNT1 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT2 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT3 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT4 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT5 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT6 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT7 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT8
						)
				END
		END
	)
	, AMOUNTDUE = CASE
		WHEN TRANSACTIONS.TRANSACTIONTYPE = 12 THEN (
				SELECT SUM(RD.AMOUNT + RD.TAXAMOUNT1 + RD.TAXAMOUNT2 + RD.TAXAMOUNT3 + RD.TAXAMOUNT4 + RD.TAXAMOUNT5 + RD.TAXAMOUNT6 + RD.TAXAMOUNT7 + RD.TAXAMOUNT8)
					- SUM(RD.APPLIEDAMOUNT + RD.TAXAPPLIEDAMOUNT1 + RD.TAXAPPLIEDAMOUNT2 + RD.TAXAPPLIEDAMOUNT3 + RD.TAXAPPLIEDAMOUNT4 + RD.TAXAPPLIEDAMOUNT5 + RD.TAXAPPLIEDAMOUNT6 + RD.TAXAPPLIEDAMOUNT7 + RD.TAXAPPLIEDAMOUNT8)
				FROM RECEIPTDETAILS RD
				WHERE RD.TRANSACTION_ID IN ( SELECT T.TRANSACTION_ID FROM TRANSACTIONS T  WHERE T.RECEIPTHEADER_ID IN (SELECT T.RECEIPTHEADER_ID FROM TRANSACTIONS T WHERE T.TRANSACTION_ID = TRANSACTIONS.TRANSACTION_ID))
			)
		ELSE (
				RECEIPTDETAILS.AMOUNT + RECEIPTDETAILS.TAXAMOUNT1 + RECEIPTDETAILS.TAXAMOUNT2 + RECEIPTDETAILS.TAXAMOUNT3 + RECEIPTDETAILS.TAXAMOUNT4 + RECEIPTDETAILS.TAXAMOUNT5 + RECEIPTDETAILS.TAXAMOUNT6 + RECEIPTDETAILS.TAXAMOUNT7 + RECEIPTDETAILS.TAXAMOUNT8
			)
			- (
				RECEIPTDETAILS.APPLIEDAMOUNT + RECEIPTDETAILS.TAXAPPLIEDAMOUNT1 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT2 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT3 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT4 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT5 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT6 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT7 + RECEIPTDETAILS.TAXAPPLIEDAMOUNT8
			)
	END
	, RECEIPTHEADERS.RECEIPTHEADER_ID AS RECEIPTHEADER_ID
	, OWNEDBY = STUFF(
		(
			SELECT (CASE WHEN PAYER_COM.COMPANY_ID > 0 THEN (CHAR(10) + '(' + MAX(PAYER_COM.COMPANYNAME) + ')') ELSE (CHAR(10) + '(' + MAX(PAYER_CUS.LASTNAME) + ', ' + MAX(PAYER_CUS.FIRSTNAME) + ')') END)
			FROM RECEIPTPAYMENTS
				LEFT JOIN CUSTOMERS PAYER_CUS ON RECEIPTPAYMENTS.CUSTOMER_ID=PAYER_CUS.CUSTOMER_ID
				LEFT JOIN COMPANIES PAYER_COM ON RECEIPTPAYMENTS.COMPANY_ID=PAYER_COM.COMPANY_ID
			WHERE RECEIPTPAYMENTS.RECEIPTHEADER_ID = RECEIPTHEADERS.RECEIPTHEADER_ID AND RECEIPTPAYMENTS.PAYMENTTYPE_ID=12
			GROUP BY PAYER_CUS.CUSTOMER_ID, PAYER_COM.COMPANY_ID
			FOR XML PATH ('')
		)
		,1,1,''
	)
	, RECEIPTHEADERS.RECEIPTNUMBER, TRANSACTIONS.DATESTAMP AS TRANSACTIONDATE, TRANSACTIONS.ORIGINALTRANSACTION_ID, TRANSACTIONS.TRANSACTION_ID, CUSTOMERS.CUSTOMER_ID
	, ADDRESS = CUSTOMERS.ADDRESS1 + ' ' + CUSTOMERS.ADDRESS2
	, CUSTOMERS.CITY + CASE WHEN CUSTOMERS.CITY IS NULL OR LEN(CUSTOMERS.CITY) = 0 THEN '' ELSE ', ' END + CUSTOMERS.STATE + ' ' + CUSTOMERS.ZIPCODE AS CITYSTATEZIP
	, MAILINGCITYSTATEZIP = CUSTOMERS.MAILINGCITY + CASE WHEN CUSTOMERS.MAILINGCITY IS NULL OR LEN(CUSTOMERS.MAILINGCITY) = 0 THEN '' ELSE ', ' END + CUSTOMERS.MAILINGSTATE + ' ' + CUSTOMERS.MAILINGZIPCODE
	, CUSTOMERS.EMAIL AS EMAIL , CUSTOMERS.ADDRESS1, CUSTOMERS.ADDRESS2, CUSTOMERS.MAILINGADDRESS1, CUSTOMERS.MAILINGADDRESS2, CUSTOMERS.STATE, CUSTOMERS.MAILINGSTATE
	, CUSTOMERS.CUSTOMERTYPE_ID AS C_CUSTOMERTYPE_ID
	, COUNTRY = (CASE WHEN STATES.COUNTRY IS NULL THEN CUSTOMERS.COUNTRY ELSE STATES.COUNTRY_ABBR END)
FROM MEMBERSHIPS
	JOIN MEMBERSHIP_PASSES ON MEMBERSHIP_PASSES.MEMBERSHIP_ID=MEMBERSHIPS.MEMBERSHIP_ID
	JOIN PASSES ON MEMBERSHIP_PASSES.PASS_ID=PASSES.PASS_ID
	JOIN CUSTOMERS ON PASSES.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID
	LEFT JOIN CUSTOMER_TITLES ON CUSTOMER_TITLES.CUSTOMER_TITLE_ID=CUSTOMERS.CUSTOMER_TITLE_ID
	LEFT JOIN AGE_CATEGORIES ON AGE_CATEGORIES.AGE_CATEGORY_ID=CUSTOMERS.AGE_CATEGORY_ID
	JOIN PACKAGES PACKAGES ON MEMBERSHIPS.PACKAGE_ID=PACKAGES.PACKAGE_ID
	LEFT JOIN TRANSACTIONS ON TRANSACTIONS.MEMBERSHIP_ID=MEMBERSHIPS.MEMBERSHIP_ID
	RIGHT JOIN CUSTOMERS PMCUST ON MEMBERSHIPS.PRIMARYMEMBERCUSTOMER_ID=PMCUST.CUSTOMER_ID
	LEFT JOIN CUSTOMER_TITLES PMCUST_TITLES ON PMCUST_TITLES.CUSTOMER_TITLE_ID=PMCUST.CUSTOMER_TITLE_ID
	LEFT JOIN RECEIPTDETAILS ON RECEIPTDETAILS.TRANSACTION_ID=TRANSACTIONS.TRANSACTION_ID
	JOIN RECEIPTHEADERS ON TRANSACTIONS.RECEIPTHEADER_ID=RECEIPTHEADERS.RECEIPTHEADER_ID
	LEFT JOIN SITES ON PACKAGES.SITE_ID=SITES.SITE_ID
	LEFT JOIN STATES ON CUSTOMERS.STATE=STATES.STATE
WHERE TRANSACTIONS.MEMBERSHIP_ID > 0
	AND MEMBERSHIPS.STATUS IN (1,5,4)
	AND (TRANSACTIONS.VOIDED = 0 OR TRANSACTIONS.VOIDED IS NULL)
	AND (
		(CASE WHEN MEMBERSHIPS.STATUS=4 THEN TRANSACTIONS.DATESTAMP ELSE MEMBERSHIPS.DATEEXPIRES END)>={D '2016-10-18'}
		OR (CASE WHEN MEMBERSHIPS.STATUS=4 THEN TRANSACTIONS.DATESTAMP ELSE MEMBERSHIPS.DATEEXPIRES END) = {D '1899-12-30'}
	)
	AND CUSTOMERS.CUSTOMER_ID IN (1266)
ORDER BY MEMBERNAME, MEMBERSHIPS.MEMBERSHIP_ID, NOTPRIMARYMEMBER

--AMOUNT DUE--
SELECT sum(artransactions.amount) AS amount_due
FROM ARTRANSACTIONS
	JOIN RECEIPTDETAILS RECEIPTDETAILS ON ARTRANSACTIONS.receiptdetail_id=RECEIPTDETAILS.receiptdetail_id
	JOIN TRANSACTIONS TRANSACTIONS ON RECEIPTDETAILS.transaction_ID=TRANSACTIONS.transaction_ID
WHERE (
		transactions.transactiontype in (12,29,30,32,31,33,54,64,60)
		or (transactions.transactiontype = 0 and transactions.membership_id > 0)
	)
	AND ORIGINALARTRANSACTION_ID in (select ORIGINALARTRANSACTION_ID from artransactions where receiptheader_id in ( 10932,10933))
	AND artransactions.transactioncustomer_id = 1266
