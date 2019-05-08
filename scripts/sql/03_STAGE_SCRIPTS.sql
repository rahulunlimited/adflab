DROP PROCEDURE IF EXISTS [dbo].[spLoad_StateProvince_Ext]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_StateProvince]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_Country]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StateProvince]') AND type in (N'U'))
ALTER TABLE [dbo].[StateProvince] DROP CONSTRAINT IF EXISTS [DF__StateProv__Valid__47A6A41B]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
ALTER TABLE [dbo].[Country] DROP CONSTRAINT IF EXISTS [DF__Country__Valid__43D61337]
GO
DROP TABLE IF EXISTS [STG].[Sales_Invoices]
GO
DROP TABLE IF EXISTS [STG].[Production_WorkOrder]
GO
DROP TABLE IF EXISTS [STG].[HumanResources_Department]
GO
DROP TABLE IF EXISTS [STG].[CSV_AusState]
GO
DROP TABLE IF EXISTS [STG].[Application_StateProvinces]
GO
DROP TABLE IF EXISTS [STG].[Application_PaymentMethods]
GO
DROP TABLE IF EXISTS [STG].[Application_DeliveryMethods]
GO
DROP TABLE IF EXISTS [STG].[Application_Countries]
GO
DROP TABLE IF EXISTS [STG].[Application_Cities_NY]
GO
DROP TABLE IF EXISTS [STG].[Application_Cities]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StateProvince]') AND type in (N'U'))
ALTER TABLE [dbo].[StateProvince] SET ( SYSTEM_VERSIONING = OFF  )
GO
DROP TABLE IF EXISTS [dbo].[StateProvince]
GO
DROP TABLE IF EXISTS [dbo].[StateProvinceHistory]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
ALTER TABLE [dbo].[Country] SET ( SYSTEM_VERSIONING = OFF  )
GO
DROP TABLE IF EXISTS [dbo].[Country]
GO
DROP TABLE IF EXISTS [dbo].[CountryHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CountryHistory](
	[CountryID] [int] NOT NULL,
	[CountryCode] [nvarchar](3) NOT NULL,
	[IsoNumericCode] [int] NOT NULL,
	[CountryName] [nvarchar](60) NOT NULL,
	[FormalName] [nvarchar](60) NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[Continent] [nvarchar](60) NOT NULL,
	[SourceSystem] [nvarchar](60) NOT NULL,
	[Valid] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [nvarchar](3) NOT NULL,
	[IsoNumericCode] [int] NOT NULL,
	[CountryName] [nvarchar](60) NOT NULL,
	[FormalName] [nvarchar](60) NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[Continent] [nvarchar](60) NOT NULL,
	[SourceSystem] [nvarchar](60) NOT NULL,
	[Valid] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CountryCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[CountryHistory] )
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateProvinceHistory](
	[StateProvinceCode] [nvarchar](5) NOT NULL,
	[StateProvinceName] [nvarchar](50) NOT NULL,
	[CountryID] [int] NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[SourceSystem] [nvarchar](60) NOT NULL,
	[Valid] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateProvince](
	[StateProvinceCode] [nvarchar](5) NOT NULL,
	[StateProvinceName] [nvarchar](50) NOT NULL,
	[CountryID] [int] NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[SourceSystem] [nvarchar](60) NOT NULL,
	[Valid] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StateProvinceCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[StateProvinceHistory] )
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Application_Cities](
	[CityID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[Location] [geography] NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NULL,
	[ValidTo] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Application_Cities_NY](
	[CityID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[Location] [geography] NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NULL,
	[ValidTo] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Application_Countries](
	[CountryID] [int] NOT NULL,
	[CountryName] [nvarchar](60) NOT NULL,
	[FormalName] [nvarchar](60) NOT NULL,
	[IsoAlpha3Code] [nvarchar](3) NULL,
	[IsoNumericCode] [int] NULL,
	[CountryType] [nvarchar](20) NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[Continent] [nvarchar](30) NOT NULL,
	[Region] [nvarchar](30) NOT NULL,
	[Subregion] [nvarchar](30) NOT NULL,
	[Border] [geography] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NULL,
	[ValidTo] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Application_DeliveryMethods](
	[DeliveryMethodID] [int] NOT NULL,
	[DeliveryMethodName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NULL,
	[ValidTo] [datetime2](7) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Application_PaymentMethods](
	[PaymentMethodID] [int] NOT NULL,
	[PaymentMethodName] [nvarchar](50) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NULL,
	[ValidTo] [datetime2](7) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Application_StateProvinces](
	[StateProvinceID] [int] NOT NULL,
	[StateProvinceCode] [nvarchar](5) NOT NULL,
	[StateProvinceName] [nvarchar](50) NOT NULL,
	[CountryID] [int] NOT NULL,
	[SalesTerritory] [nvarchar](50) NOT NULL,
	[Border] [geography] NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NULL,
	[ValidTo] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[CSV_AusState](
	[StateCode] [nvarchar](10) NULL,
	[StateName] [nvarchar](100) NULL,
	[Country] [nvarchar](100) NULL,
	[LastPopulation] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[HumanResources_Department](
	[DepartmentID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Production_WorkOrder](
	[WorkOrderID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[OrderQty] [int] NOT NULL,
	[StockedQty] [int] NULL,
	[ScrappedQty] [smallint] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[DueDate] [datetime] NOT NULL,
	[ScrapReasonID] [smallint] NULL,
	[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Sales_Invoices](
	[InvoiceID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[BillToCustomerID] [int] NOT NULL,
	[OrderID] [int] NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[ContactPersonID] [int] NOT NULL,
	[AccountsPersonID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PackedByPersonID] [int] NOT NULL,
	[InvoiceDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsCreditNote] [bit] NOT NULL,
	[CreditNoteReason] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[DeliveryInstructions] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
	[TotalDryItems] [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
	[DeliveryRun] [nvarchar](5) NULL,
	[RunPosition] [nvarchar](5) NULL,
	[ReturnedDeliveryData] [nvarchar](max) NULL,
	[ConfirmedDeliveryTime] [datetime2](7) NULL,
	[ConfirmedReceivedBy] [nvarchar](4000) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Country] ADD  DEFAULT ((1)) FOR [Valid]
GO
ALTER TABLE [dbo].[StateProvince] ADD  DEFAULT ((1)) FOR [Valid]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_Country]
AS


MERGE dbo.Country AS T
USING [STG].[Application_Countries] S 
ON (S.[IsoAlpha3Code] = T.[CountryCode])

WHEN NOT MATCHED BY TARGET 
THEN INSERT ([CountryCode], [IsoNumericCode], [CountryName], [FormalName], [LatestRecordedPopulation], [Continent], SourceSystem)
	VALUES ([IsoAlpha3Code], [IsoNumericCode], [CountryName], [FormalName], [LatestRecordedPopulation], [Continent], 'Azure')
WHEN MATCHED
	AND T.[IsoNumericCode] <> S.[IsoNumericCode]
		OR T.[CountryName] <> S.[CountryName]
		OR T.[FormalName] <> S.[FormalName]
		OR T.[LatestRecordedPopulation] <> S.[LatestRecordedPopulation]
		OR T.[Continent] <> S.[Continent]
		OR T.SourceSystem <> 'Azure'
	THEN UPDATE 
	SET	T.[IsoNumericCode] = S.[IsoNumericCode]
		,T.[CountryName] = S.[CountryName]
		,T.[FormalName] = S.[FormalName]
		,T.[LatestRecordedPopulation] = S.[LatestRecordedPopulation]
		,T.[Continent] = S.[Continent]
		,T.SourceSystem = 'Azure'
WHEN NOT MATCHED BY SOURCE
	THEN UPDATE
	SET T.Valid = 0
 ;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_StateProvince]
AS


MERGE dbo.StateProvince AS T
USING [STG].[Application_StateProvinces] S 
ON (S.StateProvinceCode = T.StateProvinceCode)

WHEN NOT MATCHED BY TARGET 
THEN INSERT (StateProvinceCode, [StateProvinceName], [CountryId], [LatestRecordedPopulation], SourceSystem)
	VALUES (StateProvinceCode, [StateProvinceName], [CountryId], [LatestRecordedPopulation], 'Azure')
WHEN MATCHED
	AND T.[StateProvinceName] <> S.[StateProvinceName]
		OR T.[CountryId] <> S.[CountryId]
		OR T.[LatestRecordedPopulation] <> S.[LatestRecordedPopulation]
		OR T.SourceSystem <> 'Azure'
	THEN UPDATE 
	SET	T.[StateProvinceName] = S.[StateProvinceName]
		,T.[CountryId] = S.[CountryId]
		,T.[LatestRecordedPopulation] = S.[LatestRecordedPopulation]
		,T.SourceSystem = 'Azure'
WHEN NOT MATCHED BY SOURCE
	THEN UPDATE
	SET T.Valid = 0
 ;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_StateProvince_Ext]
AS


MERGE dbo.StateProvince AS T
USING (SELECT S.*, C.CountryID FROM [STG].[CSV_AusState] S LEFT JOIN dbo.Country C ON S.Country = C.CountryName) S
ON (S.StateCode = T.StateProvinceCode)

WHEN NOT MATCHED BY TARGET 
THEN INSERT (StateProvinceCode, [StateProvinceName], [CountryId], [LatestRecordedPopulation], SourceSystem)
	VALUES (StateCode, [StateName], CountryId, [LastPopulation], 'External')
WHEN MATCHED
	AND T.[StateProvinceName] <> S.StateCode
		OR T.[CountryId] <> S.[CountryId]
		OR T.[LatestRecordedPopulation] <> S.[LastPopulation]
		OR T.SourceSystem <> 'External'
	THEN UPDATE 
	SET	T.[StateProvinceName] = S.StateCode
		,T.[CountryId] = S.[CountryId]
		,T.[LatestRecordedPopulation] = S.[LastPopulation]
		,T.SourceSystem = 'External'
WHEN NOT MATCHED BY SOURCE
	THEN UPDATE
	SET T.Valid = 0
 ;
GO
