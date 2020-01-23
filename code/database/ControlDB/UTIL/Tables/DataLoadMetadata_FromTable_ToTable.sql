CREATE TABLE [UTIL].[DataLoadMetadata_FromTable_ToTable] (
    [RecordID]                  UNIQUEIDENTIFIER CONSTRAINT [Util_DataLoadMetadata_FromTable_ToTable_DF_RecordID] DEFAULT (newid()) NULL,
    [SourceSystem]              NVARCHAR (100)   NOT NULL,
    [SourceDatabase]            NVARCHAR (100)   NULL,
    [SourceSchema]              NVARCHAR (100)   NULL,
    [SourceTable]               NVARCHAR (100)   NOT NULL,
    [SourceSQL]                 NVARCHAR (MAX)   NULL,
    [TargetSchema]              NVARCHAR (100)   NULL,
    [TargetTable]               NVARCHAR (100)   NULL,
    [ExtractionFlag]            BIT              CONSTRAINT [Util_DataLoadMetadata_FromTable_ToTable_DF_ExtractionFlag] DEFAULT ((1)) NULL,
    [TransformationSP]          NVARCHAR (250)   NULL,
    [IncrementalLoadFlag]       BIT              CONSTRAINT [Util_DataLoadMetadata_FromTable_ToTable_DF_IncrementalLoadFlag] DEFAULT ((0)) NULL,
    [IncrementalLoadColumn]     NVARCHAR (100)   NULL,
    [IncrementalLoadColumnType] NVARCHAR (100)   NULL
);

