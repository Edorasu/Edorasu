--PROC ALMACENADOS

Create proc sp_RegistrarUsuario(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as begin
	SET @Resultado = 0

	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo)
	BEGIN
		INSERT INTO USUARIO(Nombres, Apellidos,Correo, Clave,Activo) values
		(@Nombres, @Apellidos,@Correo,@Clave,@Activo)

		set @Resultado = SCOPE_IDENTITY()
	END
	ELSE
	 SET @Mensaje = 'El correo del Usuario ya existe'
End

GO

Create proc sp_EditarUsuario(
@IdUsuario int,
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Activo bit,
@Mensaje varchar(500) output, 
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo and IdUsuario != @IdUsuario)
	BEGIN
		update top (1) USUARIO set
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo = @Activo
		where IdUsuario = @IdUsuario

		set @Resultado = 1
	END
	ELSE
	 SET @Mensaje = 'El correo del Usuario ya existe'
End
go

--CATEGORIA

Create proc sp_RegistrarCategoria(
@Descripcion varchar (100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado int output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (Select * from CATEGORIA where Descripcion = @Descripcion)
	begin 
		Insert into CATEGORIA (Descripcion, Activo) values
		(@Descripcion, @Activo)

		SET @Resultado = SCOPE_IDENTITY()
	end
	else
	set @Mensaje = 'La categoria ya existe'
end
go

Create proc sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar (100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	BEGIN
		update top (1) CATEGORIA set
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdCategoria = @IdCategoria

		set @Resultado = 1
	END
	ELSE
	 SET @Mensaje = 'La categoria ya existe'
End
go

Create proc sp_EliminarCategoria(
@IdCategoria int,
@Mensaje varchar (500) output,
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (Select * from PRODUCTO p
	inner join  CATEGORIA c on c.IdCategoria = p.IdCategoria
	where p.IdCategoria = @IdCategoria)
	begin
		delete top (1) from CATEGORIA where IdCategoria = @IdCategoria
		SET @Resultado = 1
	END
	SET @Mensaje = 'La categoria se encuentra relacionada a un producto'
end
go

--MARCA

Create proc sp_RegistrarMarca(
@Descripcion varchar (100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado int output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (Select * from MARCA where Descripcion = @Descripcion)
	begin 
		Insert into MARCA (Descripcion, Activo) values
		(@Descripcion, @Activo)

		SET @Resultado = SCOPE_IDENTITY()
	end
	else
	set @Mensaje = 'La marca ya existe'
end
go

Create proc sp_EditarMarca(
@IdMarca int,
@Descripcion varchar (100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion and IdMarca != @IdMarca)
	BEGIN
		update top (1) MARCA set
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdMarca = @IdMarca

		set @Resultado = 1
	END
	ELSE
	 SET @Mensaje = 'La marca ya existe'
End
go

Create proc sp_EliminarMarca(
@IdMarca int,
@Mensaje varchar (500) output,
@Resultado bit output
)
as 
begin
	SET @Resultado = 0
	IF NOT EXISTS (Select * from PRODUCTO p
	inner join  MARCA m on m.IdMarca = p.IdMarca
	where p.IdMarca = @IdMarca)
	begin
		delete top (1) from MARCA where IdMarca = @IdMarca
		SET @Resultado = 1
	END
	SET @Mensaje = 'La marca se encuentra relacionada a un producto'
end
go

-- PRODUCTO

Create procedure sp_RegistrarProducto(
@Nombre varchar (100),
@Descripcion varchar (100),
@IdMarca varchar (100),
@IdCategoria varchar (100),
@Precio decimal (10,2),
@Stock int,
@Activo bit,
@Mensaje varchar (500) output,
@Resultado int output
)
as 
begin
	Set @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre)
	BEGIN
		INSERT INTO PRODUCTO(Nombre, Descripcion, IdMarca, IdCategoria, Precio, Stock, Activo) values
		(@Nombre, @Descripcion, @IdMarca, @IdCategoria, @Precio, @Stock, @Activo)

		SET @Resultado = SCOPE_IDENTITY()
	END
	else
		set @Mensaje = 'El producto ya existe'
end
go

Create proc sp_EditarProducto(
@IdProducto int,
@Nombre varchar (100),
@Descripcion varchar (100),
@IdMarca varchar (100),
@IdCategoria varchar (100),
@Precio decimal (10,2),
@Stock int,
@Activo bit,
@Mensaje varchar (500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre and IdProducto != @IdProducto)
	begin
		update PRODUCTO set
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdMarca = @IdMarca,
		IdCategoria = @IdCategoria,
		Precio = @Precio,
		Stock = @Stock,
		Activo = @Activo
		where IdProducto = @IdProducto

		SET @Resultado = 1
	end
	ELSE
		SET @Mensaje = 'El producto ya existe'
end
go

Create proc sp_EliminarProducto(
@IdProducto int,
@Mensaje varchar (500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM Detalle_Venta dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto)
	begin
		delete top (1) from PRODUCTO where IdProducto = @IdProducto
		SET @Resultado = 1
	end
	else
		set @Mensaje = 'El producto se encuentra relacionado a una venta'
end
go

--select p.IdProducto, p.Nombre, p.Descripcion,
--m.IdMarca, m.Descripcion[DesMarca],
--c.IdCategoria, c.Descripcion[DesCategoria],
--p.Precio, p.Stock, p.RutaImagen, p.NombreImagen, p.Activo
--from PRODUCTO p
--inner join MARCA m on m.IdMarca = p.IdMarca
--inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
--go

CREATE PROC sp_ReporteDashBoard
as
begin
select
(Select count(*) from CLIENTE) [totalcliente],
(select	isnull(sum(cantidad),0) from Detalle_Venta) [totalventa],
(select COUNT(*) from PRODUCTO)[totalproducto]
end
go

create proc sp_ReporteVentas(
@FechaInicio varchar(10),
@FechaFin varchar(10),
@idTransaccion varchar(100)
)
as
begin
	set dateformat dmy;

Select CONVERT(char(10),V.FechaVenta,103)[FechaVenta], CONCAT(C.Nombres,'', C.Apellidos)[Cliente],
P.Nombre[Producto], p.Precio, dv.Cantidad, dv.Total, v.IdTransaccion
from Detalle_Venta dv
inner join PRODUCTO  p on p.IdProducto = dv.IdProducto
inner join VENTA v  on v.IdVenta = dv.IdVenta
inner join CLIENTE c on c.IdCliente = V.IdVenta
where CONVERT(date, v.FechaVenta) between @FechaInicio and @FechaFin
and v.IdTransaccion = iif(@idTransaccion = '', v.IdTransaccion, @idTransaccion)
end
GO

--PARTE DEL LADO DEL CLIENTE

Create proc sp_RegistrarCliente(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if not exists(Select * from CLIENTE where Correo = @Correo)
	begin
		insert into CLIENTE(Nombres, Apellidos,Correo,Clave,Reestablecer) values
		(@Nombres, @Apellidos, @Correo, @Clave, 0)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El correo del usuario ya existe'
end
go

--SELECT * FROM CLIENTE
--Contrase;a = 123
--update cliente set Clave = 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', Reestablecer = 0 where IdCliente = 1

--declare @idcategoria int = 0

--Select distinct m.IdMarca, m.Descripcion from PRODUCTO p
--INNER JOIN CATEGORIA c on c.IdCategoria = p.IdCategoria
--INNER JOIN MARCA m on m.IdMarca = p.IdMarca and m.Activo = 1
--where c.IdCategoria = iif(@idcategoria = 0, c.IdCategoria, @idcategoria)
--GO

Create proc sp_ExisteCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin
	if exists (select * from CARRITO where idcliente = @IdCliente and idproducto = @IdProducto)
		set @Resultado = 1
	else
		set @Resultado = 0
end
go

Create proc sp_OperacionCarrito(
@IdCliente int,
@IdProducto int,
@Sumar bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 1
	set @Mensaje = ''

	declare @existecarrito bit = iif(exists(select * from carrito where idcliente = @IdCliente and idproducto = @IdProducto),1,0)
	declare @stockproducto int = (select stock from PRODUCTO where IdProducto = @IdProducto)

	begin try
		begin transaction OPERACION

		if(@Sumar = 1)
		begin

			if(@stockproducto > 0)
			begin

				if(@existecarrito = 1)
					update CARRITO set Cantidad = Cantidad + 1 where IdCliente = @IdCliente and IdProducto = @IdProducto
				else
					insert into CARRITO(IdCliente, IdProducto, Cantidad) values (@IdCliente, @IdProducto,1)
				update PRODUCTO set Stock = Stock - 1 where IdProducto = @IdProducto
			end
			else
			begin
				set @Resultado = 0
				set @Mensaje = 'El producto no cuenta con stock disponible'
			end

		end
		else
		begin
			update CARRITO set Cantidad = Cantidad - 1 where IdCliente = @IdCliente and IdProducto = @IdProducto
			update PRODUCTO set Stock = Stock + 1 where IdProducto = @IdProducto
		end

		commit transaction OPERACION

	END TRY
	BEGIN CATCH
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction OPERACION
	END CATCH
end
go


create function fn_obtenerCarritoCliente(
@idcliente int
)
returns table
as
return(
	SELECT 
        p.IdProducto, 
        m.Descripcion [DesMarca], 
        p.Nombre, p.Precio, 
        c.Cantidad, 
        p.RutaImagen, p.NombreImagen
    FROM 
        CARRITO c
    INNER JOIN 
        PRODUCTO p ON p.IdProducto = c.IdProducto
    INNER JOIN 
        MARCA m ON m.IdMarca = p.IdMarca
    WHERE c.IdCliente = @idcliente
)
go


Create proc sp_EliminarCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin
	
	set @Resultado = 1
	declare @cantidadproducto int = (select Cantidad from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto)

	begin try
		
		begin transaction OPERACION

		update PRODUCTO set Stock = Stock + @cantidadproducto where IdProducto = @IdProducto
		delete top (1) from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto

		commit transaction OPERACION

	END TRY
	BEGIN CATCH
		set @Resultado = 0
		ROLLBACK TRANSACTION OPERACION
	END CATCH
end
go

--Select * from CLIENTE
--Select * from Municipio where IdDepartamento = @iddepartamento
--Select * from Aldea where IdMunicipio = @idmunicipio and IdDepartamento = @iddepartamento