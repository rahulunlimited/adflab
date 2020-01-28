/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

IF NOT EXISTS(SELECT * FROM [UTIL].[DataLoadMetadata_FromTable_ToTable] WHERE SourceSystem = 'Src-OnPrem')
BEGIN
	DELETE FROM [UTIL].[DataLoadMetadata_FromTable_ToTable]
	WHERE SourceSystem = 'Src-OnPrem'

	INSERT INTO [UTIL].[DataLoadMetadata_FromTable_ToTable] (
		[SourceSystem]
		,[SourceDatabase]
		,[SourceSchema]
		,[SourceTable]
		,[SourceSQL]
		,[TargetSchema]
		,[TargetTable]
		,[TransformationSP]
		,[IncrementalLoadFlag]
		,[IncrementalLoadColumn]
		,[IncrementalLoadColumnType]
		)
	VALUES 
	('Src-OnPrem', 'AdventureWorks2017', 'HumanResources', 'Department', NULL, 'STG', 'HumanResources_Department', NULL, 0, NULL, NULL), 
	('Src-OnPrem', 'AdventureWorks2017', 'Production', 'WorkOrder', NULL, 'STG', 'Production_WorkOrder', NULL, 1, 'ModifiedDate', 'DATE') 
END

IF NOT EXISTS(SELECT * FROM [UTIL].[DataLoadMetadata_FromTable_ToTable] WHERE SourceSystem = 'Src-Azure')
BEGIN
	DELETE FROM [UTIL].[DataLoadMetadata_FromTable_ToTable]
	WHERE SourceSystem = 'Src-Azure'

	INSERT INTO [UTIL].[DataLoadMetadata_FromTable_ToTable] (
		[SourceSystem]
		,[SourceDatabase]
		,[SourceSchema]
		,[SourceTable]
		,[SourceSQL]
		,[TargetSchema]
		,[TargetTable]
		,[TransformationSP]
		,[IncrementalLoadFlag]
		,[IncrementalLoadColumn]
		,[IncrementalLoadColumnType]
		)
	VALUES
	('Src-Azure', 'WideWorldImporters-Standard', 'Application', 'Countries', NULL, 'STG', 'Application_Countries', 'dbo.spLoad_Country', 0, NULL, NULL), 
	('Src-Azure', 'WideWorldImporters-Standard', 'Application', 'StateProvinces', NULL, 'STG', 'Application_StateProvinces', 'dbo.spLoad_StateProvince', 0, NULL, NULL), 
	('Src-Azure', 'WideWorldImporters-Standard', 'Application', 'Cities', 'SELECT [CityID] ,[CityName] ,[StateProvinceID] ,CONVERT(varbinary(4000), [Location]) [Location] ,LatestRecordedPopulation ,[LastEditedBy] ,[ValidFrom] ,[ValidTo] FROM [Application].[Cities]', 'STG', 'Application_Cities', 'dbo.spLoad_City', 0, NULL, NULL),
	('Src-Azure', 'WideWorldImporters-Standard', 'Application', 'CitiesNY', 'SELECT  C.*
	FROM [Application].Cities C
	INNER JOIN [Application].StateProvinces S ON S.StateProvinceID = C.StateProvinceID
	WHERE StateProvinceName = ''New York''', 'STG', 'Application_Cities_NY', NULL, 0, NULL, NULL),
	('Src-Azure', 'WideWorldImporters-Standard', 'Application', 'DeliveryMethods', NULL, 'STG', 'Application_DeliveryMethods', NULL, 0, NULL, NULL),
	('Src-Azure', 'WideWorldImporters-Standard', 'Application', 'PaymentMethods', NULL, 'STG', 'Application_PaymentMethods', NULL, 0, NULL, NULL),
	('Src-Azure', 'WideWorldImporters-Standard', 'Application', 'People', NULL, 'STG', 'Application_People', NULL, 0, NULL, NULL),
	('Src-Azure', 'WideWorldImporters-Standard', 'Sales', 'Customers', NULL, 'STG', 'Sales_Customers', 'dbo.spLoad_Customer', 0, NULL, NULL),
	('Src-Azure', 'WideWorldImporters-Standard', 'Sales', 'Invoices', NULL, 'STG', 'Sales_Invoices', NULL, 1, 'LastEditedWhen', 'DATE')

	--SELECT * FROM [UTIL].[DataLoadMetadata_FromTable_ToTable]
END


IF NOT EXISTS (SELECT * FROM [UTIL].DataLoadMetadata_FromTable_ToFile WHERE TargetSystem = 'ADLS')
BEGIN
	DELETE FROM [UTIL].DataLoadMetadata_FromTable_ToFile
	WHERE TargetSystem = 'ADLS'

	INSERT INTO [UTIL].DataLoadMetadata_FromTable_ToFile (
		[SourceSystem]
		,[SourceDatabase]
		,[SourceSchema]
		,[SourceTable]
		,[SourceSQL]
		,[TargetSystem]
		,[TargetFolder]
		,[TargetFilePrefix]
		,[IncrementalLoadFlag]
		,[IncrementalLoadColumn]
		,[IncrementalLoadColumnType]
		,[ColumnDelimiter]
		,[RowDelimiter])
	VALUES 
	('Src-OnPrem', 'AdventureWorks2017', 'HumanResources', 'Department', NULL, 'ADLS',  'HRDepartment', 'HumanResources_Department', 0, NULL, NULL, ',', '\r\n'), 
	('Src-OnPrem', 'AdventureWorks2017', 'Production', 'WorkOrder', NULL, 'ADLS',  'WorkOrder', 'WorkOrder', 1, 'ModifiedDate', 'DATE', ',', '\r\n'),
	('Src-Azure', 'WideWorldImporters-Standard', 'Sales', 'Invoices', NULL, 'ADLS',  'Sales', 'Invoices', 1, 'LastEditedWhen', 'DATE', '|', '\r\n')

	--SELECT * FROM [UTIL].DataLoadMetadata_FromTable_ToFile
END

IF NOT EXISTS (SELECT * FROM [UTIL].[DataLoadMetadata_FromFile_ToTable] WHERE SourceSystem = 'Az-FileStorage')
BEGIN
	DELETE FROM [UTIL].[DataLoadMetadata_FromFile_ToTable]
	WHERE SourceSystem = 'Az-FileStorage'

	INSERT INTO [UTIL].[DataLoadMetadata_FromFile_ToTable] (
		[SourceSystem]
		,[SourceFile]
		,[TargetSchema]
		,[TargetTable]
		,[TransformationSP]
		,[ColumnDelimiter]
		,[RowDelimiter]
		,[FirstRowHeader]
		,[PrefixDateTime]
		,[SourceFolder]
		,[ArchiveFolder]
	)

	VALUES 
	('Az-FileStorage', 'AUS-State.csv', 'STG', 'CSV_AusState', 'dbo.spLoad_StateProvince_Ext', ',', '\r\n', 1, 1, 'src', 'dest')
END

IF NOT EXISTS (SELECT * FROM [UTIL].[DataLoadMetadata_FromFile_ToTable] WHERE SourceSystem = 'ADLS')
BEGIN
	DELETE FROM [UTIL].[DataLoadMetadata_FromFile_ToTable]
	WHERE SourceSystem = 'ADLS'

	INSERT INTO [UTIL].[DataLoadMetadata_FromFile_ToTable] (
		[SourceSystem]
		,[SourceFile]
		,[TargetSchema]
		,[TargetTable]
		,[TransformationSP]
		,[ColumnDelimiter]
		,[RowDelimiter]
		,[FirstRowHeader]
		,[PrefixDateTime]
		,[SourceFolder]
		,[ArchiveFolder]
	)

	VALUES 
	('ADLS', 'WorkOrder', 'STG', 'EXT_WorkOrder', NULL, ',', NULL, NULL, NULL, 'WorkOrder', NULL),
	('ADLS', 'Invoices', 'STG', 'EXT_Invoices', NULL, '|', NULL, NULL, NULL, 'Sales', NULL)

	--SELECT * FROM [UTIL].[DataLoadMetadata_FromFile_ToTable]
END