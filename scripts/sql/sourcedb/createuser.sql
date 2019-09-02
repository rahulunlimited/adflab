
#Connect Master
CREATE LOGIN redreader WITH PASSWORD = ''
CREATE USER redreader FROM LOGIN redreader WITH DEFAULT_SCHEMA = dbo

#Connect Database
CREATE USER redreader FROM LOGIN redreader WITH DEFAULT_SCHEMA = dbo
GRANT CONNECT, SELECT TO redreader
EXEC sp_addrolemember 'db_datareader', 'redreader'
