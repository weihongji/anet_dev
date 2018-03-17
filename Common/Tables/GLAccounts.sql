SELECT * FROM GLACCOUNTS WHERE SYSTEM_ACCOUNT > 0 ORDER BY SYSTEM_ACCOUNT
select top 5 * from CUSTOMERS order by CUSTOMER_ID desc

select * from RECEIPTHEADERS (nolock) where DATESTAMP > '20150618 07:00' and VOIDED = 0

SELECT 'E:\Projects\ActiveNet\Dev\_Common\Functionalities\GL_Ledger\SQLQuery1.sql'