DROP USER IF EXISTS TestMask
GO
CREATE USER TestMask WITHOUT LOGIN;
GRANT SELECT TO TestMask;
GO
DROP PROCEDURE IF EXISTS [UTIL].[spUpdateLastExtraction]
GO
DROP PROCEDURE IF EXISTS [UTIL].[spPipelineExecutionInitiate]
GO
DROP PROCEDURE IF EXISTS [UTIL].[spPipelineExecutionFinish]
GO
DROP PROCEDURE IF EXISTS [UTIL].[spCreateCalendar]
GO
DROP PROCEDURE IF EXISTS [UTIL].[spActivityExecutionLog]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[PipelineExecution]') AND type in (N'U'))
ALTER TABLE [UTIL].[PipelineExecution] DROP CONSTRAINT IF EXISTS [DF_PipelineExecutionCreatedDateTime]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[Parameter]') AND type in (N'U'))
ALTER TABLE [UTIL].[Parameter] DROP CONSTRAINT IF EXISTS [DF_Parameter_DateCreated]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToTable]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__RunSe__7A3223E8]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToTable]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Batch__793DFFAF]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToTable]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__RunPa__7849DB76]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToTable]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Incre__7755B73D]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToTable]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Extra__76619304]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToTable]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Recor__756D6ECB]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToFile]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToFile] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Incre__73852659]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToFile]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToFile] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Extra__72910220]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromTable_ToFile]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToFile] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Recor__719CDDE7]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromFile_ToTable]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromFile_ToTable] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Extra__65370702]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[DataLoadMetadata_FromFile_ToTable]') AND type in (N'U'))
ALTER TABLE [UTIL].[DataLoadMetadata_FromFile_ToTable] DROP CONSTRAINT IF EXISTS [DF__DataLoadM__Recor__6442E2C9]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UTIL].[ActivityExecution]') AND type in (N'U'))
ALTER TABLE [UTIL].[ActivityExecution] DROP CONSTRAINT IF EXISTS [DF_ActivityExecutionCreatedDateTime]
GO
DROP TABLE IF EXISTS [UTIL].[PipelineExecution]
GO
DROP TABLE IF EXISTS [UTIL].[Parameter]
GO
DROP TABLE IF EXISTS [UTIL].[Calendar]
GO
DROP TABLE IF EXISTS [UTIL].[ActivityExecution]
GO
DROP VIEW IF EXISTS [UTIL].[vDataLoadMetaData_FromTable_ToFile]
GO
DROP TABLE IF EXISTS [UTIL].[DataLoadMetadata_FromTable_ToFile]
GO
DROP VIEW IF EXISTS [UTIL].[vDataLoadMetaData_FromTable_ToTable]
GO
DROP TABLE IF EXISTS [UTIL].[DataLoadMetaData_LastExtraction]
GO
DROP TABLE IF EXISTS [UTIL].[DataLoadMetadata_FromTable_ToTable]
GO
DROP VIEW IF EXISTS [UTIL].[vDataLoadMetaData_FromFile_ToTable]
GO
DROP TABLE IF EXISTS [UTIL].[DataLoadMetadata_FromFile_ToTable]
GO
DROP SCHEMA IF EXISTS [UTIL]
GO
CREATE SCHEMA [UTIL]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UTIL].[DataLoadMetadata_FromFile_ToTable](
	[RecordID] [uniqueidentifier] NULL,
	[SourceSystem] [nvarchar](100) NOT NULL,
	[SourceFile] [nvarchar](100) NOT NULL,
	[TargetSchema] [nvarchar](100) NULL,
	[TargetTable] [nvarchar](100) NULL,
	[ExtractionFlag] [bit] NULL,
	[TransformationSP] [nvarchar](250) NULL,
	[SourceFolder] [varchar](500) NULL,
	[ArchiveFolder] [varchar](500) NULL,
	[ColumnDelimiter] [varchar](10) NULL,
	[RowDelimiter] [varchar](10) NULL,
	[FirstRowHeader] [bit] NULL,
	[PrefixDateTime] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










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

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable](
	[RecordID] [uniqueidentifier] NULL,
	[SourceSystem] [nvarchar](100) NOT NULL,
	[SourceDatabase] [nvarchar](100) NULL,
	[SourceSchema] [nvarchar](100) NULL,
	[SourceTable] [nvarchar](100) NOT NULL,
	[SourceSQL] [nvarchar](max) NULL,
	[TargetSchema] [nvarchar](100) NULL,
	[TargetTable] [nvarchar](100) NULL,
	[ExtractionFlag] [bit] NULL,
	[TransformationSP] [nvarchar](250) NULL,
	[IncrementalLoadFlag] [bit] NULL,
	[IncrementalLoadColumn] [nvarchar](100) NULL,
	[IncrementalLoadColumnType] [nvarchar](100) NULL,
	[RunParallel] [bit] NOT NULL,
	[BatchSequence] [int] NOT NULL,
	[RunSequence] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UTIL].[DataLoadMetaData_LastExtraction](
	[RecordID] [uniqueidentifier] NOT NULL,
	[LastExtractionTime] [datetime] NULL,
	[LastExtractionCounter] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE VIEW [UTIL].[vDataLoadMetaData_FromTable_ToTable]
AS
SELECT 
	M.RecordID
	,[SourceSystem]
	,[SourceDatabase]
	,[SourceSchema]
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
	,[TargetSchema]
	,[TargetTable]
	,CONCAT(TargetSchema, '.', TargetTable) TargetObject
	,[ExtractionFlag]
	,CASE 
		WHEN TransformationSP IS NULL THEN ''
		ELSE TRIM(TransformationSP)
	END AS [TransformationSP]
	,[IncrementalLoadFlag]
	,ISNULL(IncrementalLoadColumn, '') AS IncrementalLoadColumn
	,UPPER(ISNULL(IncrementalLoadColumnType, '')) AS IncrementalLoadColumnType

	,RunParallel
	,BatchSequence
	,RunSequence

	,ISNULL(L.LastExtractionCounter, 0) AS LastExtractionCounter
	,ISNULL(L.LastExtractionTime, '1900-01-01') AS LastExtractionTime

  FROM [UTIL].DataLoadMetadata_FromTable_ToTable M
  LEFT JOIN [UTIL].[DataLoadMetaData_LastExtraction] L ON M.RecordID = L.RecordID

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UTIL].[DataLoadMetadata_FromTable_ToFile](
	[RecordID] [uniqueidentifier] NULL,
	[SourceSystem] [nvarchar](100) NOT NULL,
	[SourceDatabase] [nvarchar](100) NULL,
	[SourceSchema] [nvarchar](100) NULL,
	[SourceTable] [nvarchar](100) NOT NULL,
	[SourceSQL] [nvarchar](max) NULL,
	[TargetSystem] [nvarchar](100) NOT NULL,
	[TargetFolder] [varchar](500) NULL,
	[TargetFilePrefix] [nvarchar](100) NULL,
	[ExtractionFlag] [bit] NULL,
	[IncrementalLoadFlag] [bit] NULL,
	[IncrementalLoadColumn] [nvarchar](100) NULL,
	[IncrementalLoadColumnType] [nvarchar](100) NULL,
	[ColumnDelimiter] [varchar](10) NULL,
	[RowDelimiter] [varchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












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

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UTIL].[ActivityExecution](
	[ActivityExecutionID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityType] [nvarchar](100) NOT NULL,
	[ActivityName] [nvarchar](100) NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MessageHeader] [nvarchar](250) NOT NULL,
	[MessageDescription] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_ActivityExecutionID] PRIMARY KEY CLUSTERED 
