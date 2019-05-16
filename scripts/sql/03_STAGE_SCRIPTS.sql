DROP PROCEDURE IF EXISTS [dbo].[spLoad_StateProvince_Ext]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_StateProvince]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_People]
GO
DROP PROCEDURE IF EXISTS [dbo].[spLoad_Country]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StateProvince]') AND type in (N'U'))
ALTER TABLE [dbo].[StateProvince] DROP CONSTRAINT IF EXISTS [dboStateProvince_DF_Valid]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
ALTER TABLE [dbo].[Country] DROP CONSTRAINT IF EXISTS [dboCountry_DF_Valid]
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryKey] [int] IDENTITY(1,1) NOT NULL,
	[CountryID] [int] NOT NULL,
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
CREATE TABLE [dbo].[StateProvince](
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
	[Title] [nvarchar](100) NULL,
	[PrimarySalesTerritory] [nvarchar](100) NULL,
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
      ,[Title]
      ,[PrimarySalesTerritory]
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
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [dboCountry_DF_Valid]  DEFAULT ((1)) FOR [Valid]
GO
ALTER TABLE [dbo].[StateProvince] ADD  CONSTRAINT [dboStateProvince_DF_Valid]  DEFAULT ((1)) FOR [Valid]
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
THEN INSERT (CountryID, [CountryCode], [IsoNumericCode], [CountryName], [FormalName], [LatestRecordedPopulation], [Continent], SourceSystem)
	VALUES (CountryID, [IsoAlpha3Code], [IsoNumericCode], [CountryName], [FormalName], [LatestRecordedPopulation], [Continent], 'Azure')
WHEN MATCHED
	AND T.[IsoNumericCode] <> S.[IsoNumericCode]
		OR T.CountryID <> S.[CountryId]
		OR T.[CountryName] <> S.[CountryName]
		OR T.[FormalName] <> S.[FormalName]
		OR T.[LatestRecordedPopulation] <> S.[LatestRecordedPopulation]
		OR T.[Continent] <> S.[Continent]
		OR T.SourceSystem <> 'Azure'
	THEN UPDATE 
	SET	T.[IsoNumericCode] = S.[IsoNumericCode]
		,T.CountryID = S.CountryID
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
CREATE   PROCEDURE [dbo].[spLoad_People]
AS


MERGE dbo.People AS T
USING [STG].[Application_People] S 
ON (S.[PersonId] = T.[PersonSourceId])

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
      ,[CustomFields]
	  ,[Title]
	  ,[PrimarySalesTerritory])
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
      ,[CustomFields]
	   ,JSON_VALUE(CustomFields, '$.Title') 
	   ,JSON_VALUE(CustomFields, '$.PrimarySalesTerritory')
)
WHEN MATCHED
	AND 
      T.[FullName] <> S.[FullName]
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
	SET	
      T.[FullName] = S.[FullName]
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
	  ,T.[Title] = JSON_VALUE(S.CustomFields, '$.Title') 
	  ,T.[PrimarySalesTerritory] = JSON_VALUE(S.CustomFields, '$.PrimarySalesTerritory')
 ;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_StateProvince]
AS


MERGE dbo.StateProvince AS T
USING (SELECT S.*, C.CountryKey FROM [STG].[Application_StateProvinces] S LEFT JOIN dbo.Country C ON S.CountryId = C.CountryID) S
ON (S.StateProvinceCode = T.StateProvinceCode)

WHEN NOT MATCHED BY TARGET 
THEN INSERT (StateProvinceCode, [StateProvinceName], [CountryKey], [LatestRecordedPopulation], SourceSystem, Valid)
	VALUES (StateProvinceCode, [StateProvinceName], [CountryKey], [LatestRecordedPopulation], 'Azure', 1)
WHEN MATCHED
	AND T.[StateProvinceName] <> S.[StateProvinceName]
		OR T.[CountryKey] <> S.[CountryKey]
		OR T.[LatestRecordedPopulation] <> S.[LatestRecordedPopulation]
		OR T.SourceSystem <> 'Azure'
	THEN UPDATE 
	SET	T.[StateProvinceName] = S.[StateProvinceName]
		,T.[CountryKey] = S.[CountryKey]
		,T.[LatestRecordedPopulation] = S.[LatestRecordedPopulation]
		,T.SourceSystem = 'Azure'
		,T.Valid = 1
--WHEN NOT MATCHED BY SOURCE
--	THEN 
--	UPDATE SET T.Valid = 0
 ;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoad_StateProvince_Ext]
AS


MERGE dbo.StateProvince AS T
USING (SELECT S.*, C.CountryKey, 'External' AS SourceSystem FROM [STG].[CSV_AusState] S LEFT JOIN dbo.Country C ON S.Country = C.CountryName) S
ON (S.StateCode = T.StateProvinceCode)

WHEN NOT MATCHED BY TARGET 
THEN INSERT (StateProvinceCode, [StateProvinceName], CountryKey, [LatestRecordedPopulation], SourceSystem, Valid)
	VALUES (StateCode, [StateName], CountryKey, [LastPopulation], SourceSystem, 1)
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
