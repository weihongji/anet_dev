--use [ymcala]

--Clear real emails 
update SYSTEM_USERS set EMAIL='xx_'+EMAIL where EMAIL <> ''
update CUSTOMERS set EMAIL='xx_'+EMAIL where EMAIL <> ''
update CUSTOMERS set ADDITIONAL_EMAIL='xx_'+ADDITIONAL_EMAIL where ADDITIONAL_EMAIL <> ''
update COMPANIES set EMAIL='xx_'+EMAIL where EMAIL <> ''
UPDATE INSTRUCTORS SET EMAIL = 'test@test.com' WHERE EMAIL<>''
UPDATE systeminfo SET keywordvalue ='xx_'+convert(varchar(200),keywordvalue) where keyword ='permit_expiry_email' AND datalength(KEYWORDVALUE)>0
UPDATE systeminfo SET keywordvalue ='xx_'+convert(varchar(200),keywordvalue) where keyword ='auto_payment_email_failed_address_bcc' AND datalength(KEYWORDVALUE)>0
UPDATE systeminfo SET keywordvalue ='xx_'+convert(varchar(200),keywordvalue) where keyword ='auto_payment_email_successful_address_bcc' AND datalength(KEYWORDVALUE)>0

--Suspend production auto payments in case you need to use mstest.active that may cause errors send to mstest
UPDATE ARSCHEDULEHEADER SET SUSPEND_AUTO_PAY = -1 WHERE ISNULL(SUSPEND_AUTO_PAY, 0) != -1
UPDATE MEMBERSHIPS SET SUSPEND_AUTO_RENEWAL =-1 WHERE ISNULL(SUSPEND_AUTO_RENEWAL, 0) != -1
--Disable scheduled reports
--UPDATE REPORTDEFINITION SET RECIPIENT_ADDRESSES ='',ENABLE_EXPORT_TO_FTP=0,SEND_CONFIRMATION_EMAIL=0
UPDATE REPORTDEFINITION set ENABLE_SCHEDULE_REPORT = 0 where ENABLE_SCHEDULE_REPORT = -1
--Delete email and message tasks

select count(1) from MESSAGES

delete BULKEMAILTASKS
truncate table BULKEMAILATTACHMENTS
truncate table BULKEMAILACKNOWLEDGEMENTS
delete BULKEMAILRECIPIENTS
truncate table OPTOUTHISTORY
truncate table NEWSLETTER_OFFER_ORDER_PRODUCTS
delete NEWSLETTER_OFFER_ORDERS
truncate table CUSTOMER_SUBSCRIPTIONLIST
truncate table MESSAGEQUEUES
delete MESSAGES
truncate table GROSSPAYEXPORTBATCHES
truncate table ICVERIFYLOG
truncate table REPORTDEFINITIONOVERRIDES
truncate table REPORT_DEFINITION_TIME

--Update credit card processor host address to localdemo
UPDATE SYSTEM SET VERISIGNHOSTADDRESS = 'localdemo'
UPDATE SYSTEM_USERS SET PASSWORD='safari' WHERE USERNAME<>'acmcuiuser'
--Disable akamai for local restore
--UPDATE SYSTEMINFO SET KEYWORDVALUE ='false' WHERE KEYWORD like 'use_akamai'

--Disable schedule load customer function
UPDATE SCHEDULED_LOAD_CUSTOMER SET SCHEDULE_FREQUENCY = 0

--Clear skylogix configuration
DELETE FROM SYSTEMINFO WHERE KEYWORD in ('enable_run_skylogix_export', 'skylogix_client_id', 'skylogix_user_name', 'skylogix_user_password')

--Disable Outgoing Email (Admin > System Settings > Configuration - Internet Staff)
IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'disable_outgoing_email') BEGIN
	UPDATE SYSTEMINFO SET KEYWORDVALUE = 'true' WHERE KEYWORD = 'disable_outgoing_email' and cast(KEYWORDVALUE as varchar(5)) = 'false'
END
ELSE BEGIN
	INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('disable_outgoing_email', 'true')
END

