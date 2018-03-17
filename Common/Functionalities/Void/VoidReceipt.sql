declare @receiptnumber money
declare @receiptheader_id int
declare @transaction_id table(transaction_id int not null)
set @receiptnumber = 3001584.023
set @receiptheader_id = (select receiptheader_id from receiptheaders where receiptnumber = @receiptnumber)
insert into @transaction_id (transaction_id) select transaction_id from transactions where receiptheader_id = @receiptheader_id

--SELECT @receiptheader_id AS RECEIPTHEADER_ID, @transaction_id AS TRANSACTION_ID

declare @action varchar(30)
set @action = 'SHOW'

if isnull(@action, 'SHOW') <> 'VOID' begin
	print 'SHOW...'
	select * from receiptheaders where receiptheader_id = @receiptheader_id
	select * from transactions where transaction_id in (select * from @transaction_id)
	select * from receiptdetails where transaction_id in (select * from @transaction_id)
	select * from receiptpayments where receiptheader_id=@receiptheader_id and voided=0
	select * from gl_ledger where receiptdetail_id in (select receiptdetail_id from DBO.RECEIPTDETAILS where transaction_id in (select * from @transaction_id))
	select * from gl_ledger where receiptpayment_id in ( select receiptpayment_id from DBO.RECEIPTPAYMENTS where receiptheader_id=@receiptheader_id and paymenttype_id = 1)
	select * from arscheduleheader where RECEIPTPAYMENT_ID in (select RECEIPTPAYMENT_ID from RECEIPTPAYMENTS where RECEIPTHEADER_ID in (@receiptheader_id))
	select * from arscheduledetail where ARSCHEDULEHEADER_ID in (select ARSCHEDULEHEADER_ID from arscheduleheader where RECEIPTPAYMENT_ID in (select RECEIPTPAYMENT_ID from RECEIPTPAYMENTS where RECEIPTHEADER_ID in (@receiptheader_id)))
	select * from artransactions where ARSCHEDULEHEADER_ID in (select ARSCHEDULEHEADER_ID from ARSCHEDULEHEADER arsh join RECEIPTPAYMENTS rp on arsh.RECEIPTPAYMENT_ID=rp.RECEIPTPAYMENT_ID where rp.RECEIPTHEADER_ID in (@receiptheader_id))
	select * from artransactions where RECEIPTHEADER_ID = @receiptheader_id --Added by Jesse
	select * from discountdependencylinks where transaction_id in (select * from @transaction_id)
	select * from gift_certificates where gift_certificate_id in (select gift_certificate_id from transactions where transactiontype = 52 and transaction_id in (select * from @transaction_id))
	select * from customerscholarship where receiptdetail_id in (select receiptdetail_id from RECEIPTDETAILS where transaction_id in (select * from @transaction_id))
	select * from facility_schedule_checkinout where facility_schedule_id in ( select facility_schedule_id from facility_schedules where transaction_id in (select * from @transaction_id))
	select * from activityattendance where facility_schedule_id in ( select facility_schedule_id from facility_schedules where transaction_id in (select * from @transaction_id))
	select * from facility_schedules where transaction_id in (select * from @transaction_id)
	select * from locker_schedules where transaction_id in (select * from @transaction_id)
	select * from campaign_scheduled_donations where receiptheader_id is null and campaign_donation_id in (select campaign_donation_id from campaign_donations where original_transaction_id in (select * from @transaction_id))
	select * from usage_fee_transactions where receiptheader_id=@receiptheader_id
	select * from linkedcredits where customeraccount_id in(select customeraccount_id from DBO.CUSTOMERACCOUNTS where receiptheader_id=@receiptheader_id)
	select * from customeraccounts where receiptheader_id=@receiptheader_id
	select * from activitystatistics where 1=2
	select * from couponstatistics cs left outer join DBO.transactioncoupons tc on cs.coupon_id=tc.coupon_id left outer join DBO.TRANSACTIONS t on t.transaction_id = tc.transaction_id where t.transaction_id in (select * from @transaction_id)
	select * from transactioncoupons where transaction_id in (select * from @transaction_id)
	select * from membership_usages where receiptheader_id=@receiptheader_id
	select * from dcregistrationchanges where transaction_id in (select * from @transaction_id)
