-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 28 - Querys de monitoreo
------------------------------------------------------


-- Muestra el estado de las consultas y procesos en el servidor
-- se va a servir para ver si hay bloqueos o cual usuario ejecuta X proceso
CREATE PROCEDURE [dbo].[sp_who3]
(
    @SessionID int = NULL
)
AS
BEGIN
SELECT
    SPID                = er.session_id
    ,Status             = ses.status
    ,[Login]            = ses.login_name
    ,Host               = ses.host_name
    ,BlkBy              = er.blocking_session_id
    ,DBName             = DB_Name(er.database_id)
    ,CommandType        = er.command
    ,SQLStatement       =
        SUBSTRING
        (
            qt.text,
            er.statement_start_offset/2,
            (CASE WHEN er.statement_end_offset = -1
                THEN LEN(CONVERT(nvarchar(MAX), qt.text)) * 2
                ELSE er.statement_end_offset
                END - er.statement_start_offset)/2
        )
    ,ObjectName         = OBJECT_SCHEMA_NAME(qt.objectid,dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid)
    ,ElapsedMS          = er.total_elapsed_time
    ,CPUTime            = er.cpu_time
    ,IOReads            = er.logical_reads + er.reads
    ,IOWrites           = er.writes
    ,LastWaitType       = er.last_wait_type
    ,StartTime          = er.start_time
    ,Protocol           = con.net_transport
    ,transaction_isolation =
        CASE ses.transaction_isolation_level
            WHEN 0 THEN 'Unspecified'
            WHEN 1 THEN 'Read Uncommitted'
            WHEN 2 THEN 'Read Committed'
            WHEN 3 THEN 'Repeatable'
            WHEN 4 THEN 'Serializable'
            WHEN 5 THEN 'Snapshot'
        END
    ,ConnectionWrites   = con.num_writes
    ,ConnectionReads    = con.num_reads
    ,ClientAddress      = con.client_net_address
    ,Authentication     = con.auth_scheme
FROM sys.dm_exec_requests er
LEFT JOIN sys.dm_exec_sessions ses
ON ses.session_id = er.session_id
LEFT JOIN sys.dm_exec_connections con
ON con.session_id = ses.session_id
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) as qt
WHERE @SessionID IS NULL OR er.session_id = @SessionID
AND er.session_id > 50
ORDER BY
    er.blocking_session_id DESC
    ,er.session_id
 
END


GO


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
WHERE type = 'P'
AND name = 'uspUpdateEmployeeHireInfo'

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
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a 
WHERE r.command in ('BACKUP DATABASE','RESTORE DATABASE','BACKUP LOG','DbccFilesCompact','DbccSpaceReclaim','DBCC')


-- espacio usado en una base de datos
sp_spaceused

select db_name() as dbname,
name as filename,
size/128.0 as currentsize,
size/128.0 - cast(fileproperty(name,'SpaceUsed') as int)/128.0 as freespace
from sys.database_files

