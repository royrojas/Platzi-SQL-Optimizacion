-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 17 - Full text search
------------------------------------------------------
 
-- Creamos el catalogo con la herramienta grafica.

-- En en el Management Studio buscamos en la base de datos 
Storage / Full Text Catalogs / Click derecho New

------------------------
-- Cómo lo utilizamos
------------------------

-- IMPORTANTE
-- Para hacer coincidir palabras y frases, use CONTAINS y CONTAINSTABLE.
-- Para hacer coincidir el significado, aunque no con la redacción exacta, use FREETEXT y FREETEXTTABLE

USE AdventureWorks2012  
GO  
  
SELECT Name, ListPrice  
FROM Production.Product  
WHERE ListPrice = 80.99  
   AND Name like '%Mountain%'
GO  

SELECT Name, ListPrice  
FROM Production.Product  
WHERE ListPrice = 80.99  
   AND CONTAINS(Name, 'Mountain')  
GO  


-- Ejemplo 02
---------------------------------
-- Busqueda en documentos word

USE PlatziSQL

USE [Platzi]
GO


CREATE TABLE [dbo].[Documentos](
	[id] [int] NOT NULL,
	[NombreArchivo] [nvarchar](40) NULL,
	[Contenido] [varbinary](max) NULL,
	[extension] [varchar](5) NULL,
 CONSTRAINT [PK_Documentos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


INSERT INTO Documentos
SELECT 3,N'Prueba-01-2', BulkColumn,'.doc'
FROM OPENROWSET(BULK  N'C:\Temp\1.doc', SINGLE_BLOB) blob


INSERT INTO Documentos
SELECT 4,N'Prueba-02-2', BulkColumn,'.doc'
FROM OPENROWSET(BULK  N'C:\Temp\2.doc', SINGLE_BLOB) blob

select * from Documentos


--select * from Documentos where DocContent like '%Roy%'

SELECT *
FROM Documentos  
WHERE FREETEXT (DocContent, 'Roy')  
GO  




----


USE AdventureWorks2012

SELECT Name, ListPrice  
FROM Production.Product  
WHERE CONTAINS(Name, 'Mountain') 

SELECT Title, *  
FROM Production.Document  
WHERE FREETEXT (Document, 'important bycycle guidelines')  

SELECT Title  
FROM Production.Document  
WHERE FREETEXT (Document, 'vital safety components') 


select * from Production.ProductDescription 
where CONTAINS(Description, 'NEAR((lightweight, aluminum), 10)')


-- haciendo join con el catalogo
SELECT KEY_TBL.RANK, FT_TBL.Description  
FROM Production.ProductDescription AS FT_TBL   
     INNER JOIN  
     FREETEXTTABLE(Production.ProductDescription, Description,  
                    'perfect all-around bike') AS KEY_TBL  
     ON FT_TBL.ProductDescriptionID = KEY_TBL.[KEY]  
WHERE KEY_TBL.RANK >= 10  
ORDER BY KEY_TBL.RANK DESC  

