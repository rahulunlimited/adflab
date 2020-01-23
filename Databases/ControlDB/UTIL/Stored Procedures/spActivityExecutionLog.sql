

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
