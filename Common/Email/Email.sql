select * from SYSTEMINFO where KEYWORD in ( 'has_trainer', 'is_trainer', 'keep_ro_mail_server_setting', 'full_backup_unc')
select * from SYSTEMINFO where KEYWORD like '%has_trainer%'
select * from SITES
select * from SystemInfo where keyword ='is_trainer' and keywordvalue like 'true'

SELECT KeyWordValue FROM SYSTEMINFO WHERE KEYWORD LIKE 'email_service_mail_server'

SELECT KeyWordValue FROM SYSTEMINFO WHERE KEYWORD LIKE 'disable_outgoing_email'
SELECT ROMAILSERVER FROM SYSTEM

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'keep_ro_mail_server_setting' AND KEYWORDVALUE LIKE 'false') BEGIN
	UPDATE SYSTEM SET ROMAILSERVER = '' WHERE EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'keep_ro_mail_server_setting' AND KEYWORDVALUE LIKE 'false')
END


select ROMAILSERVER, * from ActivenetDBTrainer.dbo.SYSTEM
select * from ActiveNetSites.dbo.SYSTEMINFO where KEYWORD = 'SmtpServer'


SELECT KEYWORDVALUE FROM SYSTEMINFO WHERE KEYWORD IN ('email_service_mail_server', 'email_service_mail_port')

/*
update SYSTEM set ROMAILSERVER = 'lassmtpint.active.local'
update SYSTEMINFO set KEYWORDVALUE = 'true' where KEYWORD = 'has_trainer'
update SYSTEMINFO set KEYWORDVALUE = 'false' where KEYWORD = 'is_trainer'
update SYSTEMINFO set KEYWORDVALUE = 'false' where KEYWORD = 'keep_ro_mail_server_setting'
UPDATE SYSTEMINFO SET KEYWORDVALUE = 'E:\Data\Database\ActiveNet\SQL2012\Trainer' WHERE KEYWORD = 'full_backup_unc'
INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('email_service_mail_server', 'lassmtpint.active.local')
UPDATE SYSTEMINFO SET KEYWORDVALUE = 'lassmtpint.active.local' WHERE KEYWORD = 'email_service_mail_server'
UPDATE SYSTEMINFO SET KEYWORDVALUE = '25' WHERE KEYWORD = 'email_service_mail_port'

update system set ROMAILSERVER = 'mx1.dev.activenetwork.com'
UPDATE SYSTEMINFO SET KEYWORDVALUE = '\\fs03\ActiveNetDBBackups\Burnaby36\' WHERE KEYWORD = 'full_backup_unc'
UPDATE SYSTEMINFO SET KEYWORDVALUE = '0' WHERE KEYWORD = 'email_service_mail_port'
DELETE FROM SYSTEMINFO WHERE KEYWORD LIKE 'email_service_mail_server'
*/

SELECT * FROM REPORTDEFINITION

SELECT * FROM CUSTOMLISTINCLUDES WHERE report_definition_id=4

SELECT DISTINCT CUSTOMERS.Customer_ID AS Customer_ID, Customers.LastName + ', ' +case when CUSTOMER_TITLES.DESCRIPTION is null or len(CUSTOMER_TITLES.DESCRIPTION) = 0 then '' else CUSTOMER_TITLES.DESCRIPTION + ' 'end  + Customers.FirstName + case when Customers.middlename is null or len(Customers.middlename) = 0 then '' else ' ' + Customers.middlename end  AS CustomerName, CUSTOMERS.CELLPHONE, CUSTOMERS.CARRIER_ID, (0) AS Sent, ('') AS SendErrors, ('') AS Email, CUSTOMERS.NOMAIL AS NoMail FROM CUSTOMERS "CUSTOMERS" LEFT JOIN CUSTOMER_TITLES CUSTOMER_TITLES ON CUSTOMERS.customer_title_id=CUSTOMER_TITLES.customer_title_id LEFT JOIN CUSTOMERLOGINS CUSTOMERLOGINS ON CUSTOMERLOGINS.CUSTOMER_ID=CUSTOMERS.CUSTOMER_ID LEFT JOIN AGE_CATEGORIES AGE_CATEGORIES ON CUSTOMERS.AGE_CATEGORY_ID=AGE_CATEGORIES.AGE_CATEGORY_ID WHERE LEN(CUSTOMERS.CELLPHONE) > 0 AND CUSTOMERS.CARRIER_ID <> 0 AND Customers.customer_id in ((SELECT CustomListIncludes.customer_id FROM CUSTOMLISTINCLUDES "CUSTOMLISTINCLUDES" WHERE report_definition_id=4 AND is_payer=(SELECT r.USE_PAYER FROM REPORTDEFINITION r WHERE r.REPORTDEFINITION_ID=4) AND include_customer<>0) union (SELECT customers.customer_id FROM CUSTOMERS "CUSTOMERS" WHERE Customers.NoMail=0 AND Customers.NoPostalMail=0 AND customers.customer_id in (69))) AND not Customers.customer_id in (SELECT CustomListIncludes.customer_id FROM CUSTOMLISTINCLUDES "CUSTOMLISTINCLUDES" WHERE report_definition_id=4 AND include_customer=0) ORDER BY CustomerName, Customer_ID


SELECT * FROM ActiveNetSites.dbo.CARRIERS

/*
INSERT INTO ActiveNetSites.dbo.CARRIERS(CARRIER_NAME, CARRIER_DOMAIN, COUNTRY_ABBR) VALUES ('Alcatel', 'Alcatel.COM', 'FR')
INSERT INTO ActiveNetSites.dbo.CARRIERS(CARRIER_NAME, CARRIER_DOMAIN, COUNTRY_ABBR) VALUES ('ATT', 'ATT.COM', 'US')
INSERT INTO ActiveNetSites.dbo.CARRIERS(CARRIER_NAME, CARRIER_DOMAIN, COUNTRY_ABBR) VALUES ('O2', 'O2.COM', 'UK')
INSERT INTO ActiveNetSites.dbo.CARRIERS(CARRIER_NAME, CARRIER_DOMAIN, COUNTRY_ABBR) VALUES ('Verizon', 'Verizon.COM', 'US')
*/

SELECT * FROM BULKEMAILTASKS

SELECT * FROM BULKEMAILRECIPIENTS
SELECT * FROM BULKEMAILATTACHMENTS
SELECT * FROM CUSTOMERLOG

--UPDATE BULKEMAILRECIPIENTS SET CUSTOMEREMAIL = 'jesse.wei@activenetwork.com' WHERE BULKEMAILRECIPIENT_ID BETWEEN 9 AND 100

/*
DELETE FROM BULKEMAILTASKS where BULKEMAILTASK_ID > 2
DELETE FROM BULKEMAILRECIPIENTS where BULKEMAILTASK_ID > 2
DELETE FROM CUSTOMERLOG where BULKEMAILTASK_ID > 2
*/
