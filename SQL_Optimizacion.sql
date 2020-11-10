-- Curso Optimización SQL SERVER
-- Roy Rojas
-- Clase 14 - Trigger captura de errores



USE [PlatziSQL]
GO
/****** Object:  Trigger [dbo].[t_update]    Script Date: 11/10/2020 12:14:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   TRIGGER [dbo].[t_update] 
   ON  [dbo].[UsuarioTarget]
   AFTER UPDATE
AS 
BEGIN

	IF (ROWCOUNT_BIG() = 0)
	RETURN;

	declare @codigo int
	select @codigo = codigo from inserted

	if @codigo = 7
	begin
		Print 'NO se realizó un update'
		rollback;
		return;
	end
	
	--select Codigo, Nombre, Puntos from inserted
	
	Print 'Se realizó un update'

	--rollback;

END


GO

select * from UsuarioTarget where Codigo = 8
update UsuarioTarget set Nombre = 'Andres Soto' where Codigo = 8
select * from UsuarioTarget where Codigo = 8