CREATE Function payment_plan_due(@arscheduleheader_id int) returns money
AS
Begin
	RETURN dbo.maximum(
		(
			select isnull(sum(amount),0) from artransactions
			where arscheduleheader_id=@arscheduleheader_id and voided=0
		)
		,0
	)
End
