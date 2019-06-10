DROP PROCEDURE IF EXISTS [dbo].[spLoad_StateProvince_Ext]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_StateProvince]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_People]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_Customer]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_Country]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_City]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StateProvince]') AND type in (N'U'))
ALTER TABLE [dbo].[StateProvince] DROP CONSTRAINT IF EXISTS [dboStateProvince_DF_Valid]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT IF EXISTS [dboCustomer_DF_Valid]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
ALTER TABLE [dbo].[Country] DROP CONSTRAINT IF EXISTS [dboCountry_DF_Valid]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[City]') AND type in (N'U'))
ALTER TABLE [dbo].[City] DROP CONSTRAINT IF EXISTS [dboCity_DF_Valid]
GO
DROP TABLE IF EXISTS [STG].[Sales_Invoices]
GO
DROP TABLE IF EXISTS [STG].[Sales_Customers]
GO
DROP TABLE IF EXISTS [STG].[Production_WorkOrder]
GO
DROP TABLE IF EXISTS [STG].[HumanResources_Department]
GO
DROP TABLE IF EXISTS [STG].[CSV_AusState]
GO
DROP TABLE IF EXISTS [STG].[Application_StateProvinces]
GO
DROP TABLE IF EXISTS [STG].[Application_People]
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
DROP VIEW IF EXISTS [dbo].[vPeople]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[People]') AND type in (N'U'))
ALTER TABLE [dbo].[People] SET ( SYSTEM_VERSIONING = OFF  )
GO
DROP TABLE IF EXISTS [dbo].[People]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
ALTER TABLE [dbo].[Customer] SET ( SYSTEM_VERSIONING = OFF  )
GO
DROP TABLE IF EXISTS [dbo].[Customer]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[City]') AND type in (N'U'))
ALTER TABLE [dbo].[City] SET ( SYSTEM_VERSIONING = OFF  )
GO
DROP TABLE IF EXISTS [dbo].[City]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StateProvince]') AND type in (N'U'))
ALTER TABLE [dbo].[StateProvince] SET ( SYSTEM_VERSIONING = OFF  )
GO
DROP TABLE IF EXISTS [dbo].[StateProvince]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
ALTER TABLE [dbo].[Country] SET ( SYSTEM_VERSIONING = OFF  )
GO
DROP TABLE IF EXISTS [dbo].[Country]
GO
DROP SCHEMA IF EXISTS [STG]
GO
CREATE SCHEMA [STG]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryKey] [int] IDENTITY(1,1) NOT NULL,
	[CountrySourceID] [int] NOT NULL,
	[CountryCode] [nvarchar](3) NOT NULL,
	[CountryName] [nvarchar](60) NOT NULL,
	[FormalName] [nvarchar](60) NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[Continent] [nvarchar](60) NOT NULL,
	[SourceSystem] [nvarchar](60) NOT NULL,
	[Valid] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK_dbo_Country] PRIMARY KEY CLUSTERED 
