
select * from CREDITCARDS where CUSTOMER_ID = 921328
select * from RECEIPTPAYMENTS where saved_creditcard_id = 52948
select * from ARSCHEDULEHEADER where saved_creditcard_id = 52948
	select * from ARTRANSACTIONS where ARSCHEDULEHEADER_ID = 175711 --sum(amount) = 0.00
	select * from receiptheaders where RECEIPTHEADER_ID= 849233 --1078515.0020
	select * from receiptheaders where receiptheader_id= 849289 --1078522.0020 --adjustment
select * from CAMPAIGN_DONATIONS where saved_creditcard_id = 52948
select * from MEMBERSHIPS where saved_creditcard_id = 52948
select * from SECONDARYPAYMENTS where saved_creditcard_id = 52948

--datafix
update ARSCHEDULEHEADER set saved_creditcard_id = NULL where ARSCHEDULEHEADER_ID = 175711 and saved_creditcard_id = 52948
--rollback
update ARSCHEDULEHEADER set saved_creditcard_id = 52948 where ARSCHEDULEHEADER_ID = 175711 and saved_creditcard_id = NULL