(
	[ActivityExecutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UTIL].[Calendar](
	[DateKey] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Day] [tinyint] NOT NULL,
	[DaySuffix] [char](2) NOT NULL,
	[Weekday] [tinyint] NOT NULL,
	[WeekDayName] [varchar](10) NOT NULL,
	[IsWeekend] [bit] NOT NULL,
	[DayOfYear] [smallint] NOT NULL,
	[WeekOfMonth] [tinyint] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[Month] [tinyint] NOT NULL,
	[MonthID] [varchar](10) NOT NULL,
	[MonthName] [varchar](10) NOT NULL,
	[ShortMonthYearName] [varchar](10) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[HalfYearName] [varchar](6) NOT NULL,
	[Year] [int] NOT NULL,
	[FirstDayOfWeek] [date] NOT NULL,
	[FirstDayOfMonth] [date] NOT NULL,
	[LastDayOfMonth] [date] NOT NULL,
	[FirstDayOfQuarter] [date] NOT NULL,
	[LastDayOfQuarter] [date] NOT NULL,
	[FirstDayOfYear] [date] NOT NULL,
	[LastDayOfYear] [date] NOT NULL,
	[FiscalYear] [int] NOT NULL,
	[FiscalName] [varchar](6) NOT NULL,
	[FiscalQuarterName] [varchar](6) NOT NULL,
	[FiscalHalfYearName] [varchar](6) NOT NULL,
	[FiscalStartDate] [date] NOT NULL,
	[FiscalEndDate] [date] NOT NULL,
	[FiscalMonth] [tinyint] NOT NULL,
	[FiscalMonthName] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UTIL].[Parameter](
	[ParameterName] [varchar](50) NOT NULL,
	[ParameterValue] [varchar](50) NOT NULL,
	[ParameterDescription] [varchar](100) NULL,
	[Active] [bit] NULL,
	[DateCreated] [date] NULL,
 CONSTRAINT [PK_UtilParameter] PRIMARY KEY CLUSTERED 
(
	[ParameterName] ASC,
	[ParameterValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UTIL].[PipelineExecution](
	[PipelineExecutionID] [int] IDENTITY(1,1) NOT NULL,
	[DataFactoryName] [nvarchar](100) NOT NULL,
	[PipelineName] [nvarchar](100) NOT NULL,
	[RunID] [nvarchar](250) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[ExecutionStatus] [nvarchar](100) NULL,
	[Message] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_PipelineExecutionID] PRIMARY KEY CLUSTERED 
(
	[PipelineExecutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [UTIL].[ActivityExecution] ADD  CONSTRAINT [DF_ActivityExecutionCreatedDateTime]  DEFAULT (getutcdate()) FOR [LogTime]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromFile_ToTable] ADD CONSTRAINT Util_DataLoadMetadata_FromFile_ToTable_DF_RecordID DEFAULT (newid()) FOR [RecordID]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromFile_ToTable] ADD CONSTRAINT Util_DataLoadMetadata_FromFile_ToTable_DF_ExtractionFlag  DEFAULT ((1)) FOR [ExtractionFlag]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToFile] ADD CONSTRAINT Util_DataLoadMetadata_FromFile_ToFile_DF_RecordID  DEFAULT (newid()) FOR [RecordID]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToFile] ADD CONSTRAINT Util_DataLoadMetadata_FromFile_ToFile_DF_ExtractionFlag  DEFAULT ((1)) FOR [ExtractionFlag]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToFile] ADD CONSTRAINT Util_DataLoadMetadata_FromFile_ToFile_DF_IncrementalLoadFlag  DEFAULT ((0)) FOR [IncrementalLoadFlag]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] ADD CONSTRAINT Util_DataLoadMetadata_FromTable_ToTable_DF_RecordID DEFAULT (newid()) FOR [RecordID]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] ADD CONSTRAINT Util_DataLoadMetadata_FromTable_ToTable_DF_ExtractionFlag DEFAULT ((1)) FOR [ExtractionFlag]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] ADD CONSTRAINT Util_DataLoadMetadata_FromTable_ToTable_DF_IncrementalLoadFlag DEFAULT ((0)) FOR [IncrementalLoadFlag]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] ADD CONSTRAINT Util_DataLoadMetadata_FromTable_ToTable_DF_RunParallel DEFAULT ((1)) FOR [RunParallel]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] ADD CONSTRAINT Util_DataLoadMetadata_FromTable_ToTable_DF_BatchSequence DEFAULT ((1)) FOR [BatchSequence]
