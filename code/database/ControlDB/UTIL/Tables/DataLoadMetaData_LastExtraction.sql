CREATE TABLE [UTIL].[DataLoadMetaData_LastExtraction] (
    [RecordID]              UNIQUEIDENTIFIER NOT NULL,
    [LastExtractionTime]    DATETIME         NULL,
    [LastExtractionCounter] INT              NULL, 
    CONSTRAINT [PK_DataLoadMetaData_LastExtraction] PRIMARY KEY ([RecordID])
);

