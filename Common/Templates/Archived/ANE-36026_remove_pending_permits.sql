--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  09/21/2015
--
-- Description: ANE-36026 P1 - Datafix - move a permit to a time slot but cannot because it is being blocked off by these pending permits.
--
--==================================================================================================================
Use novaparks

/*
--Verify if datafix is applied
IF EXISTS(SELECT * FROM FACILITY_SCHEDULES WHERE FACILITY_SCHEDULE_ID = 29678 AND STARTSCHEDULEDATE = '2015-09-27') BEGIN
	PRINT 'Datafix NOT applied'
END
ELSE IF EXISTS(SELECT * FROM FACILITY_SCHEDULES WHERE FACILITY_SCHEDULE_ID = 29678 AND STARTSCHEDULEDATE = '1899-12-30') BEGIN
	PRINT 'Datafix already applied'
END
ELSE BEGIN
	PRINT 'Data validation failed. Appliying on a wrong db or the original data has been changed. Stop running this datafix or the rollback.'
END
*/

SET XACT_ABORT ON

BEGIN TRANSACTION 

	UPDATE FACILITY_SCHEDULES SET STARTSCHEDULEDATE = '1899-12-30', ENDSCHEDULEDATE = '1899-12-30', STARTEVENTTIME = '1899-12-30 0:00', ENDSCHEDULETIME = '1899-12-30 0:00'
	WHERE FACILITY_SCHEDULE_ID IN(29678, 29680) AND STARTSCHEDULEDATE = '2015-09-27'
	
	PRINT char(10) + 'Datafix is done'

COMMIT TRANSACTION
