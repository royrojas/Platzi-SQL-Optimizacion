-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 10 - Merge 01
------------------------------------------------------

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


--------------------
--------------------
-- Sintaxis

-- SQL Server and Azure SQL Database
[ WITH <common_table_expression> [,...n] ]  
MERGE
    [ TOP ( expression ) [ PERCENT ] ]
    [ INTO ] <target_table> [ WITH ( <merge_hint> ) ] [ [ AS ] table_alias ]  
    USING <table_source> [ [ AS ] table_alias ]
    ON <merge_search_condition>  
    [ WHEN MATCHED [ AND <clause_search_condition> ]  
        THEN <merge_matched> ] [ ...n ]  
    [ WHEN NOT MATCHED [ BY TARGET ] [ AND <clause_search_condition> ]  
        THEN <merge_not_matched> ]  
    [ WHEN NOT MATCHED BY SOURCE [ AND <clause_search_condition> ]  
        THEN <merge_matched> ] [ ...n ]  
    [ <output_clause> ]  
    [ OPTION ( <query_hint> [ ,...n ] ) ]
;  
  
<target_table> ::=  
{
    [ database_name . schema_name . | schema_name . ]  
  target_table  
}  
  
<merge_hint>::=  
{  
    { [ <table_hint_limited> [ ,...n ] ]  
    [ [ , ] INDEX ( index_val [ ,...n ] ) ] }  
}  

<merge_search_condition> ::=  
    <search_condition>  
  
<merge_matched>::=  
    { UPDATE SET <set_clause> | DELETE }  
  
<merge_not_matched>::=  
{  
    INSERT [ ( column_list ) ]
        { VALUES ( values_list )  
        | DEFAULT VALUES }  
}  
  
<clause_search_condition> ::=  
    <search_condition>
