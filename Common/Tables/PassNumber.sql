select * from AUTONUMBER where TABLENAME like 'pass_autonumber_key%'


select PASSLAYOUT_ID, PASSASSIGNTYPE, * from PACKAGES where PACKAGE_ID = 21

declare @customer_id int = 1240
declare @package_id int = 21

select * from DBO.PASSES
where customer_id=@customer_id
	and passlayout_id=(select PASSLAYOUT_ID from PACKAGES where PACKAGE_ID = @package_id)
	and passnumber<>''

--passlength - len(pass_prefix)
select * from SYSTEMINFO where KEYWORD like '%pass_prefix%'
select passlength, * from system

--format
--prefix + 000... + next_number

pass_autonumber_key

declare @next money
exec NEXT_AUTONUM 'PASSNUMBERS', 1, 1, @next output
select @next

/*
insert into passes (customer_id, lastprinted, lastpicturetaken, passnumber, passlayout_id, temporarypassnumber)
values()
*/