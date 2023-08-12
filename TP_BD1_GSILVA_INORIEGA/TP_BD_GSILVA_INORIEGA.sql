--1)
CREATE DATABASE Ventasintegrada

--2)
CREATE TABLE T_MARCAS (
	IdMarca char(1) Primary Key not null,
	Nombre char(30) not null,
	Activa char(1) not null
)

CREATE TABLE T_RUBROS (
	IdRubro int Primary Key not null,
	Nombre char(30) not null,
)

CREATE T_VENDEDORES (
	IdVendedor int Primary Key not null, 
	IdSucursal int not null,
	Nombre char(40) not null, 
	DNI int null,
	FechaIngreso smalldatetime null,
	Encargado char(1) null,
	Activo char(1) null,

)

CREATE TABLE T_CLIENTES(
	IdCliente int primary key not null,
	Nombre char(100) not null,
	CUIT char(14) not null,
	SituacionIva smallint not null,
	Direccion char(100)not null,
	CodigoPostal Char(8) not null,
	Localidad int not null,
	Provincia int not null, 
	Telefono char(31) not null,
	Email char(100) not null,
	IngresosBrutos char(12) not null,
	Limite numeric(9,2) not null, 
	Transporte smallint not null,
	Moroso char(1) not null,
	Zona int not null,
	Descuento int not null,
	Estado char(1) not null
)

CREATE TABLE T_SUCURSALES (
	IdSucursal int Primary Key not null,
	Nombre char(40) not null,
	Direccion char(50) null,
	TerminalPosnet int null,
	CentroCosto int null,
	EsOutlet bit null,
	IncrementoMinorista decimal(5, 2) null,
	Remitable char(3) null,
	Activa char(1) null
)

CREATE TABLE T_ARTICULOS (
	IdArticulo char(10) Primary Key not null,
	IdMarca char(1) not null,
	IdRubro int not null,
	Nombre char(40) not null,
	Temporada smallint not null,
	PrecioCosto decimal(9,2) not null,
	PrecioMayor decimal(9,2) not null,
	PrecioMenor decimal(9,2) not null,
	IdArticuloViejo char(10) not null,
	Promocion smallint not null,
	FechaCreado smalldatetime null,
	Estado char(1) null
)

CREATE TABLE T_VENTAS_DETALLE (
	Letra char(1)  not null,
	Factura decimal(12,0) not null,
	IdArticulo char(10) not null,
	Talle char(2) not null,
	Color int not null,
	Cantidad int,
	PrecioLista decimal(8,2),
	PrecioVenta decimal(8,2)
	Primary Key(Letra, Factura, IdArticulo, Talle, Color)
)

CREATE TABLE T_VENTAS(
	Letra char(1) not null,
	Factura decimal(12,0) not null,
	IdCliente int not null,
	IdVendedor int not null,
	IdSucursal int not null,
	FechaHora datetime not null,
	DNI decimal(8,0) null,
	Computadora int null,
	Neto1 decimal(9,2) null,
	Neto2 decimal(9,2) null,
	Iva1 decimal(8,2) null,
	Iva2 decimal(8,2) null,
	Total decimal(9,2) not null,
	Descuento1 decimal(8,2) null,
	Descuento2 decimal(8,2) null,
	Descuento3 decimal(8,2) null,
	TipoVenta char(1) not null,
	Anulada smallint not null,
	PRIMARY KEY (Letra, Factura)
)

--3)

INSERT INTO T_MARCAS (IdMarca, Nombre, Activa)
	SELECT
		marca,
		nombre,
		isnull(Ventas2.dbo.marcas.activo, 0)
	FROM
		Ventas2.dbo.marcas

INSERT INTO T_RUBROS (IdRubro, Nombre) SELECT * FROM Ventas2.dbo.rubros

INSERT INTO T_VENDEDORES ( IdVendedor, Nombre, IdSucursal, DNI, FechaIngreso, Encargado, Activo)
	SELECT 
		isnull(Ventas2.dbo.vendedores.vendedor, 0),
		isnull(Ventas2.dbo.vendedores.nombre , 'NO ESPECIFICADO'),
		sucursal, 
		dni, 
		ingreso,
		encargado,
		activo
	FROM
		Ventas2.dbo.vendedores

INSERT INTO T_VENDEDORES (IdVendedor, Nombre, IdSucursal)
	VALUES(0, 'NO ESPECIFICADO', 0)


INSERT INTO T_CLIENTES (IdCliente, Nombre, CUIT, SituacionIva, Direccion, CodigoPostal,
							Localidad, Provincia, Telefono, Email, IngresosBrutos,
								Limite, Transporte, Moroso, Zona, Descuento, Estado)
	SELECT
		isnull(Ventas2.dbo.clientes.cliente, 0),
		isnull(Ventas2.dbo.clientes.nombre, 'NO ESPECIFICADO'),
		cuit,
		sitiva,
		domicilio,
		cp,
		localidad,
		provincia,
		telefono,
		email,
		ingresosbrutos,
		limite,
		transporte,
		moroso,
		zona,
		descuento,
		estado
	FROM
		Ventas2.dbo.clientes

