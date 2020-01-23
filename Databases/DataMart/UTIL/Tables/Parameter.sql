CREATE TABLE [UTIL].[Parameter] (
    [ParameterName]        VARCHAR (50)  NOT NULL,
    [ParameterValue]       VARCHAR (50)  NOT NULL,
    [ParameterDescription] VARCHAR (100) NULL,
    [Active]               BIT           NULL,
    [DateCreated]          DATE          NULL,
    CONSTRAINT [PK_UtilParameter] PRIMARY KEY CLUSTERED ([ParameterName] ASC, [ParameterValue] ASC)
);

