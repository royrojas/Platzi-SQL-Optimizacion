-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 10 - Merge

CREATE TABLE Usuarios
(
Codigo INT PRIMARY KEY,
Nombre VARCHAR(100),
Puntos INT
) 
GO
INSERT INTO Usuarios VALUES
(1,'Juan Perez',10),
(2,'Marco Salgado',5),
(3,'Carlos Soto',9),
(4,'Alberto Ruiz',12),
(5,'Alejandro Castro',5)
GO
CREATE TABLE UsuariosActual
(
Codigo INT PRIMARY KEY,
Nombre VARCHAR(100),
Puntos INT
) 
GO
INSERT INTO UsuariosActual VALUES
(1,'Juan Perez',12),
(2,'Marco Salgado',11),
(4,'Alberto Ruiz Castro',4),
(5,'Alejandro Castro',5),
(6,'Pablo Ramos',8)
 
SELECT * FROM Usuarios
SELECT * FROM UsuariosActual