SELECT * FROM CARDTYPES

select * from systeminfo where keyword in ('auto_update_scheduled_CC_payment', 'credit_card_check_valid_days_after_submit', 'check_credit_card_expiry_lead_time')

select * from creditcards where credit_card_id = 23221
select * from CREDITCARDS_ARCHIVE where credit_card_id = 23221

select last_modify, * from icverifylog where ams_account_id = '14571124203002343989IHOLBXSIABHTNAKGQNKXKPHNJJZPQRPP'
select * from CREDITCARDS_ARCHIVE where ams_account_id = '14571124203002343989IHOLBXSIABHTNAKGQNKXKPHNJJZPQRPP'

select * from CREDITCARD_UPDATES WHERE ams_account_id = '14571124203002343989IHOLBXSIABHTNAKGQNKXKPHNJJZPQRPP'
select * from AMSAccountLog where ams_account_id = '14571124203002343989IHOLBXSIABHTNAKGQNKXKPHNJJZPQRPP'