INSERT INTO T_ARTICULOS (IdArticulo, idMarca,  Nombre, Temporada, IdRubro, PrecioCosto, PrecioMenor,
							PrecioMayor, IdArticuloViejo, Promocion, Estado, FechaCreado)
	SELECT
		articulo,
		marca,
		nombre,
		temporada,
		rubro,
		preciocosto,
		preciomenor, 
		preciomayor,
		artviejo,
		promocion,
		estado,
		creado
	FROM
		Ventas2.dbo.articulos

INSERT INTO T_SUCURSALES ( IdSucursal, Nombre, Direccion, TerminalPosnet, Activa,
							CentroCosto, EsOutlet, IncrementoMinorista, Remitable)
	SELECT
		sucursal,
		denominacion,
		direccion,
		terminalposnet,
		Activa,
		centrocosto,
		EsOutlet,
		IncrementoMinorista,
		Remitable
	FROM
		Ventas2.dbo.sucursales

INSERT INTO T_SUCURSALES(IdSucursal, Nombre)
	VALUES(0, 'NO ESPECIFICADO')

INSERT INTO T_VENTAS_DETALLE (Letra, Factura, IdArticulo, Talle,
								Color, Cantidad, PrecioLista, PrecioVenta )
	SELECT 
		letra,
		factura,
		articulo,
		talle,
		color,
		cantidad,
		precio,
		precioventa
	FROM
		Ventas2.dbo.vendet

INSERT INTO T_VENTAS_DETALLE (Letra, Factura, IdArticulo, Talle,
								Color, Cantidad, PrecioLista, PrecioVenta )
	SELECT 
		letra,
		factura,
		articulo,
		talle,
		color,
		cantidad,
		precioreal,
		precioventa
	FROM
		Ventas2.dbo.mayordet
	
INSERT INTO T_VENTAS (Letra, Factura, FechaHora, DNI, Computadora, IdCliente,
						IdVendedor, IdSucursal, Neto1, Neto2, Iva1, Iva2, Total, Descuento1, Anulada, TipoVenta )
	SELECT
		letra,
		factura,
		isnull(Ventas2.dbo.vencab.fechahora, fecha),
		dni,
		isnull(Ventas2.dbo.vencab.computadora, 0),
		0,
		vendedor,
		sucursal,
		neto,
		neto2,
		iva1,
		iva2,
		total,
		descuento,
		anulada,
		'V'
	FROM
		Ventas2.dbo.vencab
	
INSERT INTO T_VENTAS (Letra, Factura, FechaHora, IdCliente, IdVendedor, IdSucursal
						, Descuento1, Descuento2, Descuento3, Neto1, Iva1, Iva2, Total, Anulada, TipoVenta)
	SELECT
		letra,
		factura,
		isnull(Ventas2.dbo.mayorcab.fechahora, fecha),
		cliente,
		0,
		sucursal,
		dto1,
		dto2,
		dto3,
		neto,
		iva1,
		iva2,
		total,	
		anulada,
		'M'
	FROM
		Ventas2.dbo.mayorcab

--5) 
/* 5.	Realizar una consulta de comprobación en ambas bases de datos,
		que determine la cantidad total vendida del artículo A108220035
		en el mes de marzo de 2008.
*/

Use Ventasintegrada

SELECT
	SUM(tvd.Cantidad) as "Total Vendido"
FROM
	T_VENTAS as tv
	INNER JOIN  T_VENTAS_DETALLE as tvd ON tv.Letra = tvd.Letra AND tv.Factura = tvd.Factura
	INNER JOIN T_ARTICULOS as ta ON tvd.IdArticulo = ta.IdArticulo
WHERE
	ta.Nombre LIKE '%A108220035%'
	AND MONTH(tv.FechaHora) = 3
	AND YEAR(tv.FechaHora) = 2008

Use Ventas2

SELECT
	SUM(vt.cantidad) as "Total Vendido"
FROM
	vencab as vc
	INNER JOIN  vendet as vt ON vc.letra = vt.letra AND vc.factura = vt.factura
	INNER JOIN articulos as a ON vt.articulo = a.articulo
WHERE
	a.nombre LIKE '%A108220035%'
	AND MONTH(vc.fecha) = 3
	AND YEAR(vc.fecha) = 2008

-- segunda consulta de prueba, nombre que arrancan con A

use Ventasintegrada
SELECT
	tvend.Nombre as "nombres"
FROM
	T_VENTAS as tvent
	INNER JOIN T_VENDEDORES AS tvend ON tvend.IdVendedor = tvent.IdVendedor
WHERE
	tvend.Nombre LIKE 'A%'

use Ventas2
select 
	nombre
from 
	vencab as vc
	INNER JOIN vendedores as v ON v.vendedor = vc.vendedor
where 
	v.nombre LIKE 'A%'