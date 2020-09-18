-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 10 - Merge 02


USE AdventureWorks2019

BEGIN TRANSACTION
ROLLBACK

DROP PROCEDURE usp_UpdateInventory

SELECT * FROM  Production.ProductInventory WHERE ProductID = 707

go

CREATE OR ALTER PROCEDURE msp_ActualizaInventario
    @OrderDate datetime  
AS  
MERGE Production.ProductInventory AS target  
USING (SELECT ProductID, SUM(OrderQty) FROM Sales.SalesOrderDetail AS sod  
    JOIN Sales.SalesOrderHeader AS soh  
    ON sod.SalesOrderID = soh.SalesOrderID  
    AND soh.OrderDate = @OrderDate  
    GROUP BY ProductID) AS source (ProductID, OrderQty)  
ON (target.ProductID = source.ProductID)  
WHEN MATCHED AND target.Quantity - source.OrderQty <= 0  
    THEN DELETE  
WHEN MATCHED
    THEN UPDATE SET target.Quantity = target.Quantity - source.OrderQty,
                    target.ModifiedDate = GETDATE()  

OUTPUT $action,source.ProductID, source.OrderQty,
	Inserted.ProductID, Inserted.Quantity,
    Inserted.ModifiedDate, Deleted.ProductID,  
    Deleted.Quantity, Deleted.ModifiedDate;  
GO  
  
select * from Production.ProductInventory WHERE ProductID = 707
select * from Production.ProductInventory WHERE ProductID = 747

EXECUTE Production.msp_UpdateInventory '2011-05-31 00:00:00.000'  

select * from Production.ProductInventory WHERE ProductID = 707
select * from Production.ProductInventory WHERE ProductID = 747


SELECT ProductID, SUM(OrderQty) FROM Sales.SalesOrderDetail AS sod  
    JOIN Sales.SalesOrderHeader AS soh  
    ON sod.SalesOrderID = soh.SalesOrderID  
    AND soh.OrderDate = '2011-05-31 00:00:00.000'  
	GROUP BY ProductID
	ORDER BY ProductID