CREATE TABLE [UTIL].[DataLoadMetadata_FromFile_ToTable] (
    [RecordID]         UNIQUEIDENTIFIER CONSTRAINT [Util_DataLoadMetadata_FromFile_ToTable_DF_RecordID] DEFAULT (newid()) NULL,
    [SourceSystem]     NVARCHAR (100)   NOT NULL,
    [SourceFile]       NVARCHAR (100)   NOT NULL,
    [TargetSchema]     NVARCHAR (100)   NULL,
    [TargetTable]      NVARCHAR (100)   NULL,
    [ExtractionFlag]   BIT              CONSTRAINT [Util_DataLoadMetadata_FromFile_ToTable_DF_ExtractionFlag] DEFAULT ((1)) NULL,
    [TransformationSP] NVARCHAR (250)   NULL,
    [SourceFolder]     VARCHAR (500)    NULL,
    [ArchiveFolder]    VARCHAR (500)    NULL,
    [ColumnDelimiter]  VARCHAR (10)     NULL,
    [RowDelimiter]     VARCHAR (10)     NULL,
    [FirstRowHeader]   BIT              NULL,
    [PrefixDateTime]   BIT              NULL
);

