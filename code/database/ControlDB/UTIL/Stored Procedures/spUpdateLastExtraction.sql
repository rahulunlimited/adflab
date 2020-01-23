

/*******************************************************************
Name : spUpdateLastExtraction
Created by : Rahul Agrawal (Velrada)
Created on : 13-Mar-2018
Description : The SP is used to update the last extraction time for each table from Source System
*******************************************************************
Change log
Please maintain the change log in the below section.
Updated On | Updated By | Update Details
(1)
(2)
*******************************************************************/
CREATE PROCEDURE [UTIL].[spUpdateLastExtraction]
(
	@RecordID				uniqueidentifier
	,@LastExtractionTime	datetime
	,@LastExtractionCounter	bigint
)
AS
BEGIN
	SET NOCOUNT ON

--DECLARE @ThisSPName VARCHAR(200) = OBJECT_SCHEMA_NAME(@@PROCID) +'.'+ OBJECT_NAME(@@PROCID)
/*
--EXEC [UTIL].[spUpdateLastExtraction] 'cebde7a4-8f68-40f4-9c2d-0ea49f6cd981', '1900-01-01', 0
DECLARE @RecordID uniqueidentifier
DECLARE @LastExtractionTime datetime
declare @LastExtractionCounter bigint

SET @RecordID = NewID()
SET @LastExtractionTime = GETDATE()
SET @LastExtractionCounter = 0
*/

MERGE INTO [UTIL].[DataLoadMetaData_LastExtraction] AS TARGET
USING (SELECT @RecordID AS RecordID) SOURCE
ON (SOURCE.RecordID = TARGET.RecordID)

WHEN NOT MATCHED BY TARGET THEN 
	INSERT (RecordID, LastExtractionTime, LastExtractionCounter)
	VALUES (@RecordID, @LastExtractionTime, @LastExtractionCounter)
WHEN MATCHED THEN 
	UPDATE 
	SET	LastExtractionTime = @LastExtractionTime
	,LastExtractionCounter = @LastExtractionCounter;


END
