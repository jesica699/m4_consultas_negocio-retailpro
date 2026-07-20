DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

--Tabla categorias
Create table categorias (
ID_categoria int primary key,
Nombre_categoria Varchar(50) not null,
Descripcion varchar (200)
);

--Tabla clientes
Create table clientes (
ID_cliente int primary key,
Nombre varchar (100),
Email Varchar (100) not null,
Ciudad Varchar (50),
Fecha_registro date not null
);

--tabla productos
create table productos (
ID_producto int primary key,
Nombre_producto varchar(100) not null,
ID_categoria int not null,
Precio decimal(10,2) not null,
stock int default 0,
activo int default 1,
Constraint fk_ID_categoria
foreign key (ID_categoria)
references categorias(ID_categoria)
);

--Tabla ventas
Create table ventas(
ID_ventas int primary key,
ID_cliente int,
  Constraint fk_ID_cliente
  foreign key (ID_cliente)
  references clientes(ID_cliente),
ID_producto int,
  Constraint fk_ID_producto
  foreign key (ID_producto)
  references productos(ID_producto),
Cantidad int not null,
Precio_unitario decimal(10,2) not null,
Fecha_venta date not null
);

INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, 1);

INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

-- Confirmá que cada tabla se cargó correctamente
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;

--consultas Resumen ejecutivo mensual
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(DISTINCT id_ventas) AS cantidad_pedidos,
    ROUND(SUM(cantidad * precio_unitario) / COUNT(DISTINCT id_ventas), 2) AS ticket_promedio
FROM 
    ventas
GROUP BY 
    EXTRACT(MONTH FROM fecha_venta)
ORDER BY 
    mes ASC;

-- consulta 2  Ranking de productos
select
  ID_producto as producto,
  sum(cantidad)as total_unidades_vendidas
from
 ventas
 group by
  ID_producto
 order by
  total_unidades_vendidas desc
  limit 5;

--Consulta 3 Clientes recurrentes
select
 ID_cliente as cliente,
 count(ID_ventas) as cantidad_vendida,
 sum(Precio_unitario*cantidad)as Total_venta
from
 ventas
group by
 ID_cliente
 having
 count(ID_ventas)>1;

 --Consulta 4 — Meses por encima/por debajo del promedio
WITH ventas_mensuales AS (
    SELECT 
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(precio_unitario * cantidad) AS total_facturado
    FROM
        ventas
    GROUP BY
        EXTRACT(MONTH FROM fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    -- OVER() calcula el promedio global de todos los meses juntos sin agrupar las filas
    ROUND(AVG(total_facturado) OVER(), 2) AS promedio_general, 
    
    CASE 
        WHEN total_facturado > AVG(total_facturado) OVER() THEN 'Por encima'
        WHEN total_facturado < AVG(total_facturado) OVER() THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS etiqueta_promedio
FROM
    ventas_mensuales -- CTE
ORDER BY 
    mes;
--No encontre muchos hallazgos para destacar, ya que las ventas ingresadas en el ejercio (dadas en el modulo 3)corresponden todas al mes de marzo, por lo tanto el total de ventas y el promedio hacen referencia solo a ese mes.
--Para el caso de la consulta 4 busque con IA como resolverla por que no encontre en el teorico como usar "whith"
--Se puede decir que los 5 clientes son recurrentes, ya que cada uno realizo 2 compras en el mes de marzo.
--Podemos decir que el id de producto 2 es el mas vendido, con 13 unidades en total. Seguido por el ID numero 6 con 4 productos.
--Entregable modulo 5

--Consulta 1 — Vista base del proyecto (INNER JOIN)
select
  v.id_ventas,
  v.id_cliente,
  v.id_producto,
  v.cantidad,
  v.precio_unitario,
  v.fecha_venta
 From
  ventas v
 inner join
  clientes c
  on
   v.ID_cliente = c.Id_cliente
 inner join
   Productos p
 on
  v.ID_producto = p.ID_producto;

--Consulta 2 — Clientes sin ventas (LEFT JOIN)

select
  c.id_cliente,
  c.Nombre,
  c.email,
  c.ciudad,
  c.fecha_registro
from
  clientes c
left join
  ventas v
on
  c.ID_cliente = v.id_cliente
where
  v.cantidad is null;

--Consulta 3 — Productos sin ventas (LEFT JOIN) 
select 
 p.Id_producto,
 p.nombre_producto,
 p.id_categoria,
 p.precio,
 p.stock,
 p.activo
from
  productos p
Left join
 ventas v
on
 p.id_producto = v.id_producto
where
 v.cantidad is null;

 --Consulta 4 — Consolidado por canal (UNION ALL) Usá UNION ALL para combinar en un solo resultado las ventas Online y Presencial, agregando una columna canal que identifique el origen de cada fila. Al final calculá el total por canal con un GROUP BY.
--No se como ejecutar esta consulta. No tenemos 2 tablas de vtas en la Base de datos que creamos en M3
--No tenemos columnas de "canal" en ninguna tabla y no se que canal de venta agregar a que venta.