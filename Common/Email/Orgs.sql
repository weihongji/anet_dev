select orgsite_id, orgs.org_id, site_url, org_name, trainer, servlet_version, poolip
from orgs, orgsites, pools
where orgsites.org_id=orgs.org_id
	and orgsites.databasepool_id = pools.pool_id
	and orgs.site_url = 'V1540_ActivenetDB'
	and retired=0
order by site_url, abs(trainer)


declare @org_id int = 1001, @org_site_id int, @db_pool_id int
select @org_site_id = ORGSITE_ID, @db_pool_id = DATABASEPOOL_ID from ORGSITES where ORG_ID = @org_id

select * from orgs where ORG_ID = @org_id
select * from ORGSITES where ORG_ID = @org_id
select * from Sites where ORGSITE_ID = @org_site_id
select * from POOLS where POOL_ID = @db_pool_id
/*
update ORGS set SITE_URL = 'V1540_ActivenetDB', ORG_NAME = 'ActivenetDB 15.40' where ORG_ID = @org_id
update ORGS set RETIRED = -1 where ORG_ID != @org_id and RETIRED = 0
update ORGSITES set TRAINER = 0, SERVLET_VERSION = '15.40' where ORG_ID = @org_id and SERVLET_VERSION != '15.40'
*/

select * from SYSTEMINFO where KEYWORD = 'smtpserver'