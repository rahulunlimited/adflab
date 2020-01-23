CREATE TABLE [UTIL].[PipelineExecution] (
    [PipelineExecutionID] INT            IDENTITY (1, 1) NOT NULL,
    [DataFactoryName]     NVARCHAR (100) NOT NULL,
    [PipelineName]        NVARCHAR (100) NOT NULL,
    [RunID]               NVARCHAR (250) NOT NULL,
    [StartTime]           DATETIME       NOT NULL,
    [EndTime]             DATETIME       NULL,
    [ExecutionStatus]     NVARCHAR (100) NULL,
    [Message]             NVARCHAR (250) NOT NULL,
    [CreatedDateTime]     DATETIME       CONSTRAINT [Util_PipelineExecution_DF_PipelineExecutionCreatedDateTime] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_PipelineExecutionID] PRIMARY KEY CLUSTERED ([PipelineExecutionID] ASC)
);

