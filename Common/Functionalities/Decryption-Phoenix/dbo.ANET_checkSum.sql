IF OBJECT_ID('dbo.ANET_checkSum') IS NOT NULL
    DROP FUNCTION dbo.ANET_checkSum;
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION dbo.ANET_checkSum( @input_str VARCHAR(256) ) 
RETURNS VARCHAR(256)
AS
BEGIN

DECLARE @result  VARCHAR(256),
    @i int = 0

SET @result=CHAR(0)+CHAR(0)

WHILE @i<DATALENGTH(@input_str)
	BEGIN

    SET @result = @result + SUBSTRING(@input_str,@i+1,1)

	SET @result = STUFF(@result, @i&1+1, 1, CHAR(ASCII(SUBSTRING(@result,@i&1+1,1))^ASCII(SUBSTRING(@input_str, (@i+1), 1))) )

    SET @i=@i+1
	END

RETURN  @result
END
GO