CREATE USER [rahul.agrawal@velrada.com] FROM EXTERNAL PROVIDER
GRANT SELECT, CONNECT TO [rahul.agrawal@velrada.com]

CREATE USER [lee.moran@velrada.com] FROM EXTERNAL PROVIDER
GRANT SELECT, CONNECT TO [lee.moran@velrada.com]
GO

EXECUTE AS USER = 'lee.moran@velrada.com'

SELECT SP.StateProvinceCode, COUNT(*)
FROM STG.Sales_Invoices I
INNER JOIN dbo.Customers C ON I.CustomerID = C.CustomerSourceID
INNER JOIN dbo.City CT ON C.PostalCityID = CT.CitySourceID
INNER JOIN dbo.StateProvince SP ON SP.StateProvinceKey = CT.StateProvinceKey
GROUP BY SP.StateProvinceCode

REVERT
