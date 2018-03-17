--==================================================================================================================
-- CRT BY:	  Jesse Wei
-- CRT DT:	  09/21/2015
--
-- Description: ANE-36026 P1 - Datafix - move a permit to a time slot but cannot because it is being blocked off by these pending permits.
--
--==================================================================================================================
Use novaparks

BEGIN TRANSACTION 

	UPDATE FACILITY_SCHEDULES SET STARTSCHEDULEDATE = '2015-09-27', ENDSCHEDULEDATE = '2015-09-27', STARTEVENTTIME = '1899-12-30 09:00', ENDSCHEDULETIME = '1899-12-30 18:59'
	WHERE FACILITY_SCHEDULE_ID IN(29678, 29680) AND STARTSCHEDULEDATE = '1899-12-30'
	
	PRINT char(10) + 'Rollback is done'

COMMIT TRANSACTION