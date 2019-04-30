DELETE FROM UTIL.DataLoadMetadata
GO

DECLARE @CTR INT;
SELECT @CTR = ISNULL(MAX(RecordID),0) FROM UTIL.DataLoadMetadata

INSERT INTO [UTIL].[DataLoadMetadata] (
	[RecordID]
	,[SourceType]
	,[SourceSystem]
	,[SourceDatabase]
	,[SourceSchema]
	,[SourceObject]
	,[SourceSQL]
	,[TargetType]
	,[TargetSchema]
	,[TargetObject]
	,[TransformationSP]
	,[IncrementalLoadFlag]
	,[IncrementalLoadColumn]
	,[IncrementalLoadColumnType])
VALUES 
(@CTR + 1, 'Table', 'Src-OnPrem', 'AdventureWorks2014', 'HumanResources', 'Department', NULL, 'Table',  'STG', 'HumanResources_Department', NULL, 0, NULL, NULL), 
(@CTR + 2, 'Table', 'Src-OnPrem', 'AdventureWorks2014', 'Production', 'WorkOrder', NULL, 'Table',  'STG', 'Production_WorkOrder', NULL, 1, 'ModifiedDate', 'DATE'), 
(@CTR + 3, 'Table', 'Src-Azure', 'WideWorldImporters', 'Application', 'Cities', 'SELECT [CityID] ,[CityName] ,[StateProvinceID] ,CONVERT(varbinary(4000), [Location]) [Location] ,LatestRecordedPopulation ,[LastEditedBy] ,[ValidFrom] ,[ValidTo] FROM [Application].[Cities]', 'Table',  'STG', 'Application_Cities', NULL, 0, NULL, NULL),
(@CTR + 4, 'Table', 'Src-Azure', 'WideWorldImporters', 'Application', 'StateProvinces', 'SELECT S.[StateProvinceID]
      ,S.[StateProvinceCode]
      ,S.[StateProvinceName]
      ,C.IsoAlpha3Code AS CountryCode
      ,S.[SalesTerritory]
      ,S.[Border]
      ,S.[LatestRecordedPopulation]
  FROM [Application].[StateProvinces] S
  LEFT JOIN [Application].Countries C ON S.CountryID = C.CountryID', 'Table',  'STG', 'Application_StateProvinces', NULL, 0, NULL, NULL), 
(@CTR + 5, 'Table', 'Src-Azure', 'WideWorldImporters', 'Application', 'Countries', NULL, 'Table',  'STG', 'Application_Countries', NULL, 0, NULL, NULL), 
(@CTR + 6, 'Table', 'Src-Azure', 'WideWorldImporters', 'Application', 'DeliveryMethods', NULL, 'Table',  'STG', 'Application_DeliveryMethods', NULL, 0, NULL, NULL),
(@CTR + 7, 'Table', 'Src-Azure', 'WideWorldImporters', 'Application', 'CitiesNY', 'SELECT  C.*
FROM [Application].Cities C
INNER JOIN [Application].StateProvinces S ON S.StateProvinceID = C.StateProvinceID
WHERE StateProvinceName = ''New York''', 'Table',  'STG', 'Application_Cities_NY', NULL, 0, NULL, NULL)

GO

DECLARE @CTR INT;
SELECT @CTR = ISNULL(MAX(RecordID),0) FROM UTIL.DataLoadMetadata


INSERT INTO [UTIL].[DataLoadMetadata] (
	[RecordID]
	,[SourceType]
	,[SourceSystem]
	,[SourceDatabase]
	,[SourceSchema]
	,[SourceObject]
	,[SourceSQL]
	,[TargetType]
	,[TargetObject]
	,[TargetFolder]
	,[PrefixDateTime]
	,[IncrementalLoadFlag]
	,[ColumnDelimiter]
	,[RowDelimiter]
	,[IncrementalLoadColumn]
	,[IncrementalLoadColumnType])
VALUES 
(@CTR + 1, 'Table', 'Src-OnPrem', 'AdventureWorks2014', 'HumanResources', 'Department', NULL, 'Datalake',  'HumanResources_Department', 'HRDepartment', 1, 0, ',', '\r\n', NULL, NULL), 
(@CTR + 2, 'Table', 'Src-OnPrem', 'AdventureWorks2014', 'Production', 'WorkOrder', NULL, 'Datalake',  'WorkOrder', 'WorkOrder', 1, 1, ',', '\r\n',  'ModifiedDate', 'DATE'),
(@CTR + 3, 'Table', 'Src-Azure', 'WideWorldImporters', 'Sales', 'Invoices', NULL, 'Datalake',  'Invoices', 'Sales', 1, 1, '|', '\r\n',  'LastEditedWhen', 'DATE')

GO



DECLARE @CTR INT;
SELECT @CTR = ISNULL(MAX(RecordID),0) FROM UTIL.DataLoadMetadata


INSERT INTO [UTIL].[DataLoadMetadata] (
	[RecordID]
	,[SourceType]
	,[SourceSystem]
	,[SourceObject]
	,[TargetType]
	,[TargetSchema]
	,[TargetObject]
	,[TransformationSP]
	,[ColumnDelimiter]
	,[RowDelimiter]
	,[FirstRowHeader]
	,[PrefixDateTime]
	,[SourceFolder]
	,[TargetFolder]
)

VALUES 
(@CTR + 1, 'File', 'Local', 'AUS-State.csv', 'Table', 'STG', 'CSV_AusState', NULL, ',', '\r\n', 1, 1, 'src', 'dest')



GO



DECLARE @CTR INT;
SELECT @CTR = ISNULL(MAX(RecordID),0) FROM UTIL.DataLoadMetadata


INSERT INTO [UTIL].[DataLoadMetadata] (
	[RecordID]
	,[SourceType]
	,[SourceSystem]
	,[SourceObject]
	,[TargetType]
	,[TargetSchema]
	,[TargetObject]
	,[TransformationSP]
	,[IncrementalLoadFlag]
	,[SourceFolder]
	,[ColumnDelimiter]
)

VALUES 
(@CTR + 1, 'Datalake', 'ADLSG2', 'WorkOrder', 'Table', 'STG', 'EXT_WorkOrder', NULL, 1, 'WorkOrder', ','),
(@CTR + 2, 'Datalake', 'ADLSG2', 'Invoices', 'Table', 'STG', 'EXT_Invoices', NULL, 1, 'Sales', '|')

SELECT * FROM UTIL.vDataLoadMetadata
