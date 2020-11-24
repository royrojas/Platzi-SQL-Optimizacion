-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 13 - Trigger B - Administracion de SQL
------------------------------------------------------

-- trigger para creacion de tablas

CREATE OR ALTER TRIGGER safety   
ON DATABASE   
FOR DROP_TABLE, ALTER_TABLE   
AS   
   PRINT 'No es permitido modificar la estructura de las tablas, comuníquese con el DBA.'   
   ROLLBACK;  


ALTER TABLE UsuarioTarget
ALTER COLUMN Nombre VARCHAR(100)

DROP TABLE UsuarioTarget


-----------------------------------

-- trigger para cracion de base de datos.GO


CREATE TRIGGER ddl_trig_database   
ON ALL SERVER   
FOR CREATE_DATABASE   
AS   
    PRINT 'Base de datos NO creada.'  
	ROLLBACK; 
GO  
DROP TRIGGER ddl_trig_database  
ON ALL SERVER;  



CREATE DATABASE [prueba]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'prueba', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019DEV\MSSQL\DATA\prueba.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'prueba_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019DEV\MSSQL\DATA\prueba_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
