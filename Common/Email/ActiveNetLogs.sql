--use ActiveNetSites
/*
select * from systeminfo where keyword = 'AttachmentFolder'

select orgsite_id, orgs.org_id, site_url, org_name, trainer, servlet_version, poolip
from ActiveNetSites.dbo.orgs, ActiveNetSites.dbo.orgsites, ActiveNetSites.dbo.pools
where orgsites.org_id=orgs.org_id
	and orgsites.databasepool_id = pools.pool_id
	and site_url = 'ymcaofthesuncoast'
	--and retired=@p1
order by site_url, abs(trainer)
*/

SELECT TOP 100 * FROM ActiveNetSites.dbo.APPLICATION_LOG (NOLOCK)
WHERE ORG_SITE_ID = 2586 AND EVENT_TIME_UTC BETWEEN '2016-10-15 0:00' AND '2016-10-15 7:10'
	AND SOURCE_APPLICATION = 'EmailService'
	AND MESSAGE_TYPE = 8
	AND CONVERT(varchar(100), MESSAGE) <> 'Skipped sending'
ORDER BY APPLICATION_LOG_ID


SELECT TOP 100 * FROM activenetlogs.dbo.APPLICATION_LOG_View (NOLOCK)
WHERE ORG_SITE_ID = 2377
	AND EVENT_TIME_UTC BETWEEN '2016-10-15 0:00' AND '2016-10-15 7:10'
	AND SOURCE_APPLICATION = 'EmailService'
	AND MESSAGE_TYPE = 8
	AND CONVERT(varchar(100), MESSAGE) <> 'Skipped sending'
ORDER BY APPLICATION_LOG_ID

--Service Start log
SELECT TOP 10 * FROM ActiveNetSites.dbo.APPLICATION_LOG (NOLOCK)
WHERE EVENT_TIME_UTC BETWEEN '2016-07-12' AND '2016-07-14'
       AND SOURCE_APPLICATION = 'EmailService'
       AND MESSAGE_TYPE = 2
       AND substring(MESSAGE, 1, 16) = 'Processing Sites'
ORDER BY APPLICATION_LOG_ID




