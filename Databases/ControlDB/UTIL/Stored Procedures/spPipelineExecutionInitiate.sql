
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
