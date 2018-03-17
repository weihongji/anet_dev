CREATE FUNCTION payment_plan_overdue (@arscheduleheader_id int, @curdate datetime) 
RETURNS TABLE
AS
RETURN
    select min(amount) as overdue_amt
	from(
			select max(amount) as amount
			from(
					select 0 AS amount
					union
					select
						isnull((
							select sum(art.AMOUNT) from dbo.ARTRANSACTIONS art cross join dbo.ARSCHEDULEHEADER arsh
							where arsh.ARSCHEDULEHEADER_ID=@arscheduleheader_id 
								and arsh.ARSCHEDULEHEADER_ID=art.ARSCHEDULEHEADER_ID
								and art.VOIDED=0 
								and (
									arsh.PERMIT_ID>0 
									or arsh.AUTO_PAY_DCPROGRAM_ID>0
									or (
										(art.TRANSACTIONTYPE<>4 or art.AMOUNT>=0) 
										and (art.TRANSACTIONTYPE<>7 or art.AMOUNT<=0)
									)
								)
						), 0)
						- isnull((
							select sum(AMOUNTDUE) from dbo.ARSCHEDULEDETAIL where ARSCHEDULEHEADER_ID=@arscheduleheader_id and DATEDUE>@curdate and VOIDED=0
						), 0)
				) sql
			union
			select max(amount)
			from(
					select 0 AS amount
					union
					select sum(AMOUNT) from dbo.ARTRANSACTIONS where ARSCHEDULEHEADER_ID=@arscheduleheader_id and VOIDED=0
				) sql
		) sql;
