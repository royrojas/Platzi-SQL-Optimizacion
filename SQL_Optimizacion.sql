-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 20 - Vistas y Vista indexada
------------------------------------------------------

USE WideWorldImporters

-- Consultas a la tabla que vamos a utilizar
SELECT * FROM Sales.OrderLines
GO
SELECT COUNT(1) FROM Sales.OrderLines

GO

-- Query que vamos a implementar en la vista
SELECT StockItemID, 
    COUNT_BIG(*) as TotalLineas, 
	SUM(Quantity) as CantidadProductos,
	SUM(Quantity * UnitPrice)
FROM  Sales.OrderLines
GROUP BY StockItemID

GO

-- Creación de la vista
CREATE VIEW v_VentasXProducto
AS
     SELECT StockItemID, 
		    Description,
            COUNT_BIG(*) as TotalLineas, 
			SUM(Quantity) as CantidadProductos,
			SUM(Quantity * UnitPrice) Total
      FROM  Sales.OrderLines	  
      GROUP BY StockItemID, Description

GO

-- Ejecutando la vista
SELECT * FROM v_VentasXProducto
WHERE StockItemID = 105

GO

-- Creación de la vista indexada

-- Indispensable en la configuracion
SET ANSI_NULLS ON 
GO 
SET ANSI_PADDING ON 
GO 
SET ANSI_WARNINGS ON 
GO 
SET CONCAT_NULL_YIELDS_NULL ON 
GO 
SET QUOTED_IDENTIFIER ON 
GO 
SET NUMERIC_ROUNDABORT OFF 
GO

-- Indexada
-- Creación vista con SCHEMABINDING
CREATE VIEW v_VentasXProducto_Indexada
WITH SCHEMABINDING 
AS
     SELECT StockItemID, 
            COUNT_BIG(*) as TotalLineas, 
			SUM(Quantity) as CantidadProductos,
			SUM(ISNULL(Quantity * UnitPrice,0)) Total
      FROM  Sales.OrderLines	  
      GROUP BY StockItemID 

GO

-- Creación del índice de la vista
CREATE UNIQUE CLUSTERED INDEX IX_v_VentasXProducto_Indexada
ON v_VentasXProducto_Indexada ([StockItemID])

-- Ejecutando la vista
SELECT * FROM v_VentasXProducto_Indexada


-- Comparando las dos vístas

SELECT * FROM v_VentasXProducto
WHERE StockItemID = 105

SELECT * FROM v_VentasXProducto_Indexada
WHERE StockItemID = 105

GO

-- Recomendación creación del índice para la tabla Sales
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [Sales].[OrderLines] ([StockItemID])
INCLUDE ([Description],[Quantity],[UnitPrice])

