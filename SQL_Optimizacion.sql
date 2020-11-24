-- Curso Optimización SQL SERVER
-- Roy Rojas
-- twitter.com/royrojasdev | linkedin.com/in/royrojas
------------------------------------------------------
-- Clase 19 - Funciones Tabla
------------------------------------------------------

USE WideWorldImporters

GO

-- Funcion con retorno de una tabla

	SELECT s.StockItemID, s.StockItemName, SUM(l.Quantity) as Cantidad
	  FROM Warehouse.StockItems s INNER JOIN
		   Sales.InvoiceLines l ON s.StockItemID = l.StockItemID INNER JOIN
		   Sales.Invoices i ON l.InvoiceID = i.InvoiceID INNER JOIN
		   Sales.Customers c ON i.CustomerID = c.CustomerID
	 WHERE c.CustomerID = 832
	 GROUP BY s.StockItemID, s.StockItemName

GO
 

CREATE or ALTER FUNCTION f_TotalComprasXCliente
(	
	@CustomerID int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT s.StockItemID, s.StockItemName, SUM(l.Quantity) as Cantidad
	  FROM Warehouse.StockItems s INNER JOIN
		   Sales.InvoiceLines l ON s.StockItemID = l.StockItemID INNER JOIN
		   Sales.Invoices i ON l.InvoiceID = i.InvoiceID INNER JOIN
		   Sales.Customers c ON i.CustomerID = c.CustomerID
	 WHERE c.CustomerID = @CustomerID
	 GROUP BY s.StockItemID, s.StockItemName
)

GO

SELECT * FROM dbo.f_TotalComprasXCliente(832)

GO


-- Funciones con recursividad

USE AdventureWorks2019

GO

CREATE OR ALTER FUNCTION dbo.ufn_FindReports (@InEmpID INTEGER)
RETURNS @retFindReports TABLE
(
    EmployeeID int primary key NOT NULL,
    FirstName nvarchar(255) NOT NULL,
    LastName nvarchar(255) NOT NULL,
    JobTitle nvarchar(50) NOT NULL,
    RecursionLevel int NOT NULL
)
--Returns a result set that lists all the employees who report to the
--specific employee directly or indirectly.*/
AS
BEGIN
WITH EMP_cte(EmployeeID, OrganizationNode, FirstName, LastName, JobTitle, RecursionLevel) -- CTE name and columns
    AS (
        -- Get the initial list of Employees for Manager n
        SELECT e.BusinessEntityID, e.OrganizationNode, p.FirstName, p.LastName, e.JobTitle, 0
        FROM HumanResources.Employee e INNER JOIN 
		     Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
        WHERE e.BusinessEntityID = @InEmpID
        UNION ALL
        -- Join recursive member to anchor
        SELECT e.BusinessEntityID, e.OrganizationNode, p.FirstName, p.LastName, e.JobTitle, RecursionLevel + 1
        FROM HumanResources.Employee e INNER JOIN
			 EMP_cte ON e.OrganizationNode.GetAncestor(1) = EMP_cte.OrganizationNode INNER JOIN 
			 Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
        )
	
	-- Copiamos los valores en la tabla resultado
    INSERT @retFindReports
    SELECT EmployeeID, FirstName, LastName, JobTitle, RecursionLevel
    FROM EMP_cte
    RETURN

END;
GO
-- Example invocation
SELECT EmployeeID, FirstName, LastName, JobTitle, RecursionLevel
FROM dbo.ufn_FindReports(2);