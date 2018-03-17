USE order_service
GO
 
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'usp_inventory_reservation_expiration_process')
EXEC('
CREATE PROCEDURE dbo.usp_inventory_reservation_expiration_process
AS
    DECLARE @error_message NVARCHAR(2000)
    SET @error_message = ''Stored procedure ''+OBJECT_NAME(@@PROCID)+'' not yet implemented''
    RAISERROR(@error_message, 16, 1)
')
GO
ALTER PROCEDURE dbo.usp_inventory_reservation_expiration_process

	@reservations_per_execution INT,
	@reservations_per_batch INT,
	@batch_delay NCHAR(8) = '00:00:00',
	@batch_max_retries TINYINT = 0,
	@retry_seconds INT = 900,
	@fail_on_error BIT = 0,
	@thread_count INT = 1,
	@thread_id INT = 0

AS

-- ********************************************************************
-- Procedure Name:  dbo.usp_inventory_reservation_expiration_process
--
-- Purpose:			Deletes records from inventory process and updates the statuses
--
-- Called by:		
-- Calls:			
-- Author:			Brandon M. Greenwood (Brandon.Greenwood@ACTIVEnetwork.com)
-- Date Created:	4/2/2013	
-- ********************************************************************
-- ********************************************************************
-- ****************************  TEST  ********************************
/*

*/
-- *************  TEST  ***********************************************
-- ********************************************************************
SET NOCOUNT ON

DECLARE @retry_cutoff DATETIME, @get_date DATETIME,
    @error_message NVARCHAR(2048),
    @error_severity INT,
    @error_state INT,
    @current_retries TINYINT

SELECT @get_date = GETUTCDATE()

SET @retry_cutoff = DATEADD(SECOND, -@retry_seconds, @get_date)

CREATE TABLE #reservations_to_delete
(
	id INT IDENTITY(1,1) NOT NULL,
	inventory_reservation_expiration_queue_id BIGINT NOT NULL
)

SET ROWCOUNT @reservations_per_execution

UPDATE q
SET status_id = 1, modified_dt = @get_date
OUTPUT inserted.id INTO #reservations_to_delete(inventory_reservation_expiration_queue_id)
FROM dbo.inventory_reservation_expiration_queue q
WHERE id % @thread_count = @thread_id AND (status_id = 0 OR (status_id = 1 AND modified_dt <= @retry_cutoff))

DECLARE @cID INT, @mID INT, @eID INT

SELECT @cID = ISNULL(MIN(ID), 1), @mID = ISNULL(MAX(ID), 0) FROM #reservations_to_delete
SET @eID = @cID + @reservations_per_batch

WHILE(@cID <= @mID)
BEGIN

	SET @current_retries = 0

	DELETE_RESERVATION:
	BEGIN TRY
		BEGIN TRANSACTION

			SELECT @get_date = GETUTCDATE()

			-- Inventory reservation no longer exists, nothing to do
			UPDATE q
			SET status_id = 4, q.modified_dt = @get_date
			FROM #reservations_to_delete r
			JOIN dbo.inventory_reservation_expiration_queue q on r.inventory_reservation_expiration_queue_id = q.id
			LEFT JOIN dbo.inventory_reservations ir WITH(NOLOCK) ON q.inventory_reservation_id = ir.id
			WHERE r.id BETWEEN @cID AND @eID AND ir.id IS NULL

			-- inventory reservation has been modified since flag
			UPDATE q
			SET q.status_id = 3, q.modified_dt = @get_date
			FROM #reservations_to_delete r
			JOIN dbo.inventory_reservation_expiration_queue q on r.inventory_reservation_expiration_queue_id = q.id
			JOIN dbo.inventory_reservations ir WITH(NOLOCK) ON q.inventory_reservation_id = ir.id AND q.reservation_modified_dt < ir.modified_dt
			WHERE r.id BETWEEN @cID AND @eID
			AND q.status_id = 1 -- queue record is still in process

			-- inventory reservation needs to be deleted
			UPDATE q
			SET q.status_id = 7, q.modified_dt = @get_date
			FROM #reservations_to_delete r
			JOIN dbo.inventory_reservation_expiration_queue q on r.inventory_reservation_expiration_queue_id = q.id
			JOIN dbo.inventory_reservations ir WITH(NOLOCK) ON q.inventory_reservation_id = ir.id AND ir.inventory_id IS NOT NULL
			WHERE r.id BETWEEN @cID AND @eID
			AND q.status_id = 1 -- queue record is still in process

			DELETE FROM ir
			OUTPUT deleted.inventory_id, deleted.quantity, 0, @get_date INTO dbo.inventory_quantity_reallocation_queue (inventory_id, quantity, status_id, created_dt)
			FROM #reservations_to_delete r
			JOIN dbo.inventory_reservation_expiration_queue q on r.inventory_reservation_expiration_queue_id = q.id
			JOIN dbo.inventory_reservations ir ON q.inventory_reservation_id = ir.id AND ir.inventory_id IS NOT NULL
			WHERE r.id BETWEEN @cID AND @eID
			AND q.status_id = 7 -- queue record to be deleted

			-- inventory reservation has unlimited quantity, no quantity update necessary
			UPDATE q
			SET q.status_id = 8, q.modified_dt = @get_date
			FROM #reservations_to_delete r
			JOIN dbo.inventory_reservation_expiration_queue q on r.inventory_reservation_expiration_queue_id = q.id
			JOIN dbo.inventory_reservations ir WITH(NOLOCK) ON q.inventory_reservation_id = ir.id
			WHERE r.id BETWEEN @cID AND @eID
			AND q.status_id = 1 -- queue record is still in process

			DELETE FROM ir
			FROM #reservations_to_delete r
			JOIN dbo.inventory_reservation_expiration_queue q on r.inventory_reservation_expiration_queue_id = q.id
			JOIN dbo.inventory_reservations ir ON q.inventory_reservation_id = ir.id
			WHERE r.id BETWEEN @cID AND @eID
			AND q.status_id = 8 -- queue record to be ignored

			-- error processing
			UPDATE q
			SET status_id = 2, modified_dt = @get_date
			FROM #reservations_to_delete r
			JOIN dbo.inventory_reservation_expiration_queue q on r.inventory_reservation_expiration_queue_id = q.id
			WHERE r.id BETWEEN @cID AND @eID
			AND q.status_id = 1 -- queue record is still in process

		COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
        SELECT
	        @error_message = ERROR_MESSAGE(),
            @error_severity = ERROR_SEVERITY(),
            @error_state = ERROR_STATE();

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

		IF(@batch_delay IS NOT NULL)
		BEGIN
			WAITFOR DELAY @batch_delay
		END
        SET @current_retries = @current_retries + 1;

        -- exit when error @retry_attempts is met
        IF @current_retries < @batch_max_retries 
            GOTO DELETE_RESERVATION;
        ELSE
            BEGIN

				UPDATE q
				SET q.status_id = 9, q.modified_dt = @get_date
				FROM #reservations_to_delete r
				JOIN dbo.inventory_reservation_expiration_queue q on r.inventory_reservation_expiration_queue_id = q.id
				WHERE r.id BETWEEN @cID AND @eID

				IF(@fail_on_error = 1)
				BEGIN
					RAISERROR(@error_message, @error_severity, @error_state)
					SET NOCOUNT OFF
					RETURN 1;
				END
            END
    END CATCH

	SET @cID = @eID + 1
	SET @eID = @cID + @reservations_per_batch

	IF(@batch_delay IS NOT NULL)
	BEGIN
		WAITFOR DELAY @batch_delay
	END

END


SET NOCOUNT OFF
RETURN 0
    
GO
