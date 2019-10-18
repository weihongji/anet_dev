--USE 
SELECT ACTIVENET_SITES_USER_ID, NEVER_EXPIRE, RETIRED, FAILED_LOGON_COUNT, * FROM SYSTEM_USERS WHERE USERNAME = 'recware'
SELECT ORIGINALCITY FROM SYSTEM --Sacramento

SELECT * FROM SYSTEMINFO WHERE KEYWORD IN ('use_akamai', 'use_akamai_cui', 'use_akamai_cui_security')
SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'disable_outgoing_email'

SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'shorten_thread_timeouts'
/*
--Set password to "safari"
UPDATE SYSTEM_USERS SET PASSWORD='safari' WHERE SYSTEMUSER_ID = 2 AND PASSWORD='4ibf6o'

--UPDATE SYSTEM_USERS SET ACTIVENET_SITES_USER_ID = 0, PASSWORD='safari', NEVER_EXPIRE = -1, USERNAME = 'recware' WHERE USERNAME = 'jwei'
--UPDATE SYSTEM_USERS SET PASSWORD='safari', RETIRED = 0, NEVER_EXPIRE = -1, FAILED_LOGON_COUNT = 0 WHERE USERNAME = 'recware'

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'allow_clear_text_password_logon_text') BEGIN
	UPDATE SYSTEMINFO SET KEYWORDVALUE = 'true' WHERE KEYWORD = 'allow_clear_text_password_logon_text' and cast(KEYWORDVALUE as varchar(5)) = 'false'
END
ELSE BEGIN
	INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('allow_clear_text_password_logon_text', 'true')
END

UPDATE SYSTEMINFO SET KEYWORDVALUE = 'false' WHERE KEYWORD = 'use_akamai' and cast(KEYWORDVALUE as varchar(5)) = 'true'
IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'use_akamai_cui') BEGIN
	UPDATE SYSTEMINFO SET KEYWORDVALUE = 'false' WHERE KEYWORD = 'use_akamai_cui' and cast(KEYWORDVALUE as varchar(5)) = 'true'
END
ELSE BEGIN
	INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('use_akamai_cui', 'false')
END
IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'use_akamai_cui_security') BEGIN
	UPDATE SYSTEMINFO SET KEYWORDVALUE = 'false' WHERE KEYWORD = 'use_akamai_cui_security' and cast(KEYWORDVALUE as varchar(5)) = 'true'
END
ELSE BEGIN
	INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('use_akamai_cui_security', 'false')
END

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'disable_outgoing_email') BEGIN
	UPDATE SYSTEMINFO SET KEYWORDVALUE = 'true' WHERE KEYWORD = 'disable_outgoing_email' and cast(KEYWORDVALUE as varchar(5)) = 'false'
END
ELSE BEGIN
	INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('disable_outgoing_email', 'true')
END

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'org_cache_mode' AND KEYWORDVALUE LIKE 'REMOTE') BEGIN
	UPDATE SYSTEMINFO SET KEYWORDVALUE = 'LOCAL' WHERE KEYWORD = 'org_cache_mode' AND KEYWORDVALUE LIKE 'REMOTE'
END

UPDATE REPORTDEFINITION set ENABLE_SCHEDULE_REPORT = 0 where ENABLE_SCHEDULE_REPORT = -1
UPDATE REPORTDEFINITION set ENABLE_EXPORT_TO_FTP = 0 where ENABLE_EXPORT_TO_FTP = -1

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'use_enhanced_customer_view') BEGIN
	UPDATE SYSTEMINFO SET KEYWORDVALUE = 'false' WHERE KEYWORD = 'use_enhanced_customer_view' and cast(KEYWORDVALUE as varchar(5)) = 'true'
END
ELSE BEGIN
	INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('use_enhanced_customer_view', 'false')
END

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'cui_url') BEGIN
	update SYSTEMINFO set keywordvalue = 'apm.activenet.com' where KEYWORD = 'cui_url' and keywordvalue like '%apm.activecommunities.com'
END
ELSE BEGIN
	INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('cui_url', 'apm.activenet.com')
END

IF EXISTS(SELECT * FROM SYSTEMINFO WHERE KEYWORD = 'shorten_thread_timeouts') BEGIN
	UPDATE SYSTEMINFO SET KEYWORDVALUE = 'true' WHERE KEYWORD = 'shorten_thread_timeouts' and cast(KEYWORDVALUE as varchar(5)) = 'false'
END
ELSE BEGIN
	INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('shorten_thread_timeouts', 'true')
END

SELECT * FROM SYSTEMINFO WHERE KEYWORD  = 'Image_Storage_Path'
--UPDATE SYSTEMINFO SET KEYWORDVALUE = 'F:\fpdccrecreation' WHERE KEYWORD  = 'Image_Storage_Path'

SELECT * FROM SYSTEMINFO WHERE KEYWORD='system_user_max_logon_retries'
INSERT INTO SYSTEMINFO (KEYWORD, KEYWORDVALUE) VALUES ('system_user_max_logon_retries', '0')
*/

/*
SELECT * FROM DATABASE_ATTRIBUTES
select * from SYSTEMUSAGELOG where SYSTEMUSER_ID = 55
--Your account is suspended. Please email Traci Tokunaga or Richard Guimmond.
select ORIGINALCITY, * from system --Sacramento
*/