(
	[CountryKey] ASC
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
CREATE TABLE [dbo].[StateProvince](
	[StateProvinceKey] [int] IDENTITY(1,1) NOT NULL,
	[StateProvinceSourceID] [int] NOT NULL,
	[StateProvinceCode] [nvarchar](5) NOT NULL,
	[StateProvinceName] [nvarchar](50) NOT NULL,
	[CountryKey] [int] NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[SourceSystem] [nvarchar](60) NOT NULL,
	[Valid] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StateProvinceKey] ASC
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
CREATE TABLE [dbo].[City](
	[CityKey] [int] IDENTITY(1,1) NOT NULL,
	[CitySourceID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceKey] [int] NOT NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[SourceSystem] [nvarchar](60) NOT NULL,
	[Valid] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[CityHistory] )
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerSourceID] [int] NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[PostalCityKey] [int] NOT NULL,
	[CreditLimit] [decimal](18, 2) NULL,
	[AccountOpenedDate] [date] NOT NULL,
	[StandardDiscountPercentage] [decimal](18, 3) NOT NULL,
	[PaymentDays] [int] NOT NULL,
	[PhoneNumber] [nvarchar](20) NOT NULL,
	[FaxNumber] [nvarchar](20) NOT NULL,
	[DeliveryRun] [nvarchar](5) NULL,
	[RunPosition] [nvarchar](5) NULL,
	[WebsiteURL] [nvarchar](256) NOT NULL,
	[DeliveryAddressLine1] [nvarchar](60) NOT NULL,
	[DeliveryAddressLine2] [nvarchar](60) NULL,
	[DeliveryPostalCode] [nvarchar](10) NOT NULL,
	[PostalAddressLine1] [nvarchar](60) NOT NULL,
	[PostalAddressLine2] [nvarchar](60) NULL,
	[PostalPostalCode] [nvarchar](10) NOT NULL,
	[Valid] [bit] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK_dbo_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[CustomerHistory] )
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[People](
	[PersonKey] [int] IDENTITY(1,1) NOT NULL,
	[PersonSourceID] [int] MASKED WITH (FUNCTION = 'random(1, 100)') NOT NULL,
	[FullName] [nvarchar](50) NOT NULL,
	[PreferredName] [nvarchar](50) NOT NULL,
	[SearchName]  AS (concat([PreferredName],N' ',[FullName])) PERSISTED NOT NULL,
	[IsPermittedToLogon] [bit] NOT NULL,
	[LogonName] [nvarchar](50) MASKED WITH (FUNCTION = 'partial(2, "######", 1)') NULL,
	[IsExternalLogonProvider] [bit] NOT NULL,
	[HashedPassword] [varbinary](max) NULL,
	[IsSystemUser] [bit] NOT NULL,
	[IsEmployee] [bit] NOT NULL,
	[IsSalesperson] [bit] NOT NULL,
	[UserPreferences] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](20) MASKED WITH (FUNCTION = 'default()') NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[EmailAddress] [nvarchar](256) MASKED WITH (FUNCTION = 'email()') NULL,
	[Photo] [varbinary](max) NULL,
	[CustomFields] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[PeopleHistory] )
)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPeople]
AS
SELECT [PersonKey]
      ,[PersonSourceID]
      ,[FullName]
      ,[PreferredName]
      ,[SearchName]
      ,[IsPermittedToLogon]
      ,[LogonName]
      ,[IsExternalLogonProvider]
      ,[HashedPassword]
      ,[IsSystemUser]
      ,[IsEmployee]
      ,[IsSalesperson]
      ,[UserPreferences]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[EmailAddress]
      ,[Photo]
      ,[CustomFields]
	  ,JSON_VALUE(UserPreferences, '$.theme') AS UserTheme
	  ,JSON_QUERY(CustomFields, '$.OtherLanguages') AS OtherLanguages
	  ,JSON_VALUE(CustomFields, '$.OtherLanguages[0]') AS PreferredOtherLanguage
	  ,TRY_CONVERT(DATETIME, JSON_VALUE(CustomFields, '$.HireDate')) AS HireDate
      ,[ValidFrom]
      ,[ValidTo]
  FROM [dbo].[People]
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
CREATE TABLE [STG].[Application_People](
	[PersonID] [int] NOT NULL,
	[FullName] [nvarchar](50) NOT NULL,
	[PreferredName] [nvarchar](50) NOT NULL,
	[SearchName] [nvarchar](101) NULL,
	[IsPermittedToLogon] [bit] NOT NULL,
	[LogonName] [nvarchar](50) NULL,
	[IsExternalLogonProvider] [bit] NOT NULL,
	[HashedPassword] [varbinary](max) NULL,
	[IsSystemUser] [bit] NOT NULL,
	[IsEmployee] [bit] NOT NULL,
	[IsSalesperson] [bit] NOT NULL,
	[UserPreferences] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[EmailAddress] [nvarchar](256) NULL,
	[Photo] [varbinary](max) NULL,
	[CustomFields] [nvarchar](max) NULL,
	[OtherLanguages] [nvarchar](max) NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NULL,
	[ValidTo] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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
CREATE TABLE [STG].[Sales_Customers](
	[CustomerID] [int] NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[BillToCustomerID] [int] NOT NULL,
	[CustomerCategoryID] [int] NOT NULL,
	[BuyingGroupID] [int] NULL,
	[PrimaryContactPersonID] [int] NOT NULL,
	[AlternateContactPersonID] [int] NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[DeliveryCityID] [int] NOT NULL,
	[PostalCityID] [int] NOT NULL,
	[CreditLimit] [decimal](18, 2) NULL,
	[AccountOpenedDate] [date] NOT NULL,
	[StandardDiscountPercentage] [decimal](18, 3) NOT NULL,
	[IsStatementSent] [bit] NOT NULL,
	[IsOnCreditHold] [bit] NOT NULL,
	[PaymentDays] [int] NOT NULL,
	[PhoneNumber] [nvarchar](20) NOT NULL,
	[FaxNumber] [nvarchar](20) NOT NULL,
	[DeliveryRun] [nvarchar](5) NULL,
	[RunPosition] [nvarchar](5) NULL,
	[WebsiteURL] [nvarchar](256) NOT NULL,
	[DeliveryAddressLine1] [nvarchar](60) NOT NULL,
	[DeliveryAddressLine2] [nvarchar](60) NULL,
	[DeliveryPostalCode] [nvarchar](10) NOT NULL,
	[DeliveryLocation] [geography] NULL,
	[PostalAddressLine1] [nvarchar](60) NOT NULL,
	[PostalAddressLine2] [nvarchar](60) NULL,
	[PostalPostalCode] [nvarchar](10) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NULL,
	[ValidTo] [datetime2](7) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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
ALTER TABLE [dbo].[City] ADD  CONSTRAINT [dboCity_DF_Valid]  DEFAULT ((1)) FOR [Valid]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [dboCountry_DF_Valid]  DEFAULT ((1)) FOR [Valid]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [dboCustomer_DF_Valid]  DEFAULT ((1)) FOR [Valid]
GO
ALTER TABLE [dbo].[StateProvince] ADD  CONSTRAINT [dboStateProvince_DF_Valid]  DEFAULT ((1)) FOR [Valid]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_City]
AS


MERGE dbo.City AS T
USING (SELECT C.*, S.StateProvinceKey FROM [STG].[Application_Cities] C LEFT JOIN dbo.StateProvince S ON C.StateProvinceID = S.StateProvinceSourceID) S
ON (S.CityID = T.CitySourceID AND T.SourceSystem = 'AZURE')

WHEN NOT MATCHED BY TARGET 
THEN INSERT (CitySourceID, [CityName], [StateProvinceKey], [LatestRecordedPopulation], SourceSystem, Valid)
	VALUES (CityID, [CityName], [StateProvinceKey], [LatestRecordedPopulation], 'AZURE', 1)
WHEN MATCHED
	AND T.CitySourceID <> S.CityID
		OR T.[CityName] <> S.[CityName]
		OR T.[StateProvinceKey] <> S.[StateProvinceKey]
		OR T.[LatestRecordedPopulation] <> S.[LatestRecordedPopulation]
		OR T.SourceSystem <> 'AZURE'
	THEN UPDATE 
	SET	T.CitySourceID = S.CityID
		,T.[CityName] = S.[CityName]
		,T.[StateProvinceKey] = S.[StateProvinceKey]
		,T.[LatestRecordedPopulation] = S.[LatestRecordedPopulation]
		,T.SourceSystem = 'AZURE'
		,T.Valid = 1
--WHEN NOT MATCHED BY SOURCE

 ;
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
THEN INSERT (CountrySourceID, [CountryCode], [CountryName], [FormalName], [LatestRecordedPopulation], [Continent], SourceSystem)
	VALUES (CountryID, [IsoAlpha3Code], [CountryName], [FormalName], [LatestRecordedPopulation], [Continent], 'AZURE')
WHEN MATCHED
	AND T.CountrySourceID <> S.[CountryId]
		OR T.[CountryName] <> S.[CountryName]
		OR T.[FormalName] <> S.[FormalName]
		OR T.[LatestRecordedPopulation] <> S.[LatestRecordedPopulation]
		OR T.[Continent] <> S.[Continent]
		OR T.SourceSystem <> 'AZURE'
	THEN UPDATE 
	SET	T.CountrySourceID = S.CountryID
		,T.[CountryName] = S.[CountryName]
		,T.[FormalName] = S.[FormalName]
		,T.[LatestRecordedPopulation] = S.[LatestRecordedPopulation]
		,T.[Continent] = S.[Continent]
		,T.SourceSystem = 'AZURE'
WHEN NOT MATCHED BY SOURCE
	THEN UPDATE
	SET T.Valid = 0
 ;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_Customer]
