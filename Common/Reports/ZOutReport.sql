SELECT RECEIPTHEADERS.datestamp, RECEIPTHEADERS.receiptnumber, (-1) AS department_id, ('') AS departmentname, (1) AS departmentsort, receiptdetails.charge_id, receiptdetails.description, glaccounts.glaccount_id
	, Case WHEN RECEIPT_DETAIL_PAYMENTS_ORGINAL.IS_MULTIGL = -1 then 'Multiple accounts'  Else  glaccounts.accountnumber end AS accountnumber
	, RECEIPT_DETAIL_PAYMENTS_ORGINAL.amount, receiptpayments.paymenttype_id
	, (
		case
			when transactions.activity_id > 0 then 1
			else (
				case when transactions.permit_id > 0 then 2
				else (
					case
						when transactions.membership_id > 0 then 3
						else (
							case
								when transactions.DCPROGRAM_ID > 0 then 4
								else (
									case
										when transactions.posproduct_id > 0 then 5
										else 99
									end
								)
								end
							)
						end
					)
				end
			)
		end
	) AS module
	, receiptpayments.cardtype_id, cardtypes.cardname, (0) AS zoutreport_id
FROM RECEIPT_DETAIL_PAYMENTS_ORGINAL
	JOIN RECEIPTPAYMENTS ON RECEIPT_DETAIL_PAYMENTS_ORGINAL.receiptpayment_id=RECEIPTPAYMENTS.receiptpayment_id
	JOIN RECEIPTDETAILS ON RECEIPT_DETAIL_PAYMENTS_ORGINAL.receiptdetail_id=RECEIPTDETAILS.receiptdetail_id
	JOIN GLACCOUNTS ON RECEIPT_DETAIL_PAYMENTS_ORGINAL.glaccount_id=GLACCOUNTS.glaccount_id
	JOIN TRANSACTIONS ON RECEIPTDETAILS.transaction_id=TRANSACTIONS.transaction_id
	JOIN RECEIPTHEADERS ON RECEIPTPAYMENTS.receiptheader_id=RECEIPTHEADERS.receiptheader_id
	JOIN SITES ON RECEIPTHEADERS.site_id=SITES.site_id
	LEFT JOIN DEPARTMENTS ON GLACCOUNTS.department_id=DEPARTMENTS.department_id
	JOIN SYSTEM_USERS ON RECEIPTPAYMENTS.systemuser_id=SYSTEM_USERS.systemuser_id
	LEFT JOIN CARDTYPES ON RECEIPTPAYMENTS.cardtype_id=CARDTYPES.cardtype_id
	JOIN WORKSTATIONS ON RECEIPTHEADERS.station_id=WORKSTATIONS.workstation_id
	LEFT JOIN WORKSTATIONGROUPS ON WORKSTATIONS.workstationgroup_id=WORKSTATIONGROUPS.workstationgroup_id
WHERE WORKSTATIONS.workstation_id in (13)
	AND receiptheaders.voided = 0
	AND receiptheaders.zoutreport_id is null
ORDER BY module, receiptdetails.description, receiptdetails.charge_id, accountnumber, glaccounts.glaccount_id

--select * from ZOUTREPORTS where workstation_id = 13 order by ZOUTREPORT_id desc

