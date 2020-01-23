
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
