-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 24 - Procedimientos almacenados


CREATE or ALTER PROCEDURE msp_retornaItem(
@StockItemID int,
@StockItemName NVARCHAR(100) output,
@Vendido decimal output
)
AS 
BEGIN

	SELECT @StockItemName = I.StockItemName,
		   @Vendido = SUM(O.Quantity * O.UnitPrice) 
	  FROM Warehouse.StockItems I INNER JOIN	
		   Sales.OrderLines O ON I.StockItemID = O.StockItemID
	 WHERE I.StockItemID = @StockItemID
	 GROUP BY I.StockItemID,
		   I.StockItemName

END