IF OBJECT_ID('dbo.ANET_RC4_DECRYT') IS NOT NULL
    DROP FUNCTION dbo.ANET_RC4_DECRYT;
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION dbo.ANET_RC4_DECRYT( @hex_to_decrypt VARCHAR(256), @orig_key VARCHAR(256) ) 
RETURNS VARCHAR(256)
AS
BEGIN

DECLARE @i INT,
    @m CHAR(2),
    @str_to_decrypt VARCHAR(256) = '',
    @decrypted_result VARCHAR(256) = '',
    @orginal_str VARCHAR(256),
    @checkSum_orig_str VARCHAR(256),
    @result VARCHAR(256) = ''

IF ISNULL(@orig_key, '') = '' RETURN @result
IF ISNULL(@hex_to_decrypt, '') = '' RETURN @result
IF DATALENGTH(@hex_to_decrypt)%2 <> 0 RETURN @result
IF LEN(@hex_to_decrypt) < 4 RETURN @result

SET @i = 0
WHILE @i < DATALENGTH(@hex_to_decrypt)/2
BEGIN
    SET @m = SUBSTRING(@hex_to_decrypt, @i*2 + 1, 2)

    SET @str_to_decrypt = @str_to_decrypt + CHAR(CONVERT(INT, TRY_CONVERT(VARBINARY(8), @m, 2)))

    SET @i = @i + 1
END

SELECT @decrypted_result = dbo.rc4(@str_to_decrypt, dbo.rc4(@orig_key, 'Hidden Key'))

SELECT @orginal_str = SUBSTRING(@decrypted_result, 3, DATALENGTH(@decrypted_result) - 2)

SELECT @checkSum_orig_str = DBO.ANET_checkSum(@orginal_str)

IF( ASCII(SUBSTRING(@checkSum_orig_str, 1, 1)) = ASCII(SUBSTRING(@decrypted_result, 1, 1)) )
    AND ( ASCII(SUBSTRING(@checkSum_orig_str, 2, 1)) = ASCII(SUBSTRING(@decrypted_result, 2, 1)) )
    SET @result = @orginal_str

RETURN @result
END
GO