AS


MERGE dbo.Customer AS T
USING (SELECT S.*, C.CityKey AS [PostalCityKey] FROM [STG].[Sales_Customers] S LEFT JOIN dbo.City C ON S.PostalCityId = C.CitySourceID) S
ON (S.CustomerID = T.CustomerSourceID)

WHEN NOT MATCHED BY TARGET 
THEN INSERT ([CustomerSourceID]
      ,[CustomerName]
      ,[PostalCityKey]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[Valid])
	VALUES (S.[CustomerID]
      ,S.[CustomerName]
      ,S.[PostalCityKey]
      ,S.[CreditLimit]
      ,S.[AccountOpenedDate]
      ,S.[StandardDiscountPercentage]
      ,S.[PaymentDays]
      ,S.[PhoneNumber]
      ,S.[FaxNumber]
      ,S.[DeliveryRun]
      ,S.[RunPosition]
      ,S.[WebsiteURL]
      ,S.[DeliveryAddressLine1]
      ,S.[DeliveryAddressLine2]
      ,S.[DeliveryPostalCode]
      ,S.[PostalAddressLine1]
      ,S.[PostalAddressLine2]
      ,S.[PostalPostalCode]
      ,1)
WHEN MATCHED
	AND T.CustomerSourceID = S.CustomerID
		OR T.[CustomerName] <> S.[CustomerName]
		OR T.[PostalCityKey] <> S.[PostalCityKey]
		OR T.[CreditLimit] <> S.[CreditLimit]
		OR T.[AccountOpenedDate] <> S.[AccountOpenedDate]
		OR T.[StandardDiscountPercentage] <> S.[StandardDiscountPercentage]
		OR T.[PaymentDays] <> S.[PaymentDays]
		OR T.[PhoneNumber] <> S.[PhoneNumber]
		OR T.[FaxNumber] <> S.[FaxNumber]
		OR T.[DeliveryRun] <> S.[DeliveryRun]
		OR T.[RunPosition] <> S.[RunPosition]
		OR T.[WebsiteURL] <> S.[WebsiteURL]
		OR T.[DeliveryAddressLine1] <> S.[DeliveryAddressLine1]
		OR T.[DeliveryAddressLine2] <> S.[DeliveryAddressLine2]
		OR T.[DeliveryPostalCode] <> S.[DeliveryPostalCode]
		OR T.[PostalAddressLine1] <> S.[PostalAddressLine1]
		OR T.[PostalAddressLine2] <> S.[PostalAddressLine2]
		OR T.[PostalPostalCode] <> S.[PostalPostalCode]
	THEN UPDATE 
	SET	T.CustomerSourceID = S.CustomerID
		,T.[CustomerName] = S.[CustomerName]
		,T.[PostalCityKey] = S.[PostalCityKey]
		,T.[CreditLimit] = S.[CreditLimit]
		,T.[AccountOpenedDate] = S.[AccountOpenedDate]
		,T.[StandardDiscountPercentage] = S.[StandardDiscountPercentage]
		,T.[PaymentDays] = S.[PaymentDays]
		,T.[PhoneNumber] = S.[PhoneNumber]
		,T.[FaxNumber] = S.[FaxNumber]
		,T.[DeliveryRun] = S.[DeliveryRun]
		,T.[RunPosition] = S.[RunPosition]
		,T.[WebsiteURL] = S.[WebsiteURL]
		,T.[DeliveryAddressLine1] = S.[DeliveryAddressLine1]
		,T.[DeliveryAddressLine2] = S.[DeliveryAddressLine2]
		,T.[DeliveryPostalCode] = S.[DeliveryPostalCode]
		,T.[PostalAddressLine1] = S.[PostalAddressLine1]
		,T.[PostalAddressLine2] = S.[PostalAddressLine2]
		,T.[PostalPostalCode] = S.[PostalPostalCode]

 ;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_People]
