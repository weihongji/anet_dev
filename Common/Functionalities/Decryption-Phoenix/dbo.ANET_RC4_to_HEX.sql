IF OBJECT_ID('dbo.ANET_RC4_to_HEX') IS NOT NULL
    DROP FUNCTION dbo.ANET_RC4_to_HEX;
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION dbo.ANET_RC4_to_HEX( @input_str VARCHAR(256) ) 
RETURNS VARCHAR(256)
AS
BEGIN

DECLARE @convert_result_to_hex  VARCHAR(256) = '',
    @j int = 0,
    @m int = 0

SET @convert_result_to_hex = ''

WHILE @j<DATALENGTH(@input_str)
	BEGIN

    SELECT @m = ASCII(SUBSTRING(@input_str, 1+@j % DATALENGTH(@input_str),1))

    -- CONVERT TO VARBINARY(8) will add '0' automatically. No need to do it again here.
    -- IF @m < 16
    --     SET @convert_result_to_hex = @convert_result_to_hex + '0'

    SET @convert_result_to_hex = @convert_result_to_hex + SUBSTRING(CONVERT(VARCHAR(8), CONVERT(VARBINARY(8), @m), 2), 7, 2)
	
    SET @j=@j+1
	END

RETURN  @convert_result_to_hex
END
GO