-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 26 - Tablas temporales


USE Platzi

SELECT * FROM UsuarioSource

CREATE TABLE #UsuarioSource
(Codigo int, Nombre varchar(100))

INSERT INTO #UsuarioSource
SELECT Codigo, Nombre 
  FROM UsuarioSource
 WHERE Codigo < 4
 
SELECT * FROM #UsuarioSource

DROP TABLE #UsuarioSource

-- Tabla GLOBAL ##
-- TAblas las puede ver cualquier usuario en SQL
--- Recomendacion no usarlas
SELECT * FROM ##UsuarioSource

EXEC msp_prueba

CREATE PROCEDURE msp_prueba
AS 
BEGIN
	SELECT * FROM #UsuarioSource
END

-----
-- Tablas variales

DECLARE @VariableTabla 
TABLE (Codigo int, Nombre varchar(100))

INSERT INTO @VariableTabla
SELECT Codigo, Nombre 
  FROM UsuarioSource
 WHERE Codigo < 4

SELECT * FROM @VariableTabla
