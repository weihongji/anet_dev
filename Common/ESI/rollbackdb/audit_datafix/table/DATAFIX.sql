USE rollbackdb
GO

IF NOT EXISTS(SELECT * FROM sys.tables WHERE object_id = OBJECT_ID('DATAFIX')) BEGIN
	CREATE TABLE dbo.DATAFIX(
		Id int identity(1,1) NOT NULL,
		Org varchar(100) NOT NULL,
		[Subject] varchar(255) NOT NULL,
		Author varchar(50) NOT NULL,
		CreatedDate smalldatetime NULL,
		[Type] varchar(10) NOT NULL,
		Description varchar(max),
		SystemUser varchar(50) NOT NULL CONSTRAINT DF_DATAFIX_SystemUser DEFAULT SYSTEM_USER,
		DateStamp datetime NOT NULL CONSTRAINT DF_DATAFIX_DateStamp DEFAULT GETDATE(),
		CONSTRAINT PK_DATAFIX PRIMARY KEY CLUSTERED
		(
			Id ASC
		)
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX IX_DATAFIX_Org ON dbo.DATAFIX(Org ASC) ON [PRIMARY]
	CREATE NONCLUSTERED INDEX IX_DATAFIX_Subject ON dbo.DATAFIX([Subject] ASC) ON [PRIMARY]

	PRINT 'Created table DATAFIX.'
END
ELSE BEGIN
	PRINT 'Table DATAFIX already exists.'
END