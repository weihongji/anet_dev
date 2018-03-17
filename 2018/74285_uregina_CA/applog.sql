--use ActiveNetLogs

/*
select * from APPLICATION_LOG_view where application_log_id=5844620933 --Org time: Jan 15, 2018 10:23 PM
*/

DECLARE @org_time_start AS DATETIME = '20180301 0:38'
DECLARE @org_time_end AS DATETIME = '20180301 00:40'
DECLARE @utc_offset AS int = 6
DECLARE @utc_start AS DATETIME = DATEADD(HOUR, @utc_offset, @org_time_start)
DECLARE @utc_end AS DATETIME = DATEADD(HOUR, @utc_offset, @org_time_end)
	

SELECT TOP 100 APPLICATION_LOG_ID, MESSAGE_TYPE, DATEADD(HOUR, -@utc_offset, EVENT_TIME_UTC) AS [DateStamp (Org Time)], replace(replace(CAST([MESSAGE] AS VARCHAR(MAX)), char(10), '->'), char(13), '') AS [MESSAGE]
	, CALL_STACK, EVENT_TIME_UTC, IP_ADDRESS, SOURCE_APPLICATION, SOURCE_VERSION, EXCEPTION_CLASS, SQL_ERROR_CODE, SQL_STATEMENT_STACK, THREAD_ID, MESSAGE_SUBTYPE
FROM ActiveNetLogs.dbo.APPLICATION_LOG_20180315 (nolock)
WHERE ORG_SITE_ID = 3162
	AND EVENT_TIME_UTC BETWEEN @utc_start AND @utc_end
	--AND MESSAGE LIKE 'Auto-Payment Plans;%'						--Org Time: 00:28:22, application_log_id: 2113158398, Message: Auto-Payment Plans; 443 auto-payments to process...
	--AND MESSAGE LIKE 'Starting to initialize org site: uregina'	--Org Time: 00:38:55, application_log_id: 2113257688
ORDER BY APPLICATION_LOG_ID

/*
select * from APPLICATION_LOG_view where application_log_id=622946 --Org time: 15 Mar 2018 3:13 AM, UTC: 2018-03-15 09:13:49.000

select OS.orgsite_id, O.org_id, site_url, org_name, trainer, servlet_version, poolip
from ActiveNetStaging.dbo.orgs O
	INNER JOIN ActiveNetStaging.dbo.orgsites OS ON OS.ORG_ID = O.ORG_ID
	INNER JOIN ActiveNetStaging.dbo.pools P ON OS.DATABASEPOOL_ID = P.POOL_ID
where O.site_url = 'uregina'
order by site_url, abs(trainer)
*/