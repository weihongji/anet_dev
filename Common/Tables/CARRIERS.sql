/*
SELECT * INTO CARRIERS_Jesse FROM CARRIERS
TRUNCATE TABLE CARRIERS

SELECT * FROM CARRIERS_Jesse
*/

SELECT * FROM CARRIERS

SET IDENTITY_INSERT CARRIERS ON

INSERT INTO CARRIERS(CARRIER_ID, CARRIER_NAME, CARRIER_DOMAIN, COUNTRY_ABBR)
VALUES ('1', 'AT&T', 'txt.att.net', 'US')
, ('2', 'Alltel', 'message.Alltel.com', 'US')
, ('3', 'Centennial Wireless', 'cwemail.com', 'US')
, ('4', 'Cingular', 'mobile.mycingular.com', 'US')
, ('5', 'Metrocall', 'page.metrocall.com', 'US')
, ('6', 'Nextel', 'messaging.nextel.com', 'US')
, ('7', 'Sprint PCS', 'messaging.sprintpcs.com', 'US')
, ('8', 'T-Mobile', 'tmomail.net', 'US')
, ('9', 'US Cellular', 'email.uscc.net', 'US')
, ('10', 'Verizon', 'vtext.com', 'US')
, ('11', 'Aliant', 'aliant.txt.ca', 'CA')
, ('12', 'Bell', 'txt.bell.ca', 'CA')
, ('13', 'Fido', 'fido.ca', 'CA')
, ('14', 'MTS', 'ext.mts.net', 'CA')
, ('15', 'Rogers', 'pcs.rogers.com', 'CA')
, ('16', 'Telus', 'msg.telus.com', 'CA')
, ('17', 'Sasktel', 'sms.sasktel.com', 'CA')
, ('18', 'I wireless', 'iwspcs.net', 'US')
, ('19', 'Cricket', 'sms.mycricket.com', 'US')
, ('20', 'Boost', 'myboostmobile.com', 'US')
, ('21', 'Straight Talk', 'vtext.com', 'US')
, ('22', 'Westlink', 'westlinkmail.com', 'US')
, ('23', 'Cellcom', 'cellcom.quiktext.com', 'US')
, ('24', 'United Wireless', 'sms.unitedwireless.com', 'US')
, ('25', 'Virgin Mobile', 'vmobl.com', 'US')
, ('26', 'General Communications Inc.', 'mobile.gci.net', 'US')
, ('27', 'Alaska Communications', 'msg.acsalaska.com', 'US')
, ('28', 'Viaero', 'viaerosms.com', 'US')
, ('29', 'Consumer Cellular', 'https://www.consumercellular.com/', 'US')
, ('30', 'Metro PCS', 'mymetropcs.com', 'US')
, ('31', 'Koodo', 'msg.telus.com', 'CA')

SET IDENTITY_INSERT CARRIERS Off