AS


MERGE dbo.People AS T
USING [STG].[Application_People] S 
ON (S.[PersonID] = T.[PersonSourceID])

WHEN NOT MATCHED BY TARGET 
THEN INSERT ([PersonSourceID]
      ,[FullName]
      ,[PreferredName]
      ,[IsPermittedToLogon]
      ,[LogonName]
      ,[IsExternalLogonProvider]
      ,[HashedPassword]
      ,[IsSystemUser]
      ,[IsEmployee]
      ,[IsSalesperson]
      ,[UserPreferences]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[EmailAddress]
      ,[Photo]
      ,[CustomFields])
	VALUES ([PersonID]
      ,[FullName]
      ,[PreferredName]
      ,[IsPermittedToLogon]
      ,[LogonName]
      ,[IsExternalLogonProvider]
      ,[HashedPassword]
      ,[IsSystemUser]
      ,[IsEmployee]
      ,[IsSalesperson]
      ,[UserPreferences]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[EmailAddress]
      ,[Photo]
      ,[CustomFields])
WHEN MATCHED
	AND T.[PersonSourceID] <> S.[PersonID]
		OR T.[FullName] <> S.[FullName]
		OR T.[PreferredName] <> S.[PreferredName]
		OR T.[IsPermittedToLogon] <> S.[IsPermittedToLogon]
		OR T.[LogonName] <> S.[LogonName]
		OR T.[IsExternalLogonProvider] <> S.[IsExternalLogonProvider]
		OR T.[HashedPassword] <> S.[HashedPassword]
		OR T.[IsSystemUser] <> S.[IsSystemUser]
		OR T.[IsEmployee] <> S.[IsEmployee]
		OR T.[IsSalesperson] <> S.[IsSalesperson]
		OR T.[UserPreferences] <> S.[UserPreferences]
		OR T.[PhoneNumber] <> S.[PhoneNumber]
		OR T.[FaxNumber] <> S.[FaxNumber]
		OR T.[EmailAddress] <> S.[EmailAddress]
		OR T.[Photo] <> S.[Photo]
		OR T.[CustomFields] <> S.[CustomFields]
	THEN UPDATE 
	SET	 T.[PersonSourceID] = S.[PersonID]
		,T.[FullName] = S.[FullName]
		,T.[PreferredName] = S.[PreferredName]
		,T.[IsPermittedToLogon] = S.[IsPermittedToLogon]
		,T.[LogonName] = S.[LogonName]
		,T.[IsExternalLogonProvider] = S.[IsExternalLogonProvider]
		,T.[HashedPassword] = S.[HashedPassword]
		,T.[IsSystemUser] = S.[IsSystemUser]
		,T.[IsEmployee] = S.[IsEmployee]
		,T.[IsSalesperson] = S.[IsSalesperson]
		,T.[UserPreferences] = S.[UserPreferences]
		,T.[PhoneNumber] = S.[PhoneNumber]
		,T.[FaxNumber] = S.[FaxNumber]
		,T.[EmailAddress] = S.[EmailAddress]
		,T.[Photo] = S.[Photo]
		,T.[CustomFields] = S.[CustomFields]
 ;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_StateProvince]