GO
ALTER TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] ADD CONSTRAINT Util_DataLoadMetadata_FromTable_ToTable_DF_RunSequence DEFAULT ((1)) FOR [RunSequence]
GO
ALTER TABLE [UTIL].[Parameter] ADD  CONSTRAINT [Util_Parameter_DF_Parameter_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
GO
ALTER TABLE [UTIL].[PipelineExecution] ADD  CONSTRAINT [Util_PipelineExecution_DF_PipelineExecutionCreatedDateTime]  DEFAULT (getutcdate()) FOR [CreatedDateTime]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************
Name : spActivityExecutionLog
Created by : Rahul Agrawal (Velrada)
Created on : 13-Mar-2018
Description : The SP is used to log progress of an activity
*******************************************************************
Change log
Please maintain the change log in the below section.
Updated On | Updated By | Update Details
(1)
(2)
*******************************************************************/
CREATE PROCEDURE [UTIL].[spActivityExecutionLog]
(
  @ActivityName             nvarchar(100),
  @MessageHeader            nvarchar(250),
  @MessageDescription       nvarchar(1000) = '',
  @ActivityType             nvarchar(100) = 'SP'
)
AS
BEGIN
    SET NOCOUNT ON
   
   INSERT INTO UTIL.ActivityExecution
   (
      [ActivityType]
      ,[ActivityName]
      ,[MessageHeader]
      ,[MessageDescription]
   )
   VALUES
   (
	  @ActivityType       
	  ,@ActivityName  
	  ,@MessageHeader            
	  ,@MessageDescription
   )

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [UTIL].[spCreateCalendar]
AS
DECLARE @StartDate DATE = '20000101', @NumberOfYears INT = 50;


/*******************************************************************
Name : UTIL.uspCreateCalendar
Created by : Rahul Agrawal (Velrada)
Created on : 19-Jun-2017
Description : The SP is used to create the Calendar table. 
By Default the SP creates a calendar for 50 years based on the start date. Please update the parameters for changing the Start Date and length
The Calendar also has provision for Public Holidays. 
The Public holiday information can be uploaded using the SSIS package LOAD_HolidayList.dtsx
*******************************************************************
Change log
Please maintain the change log in the below section.
Updated On | Updated By | Update Details
(1) 
(2) 

*******************************************************************/


DECLARE @PayPeriodDate DATE
SET @PayPeriodDate = '2017-05-26'


-- prevent set or regional settings from interfering with 
-- interpretation of dates / literals

SET DATEFIRST 7;
SET DATEFORMAT dmy;
SET LANGUAGE US_ENGLISH;

DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate);