end
else begin
	update receiptheaders set voided=-1,voidedon=GETDATE(),voidedby=2 where receiptheader_id=@receiptheader_id
	update receiptheaders set validation_status=1 where receiptheader_id=@receiptheader_id
	update transactions set voided=-1,voidedon=GETDATE(),voidedby=2,originaltransactiontype=transactiontype,transactiontype=18 where transaction_id in (select * from @transaction_id)
	update receiptdetails set voided=-1,voidedon=GETDATE(),voidedby=2 where transaction_id in (select * from @transaction_id)
	update receiptpayments set voided=-1,voidedon=GETDATE(),voidedby=2 where receiptheader_id=@receiptheader_id and voided=0
	update gl_ledger set voided=-1,voidedon=GETDATE(),voidedby=2 where receiptdetail_id in (select receiptdetail_id from DBO.RECEIPTDETAILS where transaction_id in (select * from @transaction_id))
	update gl_ledger set voided = -1, voidedon = GETDATE(), voidedby = 2 where receiptpayment_id in ( select receiptpayment_id from DBO.RECEIPTPAYMENTS where receiptheader_id=@receiptheader_id and paymenttype_id = 1)
	update arscheduleheader set voided=-1, VOIDEDON=GETDATE(), VOIDEDBY=2 where RECEIPTPAYMENT_ID in (select RECEIPTPAYMENT_ID from RECEIPTPAYMENTS where RECEIPTHEADER_ID in (@receiptheader_id))
	update ARSCHEDULEDETAIL set voided=-1, VOIDEDON=GETDATE(), VOIDEDBY=2 where ARSCHEDULEHEADER_ID in (select ARSCHEDULEHEADER_ID from arscheduleheader where RECEIPTPAYMENT_ID in (select RECEIPTPAYMENT_ID from RECEIPTPAYMENTS where RECEIPTHEADER_ID in (@receiptheader_id)))
	update artransactions set voided=-1, voidedon=getdate(), voidedby=2 where ARSCHEDULEHEADER_ID in (select ARSCHEDULEHEADER_ID from ARSCHEDULEHEADER arsh join RECEIPTPAYMENTS rp on arsh.RECEIPTPAYMENT_ID=rp.RECEIPTPAYMENT_ID where rp.RECEIPTHEADER_ID in (@receiptheader_id))
	update discountdependencylinks set counted_as_person=0,counted_as_item=0,counted_as_transaction=0 where transaction_id in (select * from @transaction_id)
	update gift_certificates set  status = 2 where gift_certificate_id in (select gift_certificate_id from transactions where transactiontype = 52 and transaction_id in (select * from @transaction_id))
	delete from customerscholarship where receiptdetail_id in (select receiptdetail_id from RECEIPTDETAILS where transaction_id in (select * from @transaction_id))
	delete from facility_schedule_checkinout where facility_schedule_id in ( select facility_schedule_id from facility_schedules where transaction_id in (select * from @transaction_id))
	delete from activityattendance where facility_schedule_id in ( select facility_schedule_id from facility_schedules where transaction_id in (select * from @transaction_id))
	delete from facility_schedules where transaction_id in (select * from @transaction_id)
	delete from locker_schedules where transaction_id in (select * from @transaction_id)
	delete from campaign_scheduled_donations where receiptheader_id is null and campaign_donation_id in (select campaign_donation_id from campaign_donations where original_transaction_id in (select * from @transaction_id))
	update usage_fee_transactions set voided=-1 where receiptheader_id=@receiptheader_id
	update linkedcredits set unlinked=-1,unlinked_date=GETDATE(),unlinked_by=2 where customeraccount_id in(select customeraccount_id from DBO.CUSTOMERACCOUNTS where receiptheader_id=@receiptheader_id)
	update customeraccounts set voided=-1,voidedon=GETDATE(),voidedby=2 where receiptheader_id=@receiptheader_id
	--update activitystatistics with (updlock) set number_enrolled=number_enrolled-@P0,number_open=100-number_enrolled-number_of_holds-pending_adds+number_unassigned+number_unassigned_hold-pending_reserved_adds-number_reserved+@P1 where activitystatistics_id=@P2                          ,1,1,47
	--update cs set number_of_usage=cs.number_of_usage - t.QUANTITY from DBO.couponstatistics cs left outer join DBO.transactioncoupons tc on cs.coupon_id=tc.coupon_id left outer join DBO.TRANSACTIONS t on t.transaction_id = tc.transaction_id where t.transaction_id in (select * from @transaction_id)
	update transactioncoupons set refunded=-1 where transaction_id in (select * from @transaction_id)
	update membership_usages set voidedon=GETDATE(), voidedby=2 where receiptheader_id=@receiptheader_id
	update dcregistrationchanges set voided=-1, VOIDEDON=GETDATE(), VOIDEDBY=2 where transaction_id in (select * from @transaction_id)
	print 'VOIDED'
end
