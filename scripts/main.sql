CREATE DATABASE MyFirstDb
GO
USE MyFirstDb
GO
CREATE TABLE MyTable(
    id INT IDENTITY(1,1),
    name VARCHAR(256) NOT NULL
)
GO
INSERT INTO MyTable(name) VALUES ('Test name 123')
GO
SELECT * FROM MyTable;
GO
USE master;
GO
EXEC sp_detach_db @dbname = 'MyFirstDb'
GO
EXEC sp_attach_db @dbname = 'MyFirstDb', @filename1 = '/var/opt/mssql/data/MyFirstDb.mdf'
GO
USE MyFirstDb
GO
BACKUP DATABASE MyFirstDb TO DISK = '/var/opt/mssql/data/MyFirstDb.bak'
GO
USE master;
DROP DATABASE MyFirstDb;
RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/data/MyFirstDb.bak';
RESTORE DATABASE MyFirstDb
    FROM DISK = '/var/opt/mssql/data/MyFirstDb.bak'
    WITH MOVE 'MyFirstDb' TO '/var/opt/mssql/data/MyFirstDb.mdf',
    MOVE 'MyFirstDb_log' TO '/var/opt/mssql/data/MyFirstDb_log.ldf'
GO
USE MyFirstDb;
SELECT * FROM MyTable;