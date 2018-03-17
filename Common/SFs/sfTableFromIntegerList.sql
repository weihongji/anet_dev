/* Stored Function dbo.sfTableFromIntegerList to replace IN ('..list') with either:
	... JOIN sfTableFromIntegerList(@list) L ON B.BookID = L.number
	or
	... WHERE BookID IN (SELECT number FROM dbo.sfTableFromIntegerList(@list) DerivedTable1)

	Created On: 7/18/2007 GC  Modified
*/

CREATE FUNCTION dbo.sfTableFromIntegerList (@list ntext)
RETURNS @tbl TABLE
	(
		listpos int IDENTITY(1, 1) NOT NULL,
		number  int NOT NULL
	)
AS
BEGIN
	DECLARE @pos int, @textpos  int, @chunklen smallint, @str nvarchar(4000), @tmpstr nvarchar(4000), @leftover nvarchar(4000)
	SET @textpos = 1
	SET @leftover = ''
	WHILE @textpos <= datalength(@list) / 2
	BEGIN
		SET @chunklen = 4000 - datalength(@leftover) / 2
		SET @tmpstr = ltrim(@leftover + substring(@list, @textpos, @chunklen))
		SET @textpos = @textpos + @chunklen
		SET @pos = charindex(',', @tmpstr)
		WHILE @pos > 0
		BEGIN
			SET @str = substring(@tmpstr, 1, @pos - 1)
			INSERT @tbl (number) VALUES(convert(int, @str))
			SET @tmpstr = ltrim(substring(@tmpstr, @pos + 1, len(@tmpstr)))
			SET @pos = charindex(',', @tmpstr)
		END
		SET @leftover = @tmpstr
	END
	IF ltrim(rtrim(@leftover)) <> ''
	BEGIN
		INSERT @tbl (number) VALUES(convert(int, @leftover))
	END

	RETURN
END
