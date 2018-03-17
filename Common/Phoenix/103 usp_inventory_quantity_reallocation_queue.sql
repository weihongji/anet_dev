USE order_service
GO
 
IF NOT EXISTS(SELECT * FROM sys.procedures WHERE name = 'usp_inventory_quantity_reallocation_queue')
EXEC('
CREATE PROCEDURE dbo.usp_inventory_quantity_reallocation_queue
AS
    DECLARE @error_message NVARCHAR(2000)
    SET @error_message = ''Stored procedure ''+OBJECT_NAME(@@PROCID)+'' not yet implemented''
    RAISERROR(@error_message, 16, 1)
')
GO
ALTER PROCEDURE dbo.usp_inventory_quantity_reallocation_queue

	@inventories_per_execution INT,
	@inventories_per_batch INT,
	@batch_delay NCHAR(8) = '00:00:00',
	@batch_max_retries TINYINT = 0,
	@retry_seconds INT = 900,
	@fail_on_error BIT = 0,
	@thread_count INT = 1,
	@thread_id INT = 0

AS

-- ********************************************************************
-- Procedure Name:  dbo.usp_inventory_quantity_reallocation_queue
--
-- Purpose:			Adds the given quantity back to the available inventory
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


CREATE TABLE #inventories_to_reallocate
(
	id INT IDENTITY(1,1) NOT NULL,
	inventory_quantity_reallocation_queue_id BIGINT NOT NULL
)

SET ROWCOUNT @inventories_per_execution

UPDATE q
SET status_id = 1, modified_dt = @get_date
OUTPUT inserted.id INTO #inventories_to_reallocate (inventory_quantity_reallocation_queue_id)
FROM dbo.inventory_quantity_reallocation_queue q
WHERE id % @thread_count = @thread_id AND (status_id = 0 OR (status_id = 1 AND modified_dt <= @retry_cutoff))

DECLARE @cID INT, @mID INT, @eID INT

SELECT @cID = ISNULL(MIN(ID), 1), @mID = ISNULL(MAX(ID), 0) FROM #inventories_to_reallocate
SET @eID = @cID + @inventories_per_batch

WHILE(@cID <= @mID)
BEGIN

	SET @current_retries = 0

	UPDATE_INVENTORY:
	BEGIN TRY
		BEGIN TRANSACTION

			SELECT @get_date = GETUTCDATE()

			UPDATE i
			SET available_quantity = available_quantity + n.quantity
			FROM 
			(
				SELECT q.inventory_id, SUM(quantity) as quantity FROM #inventories_to_reallocate itd
				JOIN dbo.inventory_quantity_reallocation_queue q WITH(NOLOCK) ON itd.inventory_quantity_reallocation_queue_id = q.id
				WHERE itd.id BETWEEN @cID AND @eID
				GROUP BY q.inventory_id
			) as n
			JOIN dbo.inventory i on n.inventory_id = i.id

			UPDATE q
			SET status_id = 2, modified_dt = @get_date
			FROM #inventories_to_reallocate itd
			JOIN dbo.inventory_quantity_reallocation_queue q ON itd.inventory_quantity_reallocation_queue_id = q.id
			WHERE itd.id BETWEEN @cID AND @eID
			
			
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
            GOTO UPDATE_INVENTORY;
        ELSE
            BEGIN

				UPDATE q
				SET status_id = 9, modified_dt = @get_date
				FROM #inventories_to_reallocate itd
				JOIN dbo.inventory_quantity_reallocation_queue q ON itd.inventory_quantity_reallocation_queue_id = q.id
				WHERE itd.id BETWEEN @cID AND @eID

				IF(@fail_on_error = 1)
				BEGIN
					RAISERROR(@error_message, @error_severity, @error_state)
					SET NOCOUNT OFF
					RETURN 1;
				END
            END
    END CATCH

	SET @cID = @eID + 1
	SET @eID = @cID + @inventories_per_batch

	WAITFOR DELAY @batch_delay

END


SET NOCOUNT OFF
RETURN 0
    

GO


