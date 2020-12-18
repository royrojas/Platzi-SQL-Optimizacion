-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 29 - Querys de monitoreo 2
------------------------------------------------------

-- Objetos en modificarse
---------------------------------
-- ultimos objetos en modificarse
SELECT name
FROM sys.objects
WHERE type = 'P'
AND DATEDIFF(D,modify_date, GETDATE()) < 7
----Change 7 to any other day value

SELECT name, modify_date, create_date
FROM sys.objects
WHERE type = 'P'
AND DATEDIFF(D,modify_date, GETDATE()) < 7

-- muestra el script que muestra la fecha de creación y modificación de cualquier procedimiento almacenado específico en SQL Server.
USE AdventureWorks;
GO
SELECT name, create_date, modify_date
FROM sys.objects
WHERE type = 'P' -- P = procedimiento almacenado
AND name = 'nombre del objeto'
---------------------------------


-- enumerar todos los desencadenadores DML creados o modificados en los últimos N días en SQL Server.
SELECT
o.name as [Trigger Name],
CASE WHEN o.type = 'TR' THEN 'SQL DML Trigger'
     WHEN o.type = 'TA' THEN 'DML Assembly Trigger' END
     AS [Trigger Type],
sc.name AS [Schema_Name],
OBJECT_NAME(parent_object_id) as [Table Name],
o.create_date [Trigger Create Date], 
o.modify_date [Trigger Modified Date] 
FROM sys.objects o
INNER JOIN sys.schemas sc ON o.schema_id = sc.schema_id
WHERE (type = 'TR' OR type = 'TA')
AND ( DATEDIFF(D,create_date, GETDATE()) < 7 OR
    DATEDIFF(D,modify_date, GETDATE()) < 7) -- Last 7 days


-- reconstruye indices
	GO
EXEC sp_MSforeachtable @command1="print '?' DBCC DBREINDEX ('?', ' ', 80)"
GO
EXEC sp_updatestats


-- ver avances de procesos
SELECT session_id as SPID, command, a.text AS Query, start_time, 
percent_complete, dateadd(second,estimated_completion_time/1000, 
getdate()) as estimated_completion_time 
FROM sys.dm_exec_requests r CROSS APPLY 
     sys.dm_exec_sql_text(r.sql_handle) a 
WHERE r.command in ('BACKUP DATABASE','RESTORE DATABASE',
                    'BACKUP LOG','DbccFilesCompact',
                    'DbccSpaceReclaim','DBCC')


-- espacio usado en una base de datos
sp_spaceused

select db_name() as dbname,
name as filename,
size/128.0 as currentsize,
size/128.0 - cast(fileproperty(name,'SpaceUsed') as int)/128.0 as freespace
from sys.database_files