AS


MERGE dbo.StateProvince AS T
USING (SELECT S.*, C.CountryKey FROM [STG].[Application_StateProvinces] S LEFT JOIN dbo.Country C ON S.CountryId = C.CountrySourceID) S
ON (S.StateProvinceCode = T.StateProvinceCode AND S.CountryKey = T.CountryKey)

WHEN NOT MATCHED BY TARGET 
THEN INSERT (StateProvinceSourceID, StateProvinceCode, [StateProvinceName], [CountryKey], [LatestRecordedPopulation], SourceSystem, Valid)
	VALUES (StateProvinceID, StateProvinceCode, [StateProvinceName], [CountryKey], [LatestRecordedPopulation], 'AZURE', 1)
WHEN MATCHED
	AND T.StateProvinceSourceID = S.StateProvinceID
		OR T.[StateProvinceName] <> S.[StateProvinceName]
		OR T.[CountryKey] <> S.[CountryKey]
		OR T.[LatestRecordedPopulation] <> S.[LatestRecordedPopulation]
		OR T.SourceSystem <> 'AZURE'
	THEN UPDATE 
	SET	T.StateProvinceSourceID = S.StateProvinceID
		,T.[StateProvinceName] = S.[StateProvinceName]
		,T.[CountryKey] = S.[CountryKey]
		,T.[LatestRecordedPopulation] = S.[LatestRecordedPopulation]
		,T.SourceSystem = 'AZURE'
		,T.Valid = 1
--WHEN NOT MATCHED BY SOURCE

 ;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_StateProvince_Ext]
AS


MERGE dbo.StateProvince AS T
USING (SELECT S.*, -1 AS StateProvinceID, C.CountryKey, 'EXTERNAL' AS SourceSystem FROM [STG].[CSV_AusState] S LEFT JOIN dbo.Country C ON S.Country = C.CountryName) S
ON (S.StateCode = T.StateProvinceCode)

WHEN NOT MATCHED BY TARGET 
THEN INSERT (StateProvinceCode, StateProvinceSourceID, [StateProvinceName], CountryKey, [LatestRecordedPopulation], SourceSystem, Valid)
	VALUES (StateCode, StateProvinceID, [StateName], CountryKey, [LastPopulation], SourceSystem, 1)
WHEN MATCHED
	AND T.[StateProvinceName] <> S.[StateName]
		OR T.CountryKey <> S.CountryKey
		OR T.[LatestRecordedPopulation] <> S.[LastPopulation]
		OR T.SourceSystem <> S.SourceSystem
	THEN UPDATE 
	SET	T.[StateProvinceName] = S.[StateName]
		,T.CountryKey = S.CountryKey
		,T.[LatestRecordedPopulation] = S.[LastPopulation]
		,T.SourceSystem = S.SourceSystem
		,T.Valid = 1
 ;
GO
