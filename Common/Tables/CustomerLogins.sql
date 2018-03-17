select entrydate, login_created, LOGIN_USED, IS_TEMP_PASSWORD, PASSWORD1, PASSWORD_ID, * from CUSTOMERS where CUSTOMER_ID IN (69)
select * from customerlogins where CUSTOMER_ID IN (69)