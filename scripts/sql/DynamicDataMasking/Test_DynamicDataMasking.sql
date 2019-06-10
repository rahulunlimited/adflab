CREATE USER TestMask WITHOUT LOGIN;  
GRANT SELECT ON dbo.People TO TestMask;

EXECUTE AS User = 'TestMask'
SELECT * from dbo.People
REVERT
