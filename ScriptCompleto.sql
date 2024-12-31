-- TODO SCRIPT
CREATE DATABASE TodoHonduras
GO

use TodoHonduras
go

CREATE TABLE CATEGORIA(
IdCategoria int primary key identity,
Descripcion varchar (100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)
GO

CREATE TABLE MARCA(
IdMarca int primary key identity,
Descripcion varchar (100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)
GO

CREATE TABLE PRODUCTO(
IdProducto int primary key identity,
Nombre varchar (500),
Descripcion varchar (100),
IdMarca int references MARCA(IdMarca),
IdCategoria int references CATEGORIA(IdCategoria),
--PrecioCompra decimal(10,2) NOT NULL DEFAULT 0,
Precio decimal(10,2) default 0,
Stock int,
RutaImagen varchar(500),
NombreImagen varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
)
GO



CREATE TABLE CLIENTE(
IdCliente int primary key identity,
Nombres varchar (100),
Apellidos varchar (100),
Correo varchar (100),
Clave varchar (150),
Reestablecer bit default 0,
FechaRegistro datetime default getdate()
)
GO

CREATE TABLE CARRITO(
IdCarrito int primary key identity,
IdCliente int references CLIENTE(IdCliente),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int
)
GO

CREATE TABLE Venta(
IdVenta int primary key identity,
IdCliente int references CLIENTE(IdCliente),
TotalProducto int,
MontoTotal decimal(10,2),
Contacto varchar (50),
IdAldea varchar (50),
Telefono varchar (50),
Direccion varchar (500),
IdTransaccion varchar (50),
FechaVenta datetime default getdate()
)
GO

CREATE TABLE Detalle_Venta(
IdDetalleVenta int primary key identity,
IdVenta int references VENTA (IdVenta),
IdProducto int references PRODUCTO (IdProducto),
--PrecioCompra decimal(10,2) NOT NULL DEFAULT 0,
Cantidad int,
Total decimal(10,2)
)
GO

CREATE TABLE USUARIO(
IdUsuario int primary key identity,
Nombres varchar (100),
Apellidos varchar (100),
Correo varchar (100),
Clave varchar (150),
Reestablecer bit default 1,
Activo bit default 1,
FechaRegistro datetime default getdate()
)
GO

CREATE TABLE DEPARTAMENTO(
IdDepto INT PRIMARY KEY IDENTITY,
IdDepartamento varchar (2) not null,
Descripcion varchar (45) not null
)
GO

CREATE TABLE MUNICIPIO(
IdMun INT PRIMARY KEY IDENTITY,
IdMunicipio varchar (4) NOT NULL,
Descripcion varchar (45) NOT NULL,
IdDepartamento varchar (2) NOT NULL
)
GO

CREATE TABLE ALDEA(
IdDistrito INT PRIMARY KEY IDENTITY,
IdAldea varchar (6) NOT NULL,
Descripcion varchar (45) NOT NULL,
IdMunicipio varchar (4) NOT NULL,
IdDepartamento varchar (2) NOT NULL
)
GO

CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE(
	[IdProducto] int null,
	[Cantidad] int null,
	[Total] decimal(18,2) null
)
GO


CREATE TABLE Negocio(
IdNegocio int primary key,
Documento varchar (100),
RazonSocial varchar (100),
Correo varchar (100),
Direccion varchar (500),
Telefono varchar (100),
UserTelegram varchar (100),
Mision varchar (1000),
Vision varchar (1000),
RutaImagen varchar(700),
NombreImagen varchar(100)
)
GO

-- INSERCION DE DATOS A LAS TABLAS

Insert into USUARIO (Nombres, Apellidos, Correo, Clave) values
('NombreEjemplo','ApellidosEjemplo', 'correo@example.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')
go

Insert into CATEGORIA (Descripcion) values
('Tecnología')
go

Insert into MARCA (Descripcion) values
('LG')
go

Insert into DEPARTAMENTO (IdDepartamento,Descripcion) VALUES
('01','Atlantida'),
('02','Colón'),
('03','Comayagua'),
('04','Copán'),
('05','Cortes'),
('06','Choluteca'),
('07','El Paraíso'),
('08','Francisco Morazan')
GO

Insert into MUNICIPIO (IdMunicipio,Descripcion,IdDepartamento) values
--Atlantidad
('0101','La Ceiba','01'),
('0102','El Porvenir','01'),

--COLÓN
('0201','Trujillo','02'),
('0202','Balfate','02'),

--COMAYAGUA
('0301','Comayagua','03'),
('0302','Ajuterique','03')

go

insert into ALDEA (IdAldea,Descripcion,IdMunicipio,IdDepartamento) values
--LA CEIBA - MUN
('010101','Corozal','0101','01'),
('010102','El Paraíso o Bataca','0101','01'),

--EL PORVENIR - MUN
('010201','El Pino','0102','01'),
('010202','La Ruidosa','0102','01'),

--TRUJILLO - MUN
('020101','Chapagua','0201','02'),
('020102','Colonia Aguán','0201','02'),

--BALFATE - MUN
('020201','Balfate','0202','02'),
('020202','	Arenalosa','0202','02'),

--Comayagua - MUN
('030101','El Guachipilín','0301','03'),
('030102','El Horno','0301','03'),

--AJUTERIQUE - MUN
('030201','	Ajuterique','0302','03'),
('030202','		El Misterio','0302','03')
go

Insert into Negocio (IdNegocio,Documento,RazonSocial,Correo,Direccion, Telefono,UserTelegram,Mision,Vision,RutaImagen,NombreImagen) values 
(1,'101010','TestDocument','@test','direccionTest','959595','UserTeleg','TestMision','TestVision',null,null)
go

-- PROCEDIMIENTOS ALMACENADOS

Create proc sp_RegistrarUsuario(
    @Nombres varchar(100),
    @Apellidos varchar(100),
    @Correo varchar(100),
    @Clave varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado int output
)
as 
begin
    SET @Resultado = 0

    IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo)
    BEGIN
        INSERT INTO USUARIO(Nombres, Apellidos, Correo, Clave, Activo) values
        (@Nombres, @Apellidos, @Correo, @Clave, @Activo)

        set @Resultado = SCOPE_IDENTITY()
    END
    ELSE
        SET @Mensaje = 'El correo del Usuario ya existe'
end

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
end

go

--CATEGORIA

Create proc sp_RegistrarCategoria(
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
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
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
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
end

go

Create proc sp_EliminarCategoria(
    @IdCategoria int,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as 
begin
    SET @Resultado = 0
    IF NOT EXISTS (Select * from PRODUCTO p
        inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
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
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
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
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
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
end

go

Create proc sp_EliminarMarca(
    @IdMarca int,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as 
begin
    SET @Resultado = 0
    IF NOT EXISTS (Select * from PRODUCTO p
        inner join MARCA m on m.IdMarca = p.IdMarca
        where p.IdMarca = @IdMarca)
    begin
        delete top (1) from MARCA where IdMarca = @IdMarca
        SET @Resultado = 1
    END
    SET @Mensaje = 'La marca se encuentra relacionada a un producto'
end

go

--PRODUCTO

Create procedure sp_RegistrarProducto(
    @Nombre varchar(100),
    @Descripcion varchar(100),
    @IdMarca varchar(100),
    @IdCategoria varchar(100),
    @Precio decimal(10,2),
    @Stock int,
    @Activo bit,
    @Mensaje varchar(500) output,
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


-- PRODUCTO

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


Create proc sp_ReporteDashBoard
as
begin
    select
    (Select count(*) from CLIENTE) [totalcliente],
    (select isnull(sum(cantidad),0) from Detalle_Venta) [totalventa],
    (select COUNT(*) from PRODUCTO)[totalproducto]
end
go

Create proc sp_ReporteVentas(
@FechaInicio varchar(10),
@FechaFin varchar(10),
@idTransaccion varchar(100)
)
as
begin
    set dateformat dmy;

    Select CONVERT(char(10),V.FechaVenta,103)[FechaVenta], CONCAT(C.Nombres,' ', C.Apellidos)[Cliente],
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



-- Función para obtener el carrito del cliente
CREATE FUNCTION fn_obtenerCarritoCliente(
    @idcliente INT
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        p.IdProducto, 
        m.Descripcion AS [DesMarca], 
        p.Nombre, 
        p.Precio, 
        c.Cantidad, 
        p.RutaImagen, 
        p.NombreImagen
    FROM 
        CARRITO c
    INNER JOIN 
        PRODUCTO p ON p.IdProducto = c.IdProducto
    INNER JOIN 
        MARCA m ON m.IdMarca = p.IdMarca
    WHERE 
        c.IdCliente = @idcliente
)
GO

-- Procedimiento para eliminar un producto del carrito
CREATE PROCEDURE sp_EliminarCarrito(
    @IdCliente INT,
    @IdProducto INT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 1
    DECLARE @cantidadproducto INT = (SELECT Cantidad FROM CARRITO WHERE IdCliente = @IdCliente AND IdProducto = @IdProducto)

    BEGIN TRY
        BEGIN TRANSACTION OPERACION

        UPDATE PRODUCTO 
        SET Stock = Stock + @cantidadproducto 
        WHERE IdProducto = @IdProducto
        
        DELETE TOP (1) FROM CARRITO 
        WHERE IdCliente = @IdCliente AND IdProducto = @IdProducto

        COMMIT TRANSACTION OPERACION

    END TRY
    BEGIN CATCH
        SET @Resultado = 0
        ROLLBACK TRANSACTION OPERACION
    END CATCH
END
GO

-- Procedimiento para registrar una venta
CREATE PROCEDURE usp_RegistrarVenta(
    @IdCliente INT,
    @TotalProducto INT,
    @MontoTotal DECIMAL(18, 2),
    @Contacto VARCHAR(100),
    @IdAldea VARCHAR(100),
    @Telefono VARCHAR(15),
    @Direccion VARCHAR(100),
    @IdTransaccion VARCHAR(100),
    @DetalleVenta [EDetalle_Venta] READONLY,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
)
AS
BEGIN
    BEGIN TRY
        DECLARE @idventa INT = 0
        SET @Resultado = 1
        SET @Mensaje = ''

        BEGIN TRANSACTION registro

        INSERT INTO Venta(IdCliente, TotalProducto, MontoTotal, Contacto, IdAldea, Telefono, Direccion, IdTransaccion)
        VALUES (@IdCliente, @TotalProducto, @MontoTotal, @Contacto, @IdAldea, @Telefono, @Direccion, @IdTransaccion)

        SET @idventa = SCOPE_IDENTITY()
        
        INSERT INTO Detalle_Venta(IdVenta, IdProducto, Cantidad, Total)
        SELECT @idventa, IdProducto, Cantidad, Total 
        FROM @DetalleVenta

        DELETE FROM CARRITO WHERE IdCliente = @IdCliente

        COMMIT TRANSACTION registro

    END TRY
    BEGIN CATCH
        SET @Resultado = 0
        SET @Mensaje = ERROR_MESSAGE()
        ROLLBACK TRANSACTION registro
    END CATCH
END
GO

-- Función para listar las compras de un cliente
CREATE FUNCTION fn_ListarCompra(
    @idcliente INT
)
RETURNS TABLE
AS
RETURN (
    SELECT p.RutaImagen, p.NombreImagen, p.Nombre, p.Precio, dv.Cantidad, dv.Total, v.IdTransaccion 
    FROM Detalle_Venta dv
    INNER JOIN PRODUCTO p ON p.IdProducto = dv.IdProducto
    INNER JOIN Venta v ON v.IdVenta = dv.IdVenta
    WHERE v.IdCliente = @idcliente
)
GO

-- Procedimiento para obtener productos con paginación
CREATE PROCEDURE sp_ObtenerProductos(
    @idMarca INT,
    @idCategoria INT,
    @nroPagina INT,
    @obtenerRegistros INT,
    @TotalRegistros INT OUTPUT,
    @TotalPaginas INT OUTPUT
)
AS
BEGIN
    DECLARE @omitirRegistros INT = (@nroPagina - 1) * @obtenerRegistros;

    SELECT 
        p.IdProducto, 
        p.Nombre, 
        p.Descripcion,
        m.IdMarca, 
        m.Descripcion AS [DesMarca],
        c.IdCategoria, 
        c.Descripcion AS [DesCategoria],
        p.Precio, 
        p.Stock, 
        p.RutaImagen, 
        p.NombreImagen, 
        p.Activo
    INTO #tabla_resultado
    FROM PRODUCTO p
    INNER JOIN MARCA m ON m.IdMarca = p.IdMarca
    INNER JOIN CATEGORIA c ON c.IdCategoria = p.IdCategoria
    WHERE 
        m.IdMarca = IIF(@idMarca = 0, m.IdMarca, @idMarca)
        AND c.IdCategoria = IIF(@idCategoria = 0, c.IdCategoria, @idCategoria)
        AND p.Activo = 1 
        AND p.Stock > 0;

    -- Calcula el total de registros
    SET @TotalRegistros = (SELECT COUNT(*) FROM #tabla_resultado);

    -- Calcula el total de páginas
    SET @TotalPaginas = CEILING(CONVERT(FLOAT, @TotalRegistros) / @obtenerRegistros);

    -- Selecciona los registros para la paginación
    SELECT * 
    FROM #tabla_resultado
    ORDER BY IdProducto ASC
    OFFSET @omitirRegistros ROWS
    FETCH NEXT @obtenerRegistros ROWS ONLY;

    DROP TABLE #tabla_resultado;
END
GO

-- Procedimiento para registrar un departamento
CREATE PROCEDURE sp_RegistrarDepartamento(
    @IdDepartamento VARCHAR(2),
    @Descripcion VARCHAR(45),
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0

    IF NOT EXISTS (SELECT * FROM DEPARTAMENTO WHERE IdDepartamento = @IdDepartamento)
    BEGIN
        INSERT INTO DEPARTAMENTO(IdDepartamento, Descripcion)
        VALUES (@IdDepartamento, @Descripcion)

        SET @Resultado = SCOPE_IDENTITY()
    END
    ELSE
        SET @Mensaje = 'El código o departamento ya existe'
END
GO


-- PROCEDIMIENTOS PARA DEPARTAMENTO

CREATE PROCEDURE sp_EditarDepartamento(
    @IdDepto INT,
    @IdDepartamento VARCHAR(100),
    @Descripcion VARCHAR(100),
    @Mensaje VARCHAR(500) OUTPUT, 
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    -- Verificar si el departamento con la misma descripción ya existe
    IF NOT EXISTS (
        SELECT * FROM DEPARTAMENTO 
        WHERE (IdDepartamento = @IdDepartamento OR Descripcion = @Descripcion) 
        AND IdDepto != @IdDepto
    )
    BEGIN
        -- Actualizar el departamento
        UPDATE DEPARTAMENTO
        SET 
            IdDepartamento = @IdDepartamento,
            Descripcion = @Descripcion
        WHERE IdDepto = @IdDepto;

        SET @Resultado = 1;  -- Indica que la actualización fue exitosa
    END
    ELSE
        SET @Mensaje = 'El código o departamento ya existe';  -- Error si el código o departamento ya existen
END
GO

CREATE PROCEDURE sp_EliminarDepartamento(
    @IdDepto INT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    -- Verificar si el departamento existe
    IF EXISTS (SELECT * FROM DEPARTAMENTO WHERE IdDepto = @IdDepto)
    BEGIN
        -- Eliminar el departamento
        DELETE FROM DEPARTAMENTO WHERE IdDepto = @IdDepto;

        -- Confirmar éxito
        SET @Resultado = 1;
        SET @Mensaje = 'El departamento fue eliminado correctamente.';
    END
    ELSE
    BEGIN
        -- Mensaje de error si no existe
        SET @Mensaje = 'El departamento no existe o ya fue eliminado.';
    END
END
GO

-- PROCEDIMIENTOS PARA MUNICIPIO

CREATE PROCEDURE sp_RegistrarMunicipio(
    @IdMunicipio VARCHAR(100),
    @Descripcion VARCHAR(100),
    @IdDepartamento VARCHAR(100),
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;  -- Inicializamos en 0 (sin éxito)
    SET @Mensaje = '';   -- Limpiamos el mensaje

    -- Verificamos si el municipio con el IdMunicipio ya existe
    IF NOT EXISTS (SELECT 1 FROM MUNICIPIO WHERE IdMunicipio = @IdMunicipio)
    BEGIN
        -- Si no existe, insertamos el nuevo municipio
        INSERT INTO MUNICIPIO(IdMunicipio, IdDepartamento, Descripcion)
        VALUES (@IdMunicipio, @IdDepartamento, @Descripcion);

        -- Indicamos que la inserción fue exitosa
        SET @Resultado = 1;  -- Registro exitoso
    END
    ELSE
    BEGIN
        -- Si el municipio ya existe, establecemos el mensaje de error
        SET @Mensaje = 'El código o Municipio ya existe.';
    END
END
GO

CREATE PROCEDURE sp_EditarMunicipio(
    @IdMun INT,
    @IdMunicipio VARCHAR(100),
    @Descripcion VARCHAR(100),
    @IdDepartamento VARCHAR(100),
    @Mensaje VARCHAR(500) OUTPUT, 
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;  -- Inicializamos @Resultado en 0 (sin éxito)

    -- Verificar si el municipio con el mismo IdMunicipio o Descripcion ya existe
    IF NOT EXISTS (
        SELECT * FROM MUNICIPIO
        WHERE (IdMunicipio = @IdMunicipio OR Descripcion = @Descripcion)
        AND IdMun != @IdMun  -- Excluimos el municipio actual con IdMun
    )
    BEGIN
        -- Actualizar el municipio con el nuevo IdMunicipio, Descripcion y IdDepartamento
        UPDATE MUNICIPIO
        SET 
            IdMunicipio = @IdMunicipio,
            Descripcion = @Descripcion,
            IdDepartamento = @IdDepartamento
        WHERE IdMun = @IdMun;

        SET @Resultado = 1;  -- Indica que la actualización fue exitosa
    END
    ELSE
        SET @Mensaje = 'El código o municipio ya existe';  -- Error si el código o municipio ya existen
END
GO

CREATE PROCEDURE sp_EliminarMunicipio(
    @IdMun INT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    -- Verificar si el Municipio existe
    IF EXISTS (SELECT * FROM Municipio WHERE IdMun = @IdMun)
    BEGIN
        -- Eliminar el Municipio
        DELETE FROM Municipio WHERE IdMun = @IdMun;

        -- Confirmar éxito
        SET @Resultado = 1;
        SET @Mensaje = 'El Municipio fue eliminado correctamente.';
    END
    ELSE
    BEGIN
        -- Mensaje de error si no existe
        SET @Mensaje = 'El Municipio no existe o ya fue eliminado.';
    END
END
GO

-- PROCEDIMIENTOS PARA ALDEA

CREATE PROCEDURE sp_RegistrarAldea(
    @IdAldea VARCHAR(100),
    @Descripcion VARCHAR(100),
    @IdMunicipio VARCHAR(100),
    @IdDepartamento VARCHAR(100),
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    -- Verificar si la aldea con el IdAldea ya existe
    IF NOT EXISTS (SELECT * FROM ALDEA WHERE IdAldea = @IdAldea)
    BEGIN
        -- Insertar la nueva aldea
        INSERT INTO ALDEA(IdAldea, IdMunicipio, IdDepartamento, Descripcion)
        VALUES (@IdAldea, @IdMunicipio, @IdDepartamento, @Descripcion);

        SET @Resultado = 1;  -- Registro exitoso
    END
    ELSE
        SET @Mensaje = 'El código o Aldea ya existe';  -- Error si el código o aldea ya existen
END
GO

CREATE PROCEDURE sp_EditarAldea(
    @IdDistrito INT,
    @IdAldea VARCHAR(100),
    @Descripcion VARCHAR(100),
    @IdMunicipio VARCHAR(100),
    @IdDepartamento VARCHAR(100),
    @Mensaje VARCHAR(500) OUTPUT, 
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;  -- Inicializamos @Resultado en 0 (sin éxito)

    -- Verificar si la aldea con el mismo IdAldea o Descripcion ya existe
    IF NOT EXISTS (
        SELECT * FROM ALDEA
        WHERE (IdAldea = @IdAldea OR Descripcion = @Descripcion)
        AND IdDistrito != @IdDistrito  -- Excluimos el distrito actual con IdDistrito
    )
    BEGIN
        -- Actualizar la aldea con el nuevo IdAldea, Descripcion, IdMunicipio y IdDepartamento
        UPDATE ALDEA
        SET 
            IdAldea = @IdAldea,
            Descripcion = @Descripcion,
            IdMunicipio = @IdMunicipio,
            IdDepartamento = @IdDepartamento
        WHERE IdDistrito = @IdDistrito;

        SET @Resultado = 1;  -- Indica que la actualización fue exitosa
    END
    ELSE
        SET @Mensaje = 'El código o distrito ya existe';  -- Error si el código o distrito ya existen
END
GO

CREATE PROCEDURE sp_EliminarAldea(
    @IdDistrito INT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    -- Verificar si la aldea existe
    IF EXISTS (SELECT * FROM ALDEA WHERE IdDistrito = @IdDistrito)
    BEGIN
        -- Eliminar la aldea
        DELETE FROM ALDEA WHERE IdDistrito = @IdDistrito;

        -- Confirmar éxito
        SET @Resultado = 1;
        SET @Mensaje = 'La aldea fue eliminada correctamente.';
    END
    ELSE
    BEGIN
        -- Mensaje de error si no existe
        SET @Mensaje = 'La aldea no existe o ya fue eliminada.';
    END
END
GO

-- PROCEDIMIENTO PARA NEGOCIO

CREATE PROCEDURE sp_EditarNegocio(
    @IdNegocio INT,
    @Documento VARCHAR(100),
    @RazonSocial VARCHAR(100),
    @Correo VARCHAR(100),
    @Direccion VARCHAR(500),
    @Telefono VARCHAR(100),
    @UserTelegram VARCHAR(100),
    @Mision VARCHAR(1000),
    @Vision VARCHAR(1000),
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    -- Actualizar el negocio
    UPDATE NEGOCIO 
    SET 
        Documento = @Documento,
        RazonSocial = @RazonSocial,
        Correo = @Correo,
        Direccion = @Direccion,
        Telefono = @Telefono,
        UserTelegram = @UserTelegram,
        Mision = @Mision,
        Vision = @Vision
    WHERE IdNegocio = @IdNegocio;

    SET @Resultado = 1;  -- Indica que la actualización fue exitosa
END
GO
