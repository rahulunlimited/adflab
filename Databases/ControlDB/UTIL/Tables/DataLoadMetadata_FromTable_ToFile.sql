CREATE TABLE [UTIL].[DataLoadMetadata_FromTable_ToFile] (
    [RecordID]                  UNIQUEIDENTIFIER CONSTRAINT [Util_DataLoadMetadata_FromFile_ToFile_DF_RecordID] DEFAULT (newid()) NULL,
    [SourceSystem]              NVARCHAR (100)   NOT NULL,
    [SourceDatabase]            NVARCHAR (100)   NULL,
    [SourceSchema]              NVARCHAR (100)   NULL,
    [SourceTable]               NVARCHAR (100)   NOT NULL,
    [SourceSQL]                 NVARCHAR (MAX)   NULL,
    [TargetSystem]              NVARCHAR (100)   NOT NULL,
    [TargetFolder]              VARCHAR (500)    NULL,
    [TargetFilePrefix]          NVARCHAR (100)   NULL,
    [ExtractionFlag]            BIT              CONSTRAINT [Util_DataLoadMetadata_FromFile_ToFile_DF_ExtractionFlag] DEFAULT ((1)) NULL,
    [IncrementalLoadFlag]       BIT              CONSTRAINT [Util_DataLoadMetadata_FromFile_ToFile_DF_IncrementalLoadFlag] DEFAULT ((0)) NULL,
    [IncrementalLoadColumn]     NVARCHAR (100)   NULL,
    [IncrementalLoadColumnType] NVARCHAR (100)   NULL,
    [ColumnDelimiter]           VARCHAR (10)     NULL,
    [RowDelimiter]              VARCHAR (10)     NULL
);