-- this is just a holding table for intermediate calculations:
--DROP TABLE #dim

CREATE TABLE #dim
(
  [date]       DATE PRIMARY KEY, 
  [day]        AS DATEPART(DAY,      [date]),
  [month]      AS DATEPART(MONTH,    [date]),
  FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0)),
  [MonthName]  AS DATENAME(MONTH,    [date]),
  [week]       AS DATEPART(WEEK,     [date]),
  [ISOweek]    AS DATEPART(ISO_WEEK, [date]),
  [DayOfWeek]  AS DATEPART(WEEKDAY,  [date]),
  [quarter]    AS DATEPART(QUARTER,  [date]),
  [year]       AS DATEPART(YEAR,     [date]),
  FirstOfYear  AS CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR,  0, [date]), 0)),
  Style112     AS CONVERT(CHAR(8),   [date], 112),
  Style101     AS CONVERT(CHAR(10),  [date], 101)
);

-- use the catalog views to generate as many rows as we need

INSERT #dim([date]) 
SELECT d
FROM
(
  SELECT d = DATEADD(DAY, rn - 1, @StartDate)
  FROM 
  (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate)) 
      rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    -- on my system this would support > 5 million days
    ORDER BY s1.[object_id]
  ) AS x
) AS y;

drop table UTIL.Calendar;

CREATE TABLE UTIL.Calendar
(
  DateKey				INT         NOT NULL PRIMARY KEY,
  [Date]				DATE        NOT NULL,
  [Day]					TINYINT     NOT NULL,
  DaySuffix				CHAR(2)     NOT NULL,
  [Weekday]				TINYINT     NOT NULL,
  WeekDayName			VARCHAR(10) NOT NULL,
  IsWeekend				BIT         NOT NULL,
  [DayOfYear]			SMALLINT    NOT NULL,
  WeekOfMonth			TINYINT     NOT NULL,
  WeekOfYear			TINYINT     NOT NULL,
  [Month]				TINYINT     NOT NULL,
  [MonthID]             VARCHAR(10) NOT NULL,
  [MonthName]			VARCHAR(10) NOT NULL,
  ShortMonthYearName	VARCHAR(10) NOT NULL,
  [Quarter]				TINYINT     NOT NULL,
  QuarterName			VARCHAR(6)  NOT NULL,
  HalfYearName			VARCHAR(6)	NOT NULL,
  [Year]				INT         NOT NULL,
  FirstDayOfWeek		DATE		NOT NULL,
  FirstDayOfMonth		DATE        NOT NULL,
  LastDayOfMonth		DATE        NOT NULL,
  FirstDayOfQuarter		DATE        NOT NULL,
  LastDayOfQuarter		DATE        NOT NULL,
  FirstDayOfYear		DATE        NOT NULL,
  LastDayOfYear			DATE        NOT NULL,
  FiscalYear			INT			NOT NULL,
  FiscalName			VARCHAR(6)	NOT NULL,
  FiscalQuarterName		VARCHAR(6)  NOT NULL,
  FiscalHalfYearName	VARCHAR(6)	NOT NULL,
  FiscalStartDate		DATE        NOT NULL,
  FiscalEndDate			DATE        NOT NULL,
  FiscalMonth			TINYINT     NOT NULL,
  FiscalMonthName		VARCHAR(10) NOT NULL,
);


