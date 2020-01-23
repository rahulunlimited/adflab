









CREATE VIEW [UTIL].[vDataLoadMetaData_FromFile_ToTable]
AS
SELECT 
	RecordID
	,[SourceSystem]
	,[SourceFile]

	,[TargetSchema]
	,[TargetTable]
	,CONCAT(TargetSchema, '.', TargetTable) AS TargetObject
	,[ExtractionFlag]
	,CASE 
		WHEN TransformationSP IS NULL THEN ''
		ELSE TRIM(TransformationSP)
	END AS [TransformationSP]

	,ISNULL([SourceFolder], '') AS [SourceFolder]
	,ISNULL(ArchiveFolder, '') AS ArchiveFolder

	,ISNULL([ColumnDelimiter], '') AS [ColumnDelimiter]
	,ISNULL([RowDelimiter], '') AS [RowDelimiter]
	,ISNULL([FirstRowHeader], '') AS [FirstRowHeader]
	,ISNULL([PrefixDateTime], '') AS [PrefixDateTime]

  FROM [UTIL].[DataLoadMetadata_FromFile_ToTable]

