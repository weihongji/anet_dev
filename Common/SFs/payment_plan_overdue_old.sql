CREATE FUNCTION Payment_plan_overdue(@arscheduleheader_id INT, @curdate DATETIME)
RETURNS MONEY
AS
BEGIN
	RETURN dbo.Minimum(
		dbo.Maximum(
			(
				SELECT Isnull(Sum(art.amount), 0)
				FROM artransactions art, arscheduleheader arsh
				WHERE arsh.arscheduleheader_id = @arscheduleheader_id AND arsh.arscheduleheader_id = art.arscheduleheader_id
					AND art.voided = 0
					AND (
						arsh.permit_id > 0
						OR arsh.auto_pay_dcprogram_id > 0
						OR (
							(art.transactiontype <> 4 OR art.amount >= 0)
							AND (art.transactiontype <> 7 OR art.amount <= 0)
						)
					)
			)
			- (
				SELECT Isnull(Sum(amountdue), 0)
				FROM arscheduledetail
				WHERE arscheduleheader_id = @arscheduleheader_id
					AND datedue > @curdate
					AND voided = 0
			)
			, 0
		)
		, dbo.Payment_plan_due(@arscheduleheader_id)
	)
END