INSERT UTIL.Calendar WITH (TABLOCKX)
SELECT
  DateKey					=	CONVERT(INT, Style112),
  [Date]					=	[date],
  [Day]						=	CONVERT(TINYINT, [day]),
  DaySuffix					=	CONVERT(CHAR(2), CASE WHEN [day] / 10 = 1 THEN 'th' ELSE 
								  CASE RIGHT([day], 1) WHEN '1' THEN 'st' WHEN '2' THEN 'nd' 
								  WHEN '3' THEN 'rd' ELSE 'th' END END),
  [Weekday]					=	CONVERT(TINYINT, [DayOfWeek]),
  [WeekDayName]				=	CONVERT(VARCHAR(10), DATENAME(WEEKDAY, [date])),
  [IsWeekend]				=	CONVERT(BIT, CASE WHEN [DayOfWeek] IN (1,7) THEN 1 ELSE 0 END),
  [DayOfYear]				=	CONVERT(SMALLINT, DATEPART(DAYOFYEAR, [date])),
  WeekOfMonth				=	CONVERT(TINYINT, DENSE_RANK() OVER (PARTITION BY [year], [month] ORDER BY [week])),
  WeekOfYear				=	CONVERT(TINYINT, [week]),
  [Month]					=	CONVERT(TINYINT, [month]),
  MONTHID					=	CONVERT(VARCHAR, YEAR) + RIGHT('0' + CONVERT(VARCHAR, [month]), 2),
  [MonthName]				=	CONVERT(VARCHAR(10), [MonthName]),
  ShortMonthYearName		=	CAST([YEAR] AS CHAR(4)) + '-' + LEFT([MonthName], 3),
  [Quarter]					=	CONVERT(TINYINT, [quarter]),
  QuarterName				=	'Q' + CONVERT(varchar, [quarter]), 
  HalfYearName				=	'H' + CASE WHEN [quarter] IN (1, 2) then '1' else '2' end,
  [Year]					=	[year],
  FirstDayOfWeek			=	DATEADD(DAY, 1-DATEPART(WEEKDAY, [date]), [date]),
  FirstDayOfMonth			=	FirstOfMonth,
  LastDayOfMonth			=	MAX([date]) OVER (PARTITION BY [year], [month]),
  FirstDayOfQuarter			=	MIN([date]) OVER (PARTITION BY [year], [quarter]),
  LastDayOfQuarter			=	MAX([date]) OVER (PARTITION BY [year], [quarter]),
  FirstDayOfYear			=	FirstOfYear,
  LastDayOfYear				=	MAX([date]) OVER (PARTITION BY [year]),
  FiscalYear				=	CASE WHEN [quarter] in (1,2) then [year] else [year] + 1 end,
  FiscalName				=	'FY' + right(convert(varchar, CASE WHEN [quarter] in (1,2) then [year] else [year] + 1 end), 2),
  FiscalQuarterName			=	'Q' + CONVERT(VARCHAR, CASE WHEN [quarter] = 1 then 3 WHEN [quarter] = 2 then 4 WHEN [quarter] = 3 then 1 else 2 end), 
  FiscalHalfYearName		=	'H' + CASE WHEN [quarter] IN (1, 2) then '2' else '1' end,
--  FiscalStartDate			=	DATEFROMPARTS(CASE WHEN [quarter] in (1,2) then [year]-1 else [year] end, 7,1),
  FiscalStartDate			=	CONVERT(DATE, CONVERT(VARCHAR, (CASE WHEN [quarter] in (1,2) then [year]-1 else [year] end)) + 'JULY 01'),
