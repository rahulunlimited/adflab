











CREATE VIEW [UTIL].[vDataLoadMetaData_FromTable_ToFile]
AS
SELECT 
	M.RecordID
	,[SourceSystem]
	,[SourceDatabase]
	,[SourceSchema]
	,[TargetSystem]
	,[SourceTable]
	,CONCAT(SourceSchema, '.', [SourceTable]) SourceObject
	,CASE
		--When Full load is to be performed and the SourceSQL is NOT specified 
		WHEN SourceSQL IS NULL AND IncrementalLoadFlag = 0
			THEN CONCAT('SELECT * FROM ', SourceSchema, '.', [SourceTable])
		--When Incremental Load is to be performed based on a SourceDateColumn and SourceSQL is NOT specified
		WHEN SourceSQL IS NULL AND IncrementalLoadFlag = 1 --AND IncrementalLoadColumn IS NOT NULL
			THEN CONCAT('SELECT * FROM ', SourceSchema, '.', [SourceTable], ' WHERE ', IncrementalLoadColumn, ' >= {LASTEXTRACTION} ')
		--When Incremental Load is to be performed based on a SourceDateColumn and SourceSQL IS specified
		--Check if the Source SQL already contains a WHERE clause, then use the AND for SourceDateColumn
		WHEN SourceSQL IS NOT NULL AND IncrementalLoadFlag = 1 --AND IncrementalLoadColumn IS NOT NULL
			THEN CONCAT(SourceSQL,    IIF(CHARINDEX('WHERE', SourceSQL) >= 1, ' AND ', ' WHERE '),     IncrementalLoadColumn, ' >= {LASTEXTRACTION} ')
		ELSE ISNULL(SourceSQL, '')
	END AS [SourceSQL]
	,[TargetFolder]
	,ISNULL([TargetFilePrefix], '') AS [TargetFilePrefix]
	,[ExtractionFlag]
	,[IncrementalLoadFlag]
	,ISNULL(IncrementalLoadColumn, '') AS IncrementalLoadColumn
	,UPPER(ISNULL(IncrementalLoadColumnType, '')) AS IncrementalLoadColumnType

	,ISNULL([ColumnDelimiter], '') AS [ColumnDelimiter]
	,ISNULL([RowDelimiter], '') AS [RowDelimiter]

	,ISNULL(L.LastExtractionCounter, 0) AS LastExtractionCounter
	,ISNULL(L.LastExtractionTime, '1900-01-01') AS LastExtractionTime

  FROM [UTIL].DataLoadMetadata_FromTable_ToFile M
  LEFT JOIN [UTIL].[DataLoadMetaData_LastExtraction] L ON M.RecordID = L.RecordID

