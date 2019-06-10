CREATE SCHEMA Security AUTHORIZATION dbo

CREATE TABLE Security.StateAccess (
StateCode NVARCHAR(50),
UserName NVARCHAR(100),
Valid bit)
GO


DELETE FROM Security.StateAccess WHERE UserName = 'rahul.agrawal@velrada.com'
INSERT INTO Security.StateAccess (StateCode, UserName, Valid) VALUES ('AK', 'rahul.agrawal@velrada.com', 1)
INSERT INTO Security.StateAccess (StateCode, UserName, Valid) VALUES ('CA', 'rahul.agrawal@velrada.com', 1)
INSERT INTO Security.StateAccess (StateCode, UserName, Valid) VALUES ('FL', 'rahul.agrawal@velrada.com', 1)

INSERT INTO Security.StateAccess (StateCode, UserName, Valid) VALUES ('CO', 'lee.moran@velrada.com', 1)
INSERT INTO Security.StateAccess (StateCode, UserName, Valid) VALUES ('CT', 'lee.moran@velrada.com', 1)
INSERT INTO Security.StateAccess (StateCode, UserName, Valid) VALUES ('DC', 'lee.moran@velrada.com', 1)
GO

CREATE OR ALTER FUNCTION Security.fnStateProvinceSecurityPredicate(@CustomerID as INT)
	RETURNS TABLE
WITH SCHEMABINDING
AS
	RETURN 
	SELECT 1 AS SecurityResult
	FROM Security.StateAccess SA
	INNER JOIN dbo.StateProvince SP ON SA.StateCode = SP.StateProvinceCode
	INNER JOIN dbo.City CT ON SP.StateProvinceKey = CT.StateProvinceKey
	INNER JOIN dbo.Customers C ON C.PostalCityID = CT.CitySourceId
	WHERE SA.Valid = 1
	AND (C.CustomerSourceID = @CustomerID AND SA.UserName = USER_NAME())
	OR USER_NAME() = 'dbo'
	;
GO

CREATE SECURITY POLICY SalesInvoiceFilter
ADD FILTER PREDICATE Security.fnStateProvinceSecurityPredicate(CustomerID)
ON STG.Sales_Invoices
WITH (STATE = ON)

CREATE USER [rahul.agrawal@velrada.com] FROM EXTERNAL PROVIDER
GRANT SELECT, CONNECT TO [rahul.agrawal@velrada.com]

CREATE USER [lee.moran@velrada.com] FROM EXTERNAL PROVIDER
GRANT SELECT, CONNECT TO [lee.moran@velrada.com]


EXECUTE AS USER = 'lee.moran@velrada.com'

SELECT SP.StateProvinceCode, COUNT(*)
FROM STG.Sales_Invoices I
INNER JOIN dbo.Customers C ON I.CustomerID = C.CustomerSourceID
INNER JOIN dbo.City CT ON C.PostalCityID = CT.CitySourceID
INNER JOIN dbo.StateProvince SP ON SP.StateProvinceKey = CT.StateProvinceKey
GROUP BY SP.StateProvinceCode

REVERT
