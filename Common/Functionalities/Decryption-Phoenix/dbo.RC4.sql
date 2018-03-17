IF OBJECT_ID('dbo.RC4') IS NOT NULL
    DROP FUNCTION dbo.rc4;
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

CREATE FUNCTION dbo.RC4( @strInput VARCHAR(8000), @strPassword VARCHAR(256) ) 
RETURNS VARCHAR(8000)
AS
BEGIN
IF @strInput IS NULL RETURN NULL;
IF ISNULL(@strPassword, '') = '' RETURN @strInput;
--Returns a string encrypted with key k ( RC4 encryption )
--Original code: Eric Hodges  http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=29691&lngWId=1
--Translated to TSQL by Joseph Gama
DECLARE @i int, @j int, @n int, @t int, @s  VARCHAR(256), @k  VARCHAR(256),
 @tmp1 CHAR(1), @tmp2 CHAR(1), @result VARCHAR(1024)
SET @i=0 SET @s='' SET @k='' SET @result=''
WHILE @i<=255
	BEGIN
	SET @s=@s+CHAR(@i)
	SET @k=@k+CHAR(ASCII(SUBSTRING(@strPassword, 1+@i % LEN(@strPassword),1)))
	SET @i=@i+1
	END
SET @i=0 SET @j=0
WHILE @i<=255
	BEGIN
	SET @j=(@j+ ASCII(SUBSTRING(@s,@i+1,1))+ASCII(SUBSTRING(@k,@i+1,1)))% 256
	SET @tmp1=SUBSTRING(@s,@i+1,1)
	SET @tmp2=SUBSTRING(@s,@j+1,1)
	SET @s=STUFF(@s,@i+1,1,@tmp2)
	SET @s=STUFF(@s,@j+1,1,@tmp1)

--print str(@i)+'  '+str(@j)+'  '+str(ascii(SUBSTRING(@s,@i+1,1)))+'  '+str(ascii(SUBSTRING(@k,@i+1,1)))

	SET @i=@i+1
	END
--SET @i=1 WHILE @i<=256 BEGIN print ASCII(SUBSTRING(@s,@i,1)) SET @i=@i+1 END

SET @i=0 SET @j=0
SET @n=1
WHILE @n<=DATALENGTH(@strInput)
	BEGIN
	SET @i=(@i+1) % 256
	SET @j=(@j+ASCII(SUBSTRING(@s,@i+1,1))) % 256

	SET @tmp1=SUBSTRING(@s,@i+1,1)
	SET @tmp2=SUBSTRING(@s,@j+1,1)
	SET @s=STUFF(@s,@i+1,1,@tmp2)
	SET @s=STUFF(@s,@j+1,1,@tmp1)
	SET @t=((ASCII(SUBSTRING(@s,@i+1,1))+ASCII(SUBSTRING(@s,@j+1,1))) % 256)
--print str(ASCII(SUBSTRING(@s,@t+1,1))) + '    ' + str(ASCII(SUBSTRING(@strInput,@n,1)))
    SET @result=@result+CHAR(ASCII(SUBSTRING(@s,@t+1,1)) ^ ASCII(SUBSTRING(@strInput,@n,1)))
	SET @n=@n+1
	END
RETURN  @result
END
GO
/* UNIT TEST //
DECLARE @Tests TABLE(
    id INT IDENTITY,
    finalResult VARCHAR(8000),
    passphrase VARCHAR(256),
    initialValue VARCHAR(8000),
    encryptedValue VARCHAR(8000),
    expectedValue VARCHAR(8000)
);

INSERT INTO @Tests(passphrase, initialValue, expectedValue)
VALUES
    ('secret message', '123-45-6789', '5853E89ED679E8ECBCB518'),
    (NULL, '123-45-6789', CONVERT(VARCHAR(8000), CAST('123-45-6789' AS VARBINARY(8000)), 2)), -- pass through
    ('', '123-45-6789', CONVERT(VARCHAR(8000), CAST('123-45-6789' AS VARBINARY(8000)), 2)), -- pass through
    ('secret message', '', ''),
    ('secret message', NULL, NULL);

DECLARE
    @id INT,
    @result VARCHAR(8000),
    @passphrase VARCHAR(256),
    @value VARCHAR(8000);

DECLARE Tests CURSOR FOR SELECT id, passphrase, initialValue FROM @Tests;
OPEN Tests;
FETCH NEXT FROM Tests INTO @id, @passphrase, @value;

WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @result = dbo.RC4(@value, @passphrase);

        UPDATE @Tests
        SET encryptedValue = CONVERT(VARCHAR(8000), CAST(@result AS VARBINARY(8000)), 2), -- result as HEX
            finalResult = dbo.RC4(@result, @passphrase) -- decrypt
        WHERE id = @id;

        FETCH NEXT FROM Tests INTO @id, @passphrase, @value;
    END;

CLOSE Tests;
DEALLOCATE Tests;

SELECT 
    initialValue,
    passphrase,
    finalResult,
    encryptedValue,
    expectedValue,
    CASE
        WHEN encryptedValue = expectedValue THEN 'SUCCESS'
        WHEN encryptedValue IS NULL AND expectedValue IS NULL THEN 'SUCCESS'
        ELSE 'FAILURE'
        END  AS encryptionTestResults,
    CASE
        WHEN initialValue = finalResult THEN 'SUCCESS'
        WHEN initialValue IS NULL AND finalResult IS NULL THEN 'SUCCESS'
        ELSE 'FAILURE'
        END  AS decryptionTestResults
FROM @Tests
// UNIT TEST */
