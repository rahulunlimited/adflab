DELETE FROM dbo.City
DELETE FROM [dbo].[Country]
DELETE FROM [dbo].[Customer]
DELETE FROM [dbo].[People]
DELETE FROM [dbo].[StateProvince]
DELETE FROM [STG].[Application_Cities]
DELETE FROM [STG].[Application_Cities_NY]
DELETE FROM [STG].[Application_Countries]
DELETE FROM [STG].[Application_DeliveryMethods]
DELETE FROM [STG].[Application_PaymentMethods]
DELETE FROM [STG].[Application_People]
DELETE FROM [STG].[Application_StateProvinces]
DELETE FROM [STG].[CSV_AusState]
DELETE FROM [STG].[HumanResources_Department]
DELETE FROM [STG].[Production_WorkOrder]
DELETE FROM [STG].[Sales_Customers]
DELETE FROM [STG].[Sales_Invoices]

DELETE FROM [UTIL].[PipelineExecution]
DELETE FROM [UTIL].[ActivityExecution]

UPDATE UTIL.DataLoadMetaData_LastExtraction SET LastExtractionCounter = 0, LastExtractionTime = '1900-01-01'

