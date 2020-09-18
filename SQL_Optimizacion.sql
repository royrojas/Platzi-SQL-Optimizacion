-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 10 - Merge 01

USE PlatziSQL

GO

CREATE TABLE UsuarioTarget
(
Codigo INT PRIMARY KEY,
Nombre VARCHAR(100),
Puntos INT
) 
GO
INSERT INTO UsuarioTarget VALUES
(1,'Juan Perez',10),
(2,'Marco Salgado',5),
(3,'Carlos Soto',9),
(4,'Alberto Ruiz',12),
(5,'Alejandro Castro',5)
GO
CREATE TABLE UsuarioSource
(
Codigo INT PRIMARY KEY,
Nombre VARCHAR(100),
Puntos INT
) 
GO
INSERT INTO UsuarioSource VALUES
(1,'Juan Perez',12),
(2,'Marco Salgado',11),
(4,'Alberto Ruiz Castro',4),
(5,'Alejandro Castro',5),
(6,'Pablo Ramos',8)
 
GO

SELECT * FROM UsuarioTarget
SELECT * FROM UsuarioSource

GO

--Sincronizar la tabla TARGET con
--los datos actuales de la tabla SOURCE
MERGE UsuarioTarget AS TARGET
USING UsuarioSource AS SOURCE 
   ON (TARGET.Codigo = SOURCE.Codigo) 
--Cuandos los registros concuerdan por la llave
--se actualizan los registros si tienen alguna variación
 WHEN MATCHED AND (TARGET.Nombre <> SOURCE.Nombre 
			    OR TARGET.Puntos <> SOURCE.Puntos) THEN 
   UPDATE SET TARGET.Nombre = SOURCE.Nombre, 
              TARGET.Puntos = SOURCE.Puntos 
--Cuando los registros no concuerdan por la llave
--indica que es un dato nuevo, se inserta el registro
--en la tabla TARGET proveniente de la tabla SOURCE
 WHEN NOT MATCHED BY TARGET THEN 
   INSERT (Codigo, Nombre, Puntos) 
   VALUES (SOURCE.Codigo, SOURCE.Nombre, SOURCE.Puntos)
--Cuando el registro existe en TARGET y no existe en SOURCE
--se borra el registro en TARGET
 WHEN NOT MATCHED BY SOURCE THEN 
   DELETE
 
--Seccion opcional e informativa
--$action indica el tipo de accion
--en OUTPUT retorna cualquiera de las 3 acciones 
--'INSERT', 'UPDATE', or 'DELETE', 
OUTPUT $action, 
DELETED.Codigo AS TargetCodigo, 
DELETED.Nombre AS TargetNombre, 
DELETED.Puntos AS TargetPuntos, 
INSERTED.Codigo AS SourceCodigo, 
INSERTED.Nombre AS SourceNombre, 
INSERTED.Puntos AS SourcePuntos; 
SELECT @@ROWCOUNT;
GO
 
SELECT * FROM UsuarioTarget
SELECT * FROM UsuarioSource

