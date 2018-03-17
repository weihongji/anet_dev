select OS.orgsite_id, O.org_id, site_url, org_name, trainer, servlet_version, poolip, S.*
from ActiveNetSites.dbo.orgs O
	INNER JOIN ActiveNetSites.dbo.orgsites OS ON OS.ORG_ID = O.ORG_ID
	INNER JOIN ActiveNetSites.dbo.pools P ON OS.DATABASEPOOL_ID = P.POOL_ID
	INNER JOIN ActiveNetSites.dbo.ORGSITE_SERVER OSS ON OS.ORGSITE_ID = OSS.ORGSITE_ID
	INNER JOIN ActiveNetSites.dbo.[SERVERS] S ON S.SERVER_ID = OSS.SERVER_ID
where O.site_url = 'seattleymca'
order by site_url, abs(trainer)

-- get server
select sv.* from sites s
	inner join [ORGSITE_SERVER] oss on s.orgsite_id = oss.orgsite_id
	inner join [servers] sv on oss.server_id = sv.server_id
where s.url = 'burnaby129'