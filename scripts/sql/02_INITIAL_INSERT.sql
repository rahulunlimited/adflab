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
	,[RunParallel]
	,[BatchSequence]
	,[RunSequence])
VALUES 
('Src-OnPrem', 'AdventureWorks2014', 'HumanResources', 'Department', NULL, 'STG', 'HumanResources_Department', NULL, 0, NULL, NULL, 1, 1, 1), 
('Src-OnPrem', 'AdventureWorks2014', 'Production', 'WorkOrder', NULL, 'STG', 'Production_WorkOrder', NULL, 1, 'ModifiedDate', 'DATE', 1, 1, 1) 

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
	,[RunParallel]
	,[BatchSequence]
	,[RunSequence])
VALUES
('Src-Azure', 'WideWorldImporters', 'Application', 'Countries', NULL, 'STG', 'Application_Countries', 'dbo.spLoad_Country', 0, NULL, NULL, 0, 1, 1), 
('Src-Azure', 'WideWorldImporters', 'Application', 'StateProvinces', NULL, 'STG', 'Application_StateProvinces', 'dbo.spLoad_StateProvince', 0, NULL, NULL, 0, 1, 2), 
('Src-Azure', 'WideWorldImporters', 'Application', 'Cities', 'SELECT [CityID] ,[CityName] ,[StateProvinceID] ,CONVERT(varbinary(4000), [Location]) [Location] ,LatestRecordedPopulation ,[LastEditedBy] ,[ValidFrom] ,[ValidTo] FROM [Application].[Cities]', 'STG', 'Application_Cities', NULL, 0, NULL, NULL, 1, 1, 1),
('Src-Azure', 'WideWorldImporters', 'Application', 'CitiesNY', 'SELECT  C.*
FROM [Application].Cities C
INNER JOIN [Application].StateProvinces S ON S.StateProvinceID = C.StateProvinceID
WHERE StateProvinceName = ''New York''', 'STG', 'Application_Cities_NY', NULL, 0, NULL, NULL, 1, 1, 1),
('Src-Azure', 'WideWorldImporters', 'Application', 'DeliveryMethods', NULL, 'STG', 'Application_DeliveryMethods', NULL, 0, NULL, NULL, 1, 1, 1),
('Src-Azure', 'WideWorldImporters', 'Application', 'PaymentMethods', NULL, 'STG', 'Application_PaymentMethods', NULL, 0, NULL, NULL, 1, 1, 1),
('Src-Azure', 'WideWorldImporters', 'Sales', 'Invoices', NULL, 'STG', 'Sales_Invoices', NULL, 1, 'LastEditedWhen', 'DATE', 1, 2, 1)

SELECT * FROM [UTIL].[DataLoadMetadata_FromTable_ToTable]


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
('Src-OnPrem', 'AdventureWorks2014', 'HumanResources', 'Department', NULL, 'ADLS',  'HRDepartment', 'HumanResources_Department', 0, NULL, NULL, ',', '\r\n'), 
('Src-OnPrem', 'AdventureWorks2014', 'Production', 'WorkOrder', NULL, 'ADLS',  'WorkOrder', 'WorkOrder', 1, 'ModifiedDate', 'DATE', ',', '\r\n'),
('Src-Azure', 'WideWorldImporters', 'Sales', 'Invoices', NULL, 'ADLS',  'Sales', 'Invoices', 1, 'LastEditedWhen', 'DATE', '|', '\r\n')

SELECT * FROM [UTIL].DataLoadMetadata_FromTable_ToFile

GO


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

SELECT * FROM [UTIL].[DataLoadMetadata_FromFile_ToTable]

