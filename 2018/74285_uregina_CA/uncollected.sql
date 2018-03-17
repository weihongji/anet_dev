--use uregina
/* Run this query on a live db at March 15, 2018 3:27:34 AM (org time, Canada/Saskatchewan) */
declare @P0 datetime
select @p0 = '2018-03-01 00:00:00'
select c.CUSTOMER_ID, c.FIRSTNAME, c.LASTNAME, h.RECEIPTNUMBER, ah.*, rp.receiptheader_id
	, (
		OVERDUE.overdue_amt - (
			select isnull(sum(lc.linked_amount), 0)
			from DBO.LinkedCredits lc
				inner join DBO.ARTRANSACTIONS art on art.artransaction_id = lc.artransaction_id
			where art.arscheduleheader_id = ah.arscheduleheader_id and art.voided = 0 and lc.unlinked = 0
		)
	) as owed
	, sep.credit_card_id sep_credit_card_id, sep.customer_id sep_customer_id, sep.company_id sep_company_id, sep.ams_account_id sep_ams_account_id
	, sep.card_name sep_card_name, sep.card_number sep_card_number, sep.card_expiration sep_card_expiration, sep.cardtype_id sep_cardtype_id
	, sep.bank_routing_number sep_bank_routing_number, sep.bank_account_number sep_bank_account_number, sep.bank_account_type sep_bank_account_type
	, sep.exclude_credit_card sep_exclude_credit_card, sep.retired sep_retired, sep.is_secondary_payment sep_is_secondary_payment
	, sep.ams_retention_date sep_ams_retention_date
from DBO.ARSCHEDULEHEADER ah
	inner join DBO.RECEIPTPAYMENTS rp on ah.receiptpayment_id = rp.receiptpayment_id
	inner join RECEIPTHEADERS h on h.RECEIPTHEADER_ID = rp.RECEIPTHEADER_ID
	inner join customers c on ah.customer_id = c.customer_id
	cross apply dbo.PAYMENT_PLAN_OVERDUE(ah.arscheduleheader_id, @P0) OVERDUE
	left outer join DBO.creditcards sep on ah.saved_creditcard_id = sep.credit_card_id
where (
		OVERDUE.overdue_amt
		- (
			select isnull(sum(lc.linked_amount), 0)
			from DBO.LinkedCredits lc
				inner join DBO.ARTRANSACTIONS art on art.artransaction_id = lc.artransaction_id
			where art.arscheduleheader_id = ah.arscheduleheader_id and art.voided = 0 and lc.unlinked = 0
		)
	) > 0
	and suspend_auto_pay = 0
	and auto_payment_type in (1,2,3) and auto_payment_status in (0, 10, 11)
order by c.CUSTOMER_ID
