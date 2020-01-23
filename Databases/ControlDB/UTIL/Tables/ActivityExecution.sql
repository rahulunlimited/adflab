CREATE TABLE [UTIL].[ActivityExecution] (
    [ActivityExecutionID] INT             IDENTITY (1, 1) NOT NULL,
    [ActivityType]        NVARCHAR (100)  NOT NULL,
    [ActivityName]        NVARCHAR (100)  NOT NULL,
    [LogTime]             DATETIME        CONSTRAINT [DF_ActivityExecutionCreatedDateTime] DEFAULT (getutcdate()) NOT NULL,
    [MessageHeader]       NVARCHAR (250)  NOT NULL,
    [MessageDescription]  NVARCHAR (1000) NOT NULL,
    CONSTRAINT [PK_ActivityExecutionID] PRIMARY KEY CLUSTERED ([ActivityExecutionID] ASC)
);

