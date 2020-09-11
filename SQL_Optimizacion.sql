-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 16 - Tablas Versionadas

USE PlatziSQL

GO

CREATE TABLE Usuario
(
  [UsuarioID] int NOT NULL PRIMARY KEY CLUSTERED
  , Nombre nvarchar(100) NOT NULL
  , Twitter varchar(100) NOT NULL
  , Web varchar(100) NOT NULL
  , ValidFrom datetime2 GENERATED ALWAYS AS ROW START
  , ValidTo datetime2 GENERATED ALWAYS AS ROW END
  , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.UsuarioHistory));

GO

INSERT INTO [dbo].[Usuario]
           ([UsuarioID]
           ,[Nombre]
           ,[Twitter]
           ,[Web])
     VALUES
           (1
           ,'Roy Rojas'
           ,'@royrojasdev'
           ,'www.dotnetcr.com')

INSERT INTO [dbo].[Usuario]
           ([UsuarioID]
           ,[Nombre]
           ,[Twitter]
           ,[Web])
     VALUES
           (2
           ,'Bill Gates'
           ,'@billgates'
           ,'www.microsoft.com.com')

GO

UPDATE Usuario
SET Nombre = 'Roy Rojas Rojas'
WHERE UsuarioID = 1

GO

-- Consultas a los datos historicos

-- Consulta todos los cambios por rango de fechas
SELECT * FROM Usuario
  FOR SYSTEM_TIME
    BETWEEN '2020-01-01 00:00:00.0000000' AND '2021-01-01 00:00:00.0000000'
  ORDER BY ValidFrom;

GO

-- Consulta un usuario por rango de fechas
SELECT * FROM Usuario
  FOR SYSTEM_TIME
    BETWEEN '2020-01-01 00:00:00.0000000' AND '2021-01-01 00:00:00.0000000'
      WHERE UsuarioID = 1 ORDER BY ValidFrom;

GO

-- Consulta un usuario por ID
SELECT * FROM Usuario
    FOR SYSTEM_TIME ALL WHERE
        UsuarioID = 2 ORDER BY ValidFrom;


-- Para borrar las tablas versionadas

ALTER TABLE [dbo].[Usuario] SET ( SYSTEM_VERSIONING = OFF  )
GO

DROP TABLE [dbo].[Usuario]
GO

DROP TABLE [dbo].[UsuarioHistory]
GO


-- Crear tabla versionada para tablas ya existentes

CREATE TABLE Usuario2
(
  [UsuarioID] int NOT NULL PRIMARY KEY CLUSTERED
  , Nombre nvarchar(100) NOT NULL
  , Twitter varchar(100) NOT NULL
  , Web varchar(100) NOT NULL
 )

 GO

ALTER TABLE Usuario2
ADD
    ValidFrom datetime2 (2) GENERATED ALWAYS AS ROW START HIDDEN
        constraint DF_ValidFrom DEFAULT DATEADD(second, -1, SYSUTCDATETIME())  
    , ValidTo datetime2 (2) GENERATED ALWAYS AS ROW END HIDDEN
        constraint DF_ValidTo DEFAULT '9999.12.31 23:59:59.99'
    , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);

ALTER TABLE Usuario2
    SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Usuario2_History));