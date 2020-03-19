USE rollbackdb
GO

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'audit_datafix') BEGIN
	DROP PROCEDURE audit_datafix
END
GO

CREATE PROCEDURE audit_datafix
	@org varchar(100),
	@subject varchar(255),
	@author varchar(50),
	@created_date smalldatetime,
	@type varchar(10),
	@description varchar(max) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @msg varchar(255)

	--Parameter validation
	IF @org IS NULL OR LEN(@org) = 0 BEGIN
		SET @msg = 'Parameter @org expectes a value.'
	END
	IF @subject IS NULL OR LEN(@subject) = 0 BEGIN
		SET @msg = 'Parameter @subject expectes a value.'
	END
	ELSE IF @author IS NULL OR LEN(@author) = 0 BEGIN
		SET @msg = 'Parameter @author expectes a value.'
	END
	ELSE IF @type IS NULL OR LEN(@type) = 0 BEGIN
		SET @msg = 'Parameter @type expectes a value.'
	END
	ELSE IF @type <> 'Datafix' AND @type <> 'Rollback' BEGIN
		SET @msg = '''' + @type + ''' is invalid to parameter @type. Available values: Datafix, Rollback'
	END

	IF LEN(@msg) > 0 BEGIN
		RAISERROR (@msg, 16, 1)
		RETURN -1
	END

	--Format values
	IF @type = 'Datafix' AND @type != ('Datafix' COLLATE Latin1_General_CS_AS) BEGIN
		SET @type = 'Datafix'
	END
	ELSE IF @type = 'Rollback' AND @type != ('Rollback' COLLATE Latin1_General_CS_AS) BEGIN
		SET @type = 'Rollback'
	END

	IF LEN(@description) = 0 SET @description = NULL

	INSERT INTO DATAFIX(Org, Subject, Author, CreatedDate, Type, Description)
	VALUES(@org, @subject, @author,@created_date, @type, @description)
	
	RETURN ISNULL(SCOPE_IDENTITY(), 0)
END
