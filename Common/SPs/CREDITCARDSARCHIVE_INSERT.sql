CREATE PROCEDURE dbo.CREDITCARDSARCHIVE_INSERT
	@creditcard_id int,
	@upd_ams_account_id varchar(100),
	@upd_customer_id int,
	@upd_company_id int,
	@upd_card_number varchar(20),
	@upd_card_expiration varchar(10),
	@upd_card_type_id int,
	@upd_bank_account_number varchar(50),
	@upd_bank_routing_number varchar(50),
	@additional_detail varchar(2000),
	@id int output
AS
	/*
	*  Stored procedure that inserts a record to the CREDITCARDS_ARCHIVE table if any of the passed
	*  values differs from the existing record in the CREDITCARDS table. Called before existing record
	*  in the CREDITCARDS table is updated.
	*/
	INSERT INTO CREDITCARDS_ARCHIVE(
		CREDIT_CARD_ID, AMS_ACCOUNT_ID, CUSTOMER_ID, COMPANY_ID, CARD_NUMBER, CARD_EXPIRATION, CARDTYPE_ID, BANK_ACCOUNT_NUMBER, BANK_ROUTING_NUMBER, ARCHIVED_DATETIME, ADDITIONAL_DETAIL
	)
	SELECT CREDIT_CARD_ID, AMS_ACCOUNT_ID, CUSTOMER_ID, COMPANY_ID, CARD_NUMBER, CARD_EXPIRATION, CARDTYPE_ID, BANK_ACCOUNT_NUMBER, BANK_ROUTING_NUMBER,
		GETDATE() as ARCHIVED_DATETIME,
		ISNULL(@additional_detail,'''') as ADDITIONAL_DETAIL
	FROM CREDITCARDS
	WHERE CREDIT_CARD_ID=@creditcard_id
		AND (
			AMS_ACCOUNT_ID <> @upd_ams_account_id
			OR (@upd_customer_id > 0 and CUSTOMER_ID <> @upd_customer_id)
			OR (@upd_company_id > 0 and COMPANY_ID <> @upd_company_id)
			OR (@upd_card_number IS NOT NULL and LEN(@upd_card_number) > 0 and CARD_NUMBER <> @upd_card_number)
			OR (@upd_card_expiration IS NOT NULL and LEN(@upd_card_expiration) > 0 and CARD_EXPIRATION <> @upd_card_expiration)
			OR (@upd_card_type_id > 0 and CARDTYPE_ID <> @upd_card_type_id)
			OR (@upd_bank_account_number IS NOT NULL and LEN(@upd_bank_account_number) > 0 and BANK_ACCOUNT_NUMBER <> @upd_bank_account_number)
			OR (@upd_bank_routing_number IS NOT NULL and LEN(@upd_bank_routing_number) > 0 and BANK_ROUTING_NUMBER <> @upd_bank_routing_number)
		)

	-- Get ID of inserted record (if any) as return value
	IF (@@ERROR <>0)
		SET @ID=0
	ELSE
		SET @ID=@@IDENTITY