--  FiscalEndDate				=	DATEFROMPARTS(CASE WHEN [quarter] in (1,2) then [year] else [year] + 1 end, 6,30),
  FiscalEndDate				=	CONVERT(DATE, CONVERT(VARCHAR, (CASE WHEN [quarter] in (1,2) then [year] else [year] + 1 end)) + 'JUNE 30'),
  FiscalMonth				=	CASE WHEN [quarter] in (1,2) then [month] + 6 else [month] - 6 end,
  FiscalMonthName			=	CONVERT(VARCHAR(10), [MonthName])
FROM #dim
OPTION (MAXDOP 1);
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************
Name : spFinishPipelineExecution
Created by : Rahul Agrawal (Velrada)
Created on : 13-Mar-2018
Description : The SP logs the completion of Pipeline Execution. The default ExecutionStatus is FINISHED. 
Please pass the ExecutionStatus as ERROR/SUCCEEDED from the calling program
*******************************************************************
Change log
Please maintain the change log in the below section.
Updated On | Updated By | Update Details
(1)
(2)
*******************************************************************/
CREATE PROCEDURE [UTIL].[spPipelineExecutionFinish]
(
  @RunID                    nvarchar(250),
  @ExecutionStatus          nvarchar(100) = 'FINISHED'
)
AS
BEGIN
	SET NOCOUNT ON
   
	UPDATE PipelineExecution 
	SET 
		ExecutionStatus	= @ExecutionStatus,
		EndTime	= GETUTCDate()
	WHERE RunID = @RunID

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************
Name : spInitiatePipelineExecution
Created by : Rahul Agrawal (Velrada)
Created on : 13-Mar-2018
Description : The SP logs the StartTime for each Pipeline execution
*******************************************************************
Change log
Please maintain the change log in the below section.
Updated On | Updated By | Update Details
(1)
(2)
*******************************************************************/
CREATE PROCEDURE [UTIL].[spPipelineExecutionInitiate]
(
  @DataFactoryName          nvarchar(100),
  @PipelineName             nvarchar(100),
  @RunID                    nvarchar(250),
  @Message		            nvarchar(1000) = ''
)
AS
BEGIN
    SET NOCOUNT ON

   INSERT INTO UTIL.PipelineExecution
   (
      [DataFactoryName]
      ,[PipelineName]
      ,[RunID]
      ,[StartTime]
	  ,[ExecutionStatus]
      ,[Message]
   )
   VALUES
   (
	  @DataFactoryName       
	  ,@PipelineName  
	  ,@RunID    
	  ,GETUTCDate()
	  ,'STARTED'
	  ,@Message            
   )

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************
Name : spUpdateLastExtraction
Created by : Rahul Agrawal (Velrada)
Created on : 13-Mar-2018
Description : The SP is used to update the last extraction time for each table from Source System
*******************************************************************
Change log
Please maintain the change log in the below section.
Updated On | Updated By | Update Details
(1)
(2)
*******************************************************************/
CREATE PROCEDURE [UTIL].[spUpdateLastExtraction]
(
	@RecordID				uniqueidentifier
	,@LastExtractionTime	datetime
	,@LastExtractionCounter	bigint
)
AS
BEGIN
	SET NOCOUNT ON

--DECLARE @ThisSPName VARCHAR(200) = OBJECT_SCHEMA_NAME(@@PROCID) +'.'+ OBJECT_NAME(@@PROCID)
/*
--EXEC [UTIL].[spUpdateLastExtraction] 'cebde7a4-8f68-40f4-9c2d-0ea49f6cd981', '1900-01-01', 0
DECLARE @RecordID uniqueidentifier
DECLARE @LastExtractionTime datetime
declare @LastExtractionCounter bigint

SET @RecordID = NewID()
SET @LastExtractionTime = GETDATE()
SET @LastExtractionCounter = 0
*/

MERGE INTO [UTIL].[DataLoadMetaData_LastExtraction] AS TARGET
USING (SELECT @RecordID AS RecordID) SOURCE
ON (SOURCE.RecordID = TARGET.RecordID)

WHEN NOT MATCHED BY TARGET THEN 
	INSERT (RecordID, LastExtractionTime, LastExtractionCounter)
	VALUES (@RecordID, @LastExtractionTime, @LastExtractionCounter)
WHEN MATCHED THEN 
	UPDATE 
	SET	LastExtractionTime = @LastExtractionTime
	,LastExtractionCounter = @LastExtractionCounter;


END
GO
