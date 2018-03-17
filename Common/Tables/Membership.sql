SELECT * FROM SYSTEMINFO WHERE KEYWORD IN ('allow_renewal_within_days', 'membership_auto_renewal_lead_time', 'retention_period', 'membership_auto_renewal_payment_fail_action')

SELECT PS.CUSTOMER_ID, PS.PASSNUMBER, M.MEMBERSHIP_ID, M.PACKAGE_ID, P.PACKAGENAME, M.PRIMARYMEMBERCUSTOMER_ID, M.DATEEXPIRES
	, M.STATUS, M.RENEW_BY, M.AUTORENEWALTYPE, M.AUTORENEWALSTATUS, M.SUSPEND_AUTO_RENEWAL
FROM PASSES PS
	LEFT JOIN MEMBERSHIP_PASSES MP ON PS.PASS_ID = MP.PASS_ID
	LEFT JOIN MEMBERSHIPS M ON MP.MEMBERSHIP_ID = M.MEMBERSHIP_ID
	LEFT JOIN PACKAGES P ON M.PACKAGE_ID = P.PACKAGE_ID
WHERE PS.CUSTOMER_ID = 72622


SELECT * FROM Customer_Membership_Dates with(nolock) where CUSTOMER_ID = 100
SELECT * FROM MEMBERSHIP_SINCE_DATES with(nolock)

SELECT AUTORENEWALTYPE, PREVIOUS_DATE_EXPIRES, DATEEXPIRES, punch_pass_expired_on, * FROM MEMBERSHIPS WHERE PRIMARYMEMBERCUSTOMER_ID = 100

SELECT * FROM MEMBERSHIPAUTORENEWAL

SELECT RECEIPTHEADER_ID, DATESTAMP, * FROM TRANSACTIONS WHERE MEMBERSHIP_ID = 191331

select SPECIFICNUMBEROFDAYS, SPECIFIC_RENEW_PERIOD, * from PACKAGES where PACKAGE_ID = 33

/*AUTO-RENEWAL*/
declare @P0 int,@P1 int,@P2 datetime,@P3 datetime,@P4 datetime
select  @P0 = 1, @P1 = 0, @P2 = '1899-12-30 00:00:00', @P3 = '2015-03-31 00:00:00', @P4 = '2015-06-29 00:00:00' /*expired date - 1 day*/
select count(*) from DBO.MEMBERSHIPS m inner join DBO.PACKAGES p on m.package_id = p.package_id
where p.packagestatus = 0 and (p.specifictimeperiod > 0 OR p.specificnumberofdays > 0)
	and m.status = @P0 and m.suspend_auto_renewal = 0
	and m.autorenewaltype <> @P1
	and ((m.dateexpires = @P2 and m.maxuses > 0) or m.dateexpires >= @P3)
	and m.dateexpires <= @P4
	and PRIMARYMEMBERCUSTOMER_ID = 115

/* Suspended Memberships - Not handle timezone */
SELECT DATESUSPENDEDFROM, DATESUSPENDEDto, DATEEXPIRES, Status, * FROM MEMBERSHIPS
WHERE Status = 1
	AND (ISNULL(DATEEXPIRES, '1899-12-30') = '1899-12-30' OR CONVERT(varchar, GETDATE(), 112) <= DATEEXPIRES)
	AND (
		(
			DATESUSPENDEDFROM > '1899-12-30'
			AND DATESUSPENDEDFROM <= CONVERT(varchar, GETDATE(), 112)
			AND ((ISNULL(DATESUSPENDEDTO, '1899-12-30') <= '1899-12-30') OR CONVERT(varchar, GETDATE(), 112) < DATESUSPENDEDTO)
		)
		OR
		(
			ISNULL(DATESUSPENDEDFROM, '1899-12-30') <= '1899-12-30'
			AND CONVERT(varchar, GETDATE(), 112) < DATESUSPENDEDTO
		)
	)

/* Suspend Auto Renewal */
/*
1. When cancel date is reached, then skip this one and suspend auto renew. (MembershipAutoPaymentWorker.java)
*/

/*
specifictimeperiod:
	specific = 0;
	number_days = 1;
	weekly = 2;
	biweekly = 3;
	semimonthly = 4;
	monthly = 5;
	bimonthly = 6;
	quarterly = 7;
	semiannually = 8;
	annually = 9;

specific_day_of_month: (Available when specifictimeperiod>= monthly)
	0 = end of month
	1 - 31 = day of month

validate_anniversary_date:
	-1 = Force expiration date to specific_day_of_month
	 0 = Unchecked
*/
SELECT specifictimeperiod, validate_anniversary_date, specific_day_of_month, * FROM PACKAGES WHERE PACKAGE_ID = 25
