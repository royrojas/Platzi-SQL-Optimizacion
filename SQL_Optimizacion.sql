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

GO

UPDATE Usuario
SET Nombre = 'Roy Rojas Rojas'
WHERE UsuarioID = 1

GO

SELECT * FROM Usuario
  FOR SYSTEM_TIME
    BETWEEN '2020-01-01 00:00:00.0000000' AND '2021-01-01 00:00:00.0000000'
      WHERE UsuarioID = 1 ORDER BY ValidFrom;

-- Para borrar las tablas versionadas

ALTER TABLE [dbo].[Usuario] SET ( SYSTEM_VERSIONING = OFF  )
GO

DROP TABLE [dbo].[Usuario]
GO

DROP TABLE [dbo].[UsuarioHistory]
GO

