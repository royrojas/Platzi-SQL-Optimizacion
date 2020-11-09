-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 09 - Indices pueden perjudicar el rendimiento

USE AdventureWorks2019

GO 

SET STATISTICS IO ON

SELECT SalesOrderDetailID,
	   OrderQty
  FROM Sales.SalesOrderDetail S
 WHERE ProductID = (SELECT AVG(ProductID)
					 FROM Sales.SalesOrderDetail S2
					 WHERE S2.SalesOrderID = S.SalesOrderID
					 GROUP BY SalesOrderID)

-- se pueden ver los datos y analizar la cantidad e informacion
-- una pagina pesa 8K. se multiplican los valores para ver el tamaño de la informacion que estamos procesando.

CREATE NONCLUSTERED INDEX IX_PRIMERO
ON Sales.SalesOrderDetail
(SalesOrderID ASC, ProductID ASC)
INCLUDE (SalesOrderDetailID, OrderQty)


CREATE NONCLUSTERED INDEX IX_SEGUNDO
ON Sales.SalesOrderDetail
(ProductID ASC, SalesOrderID ASC)
INCLUDE (SalesOrderDetailID, OrderQty)


DROP INDEX IX_PRIMERO ON Sales.SalesOrderDetail
DROP INDEX IX_SEGUNDO ON Sales.SalesOrderDetail