
--Entregable modulo 5

--Consulta 1 — Vista base del proyecto (INNER JOIN)
SELECT 
    v.fecha_venta,
    c.nombre AS nombre_cliente,
    -- no hay columna segmento en la tabla ventas c.segmento,
  --no hay dato region  t.region,
    p.nombre_producto,
    p.id_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
   -- no hay columna canal en ninguna tabla v.canal
FROM 
    ventas v
INNER JOIN 
    clientes c ON v.id_cliente = c.id_cliente
INNER JOIN 
    productos p ON v.id_producto = p.id_producto
-- no hay tabla territorio o region INNER JOIN 
 --   territorios t ON v.id_territorio = t.id_territorio;
	
--Consulta 2 — Clientes sin ventas (LEFT JOIN)

select
  c.nombre AS Nombre_cliente,
  c.email,
  c.fecha_registro
from
  clientes c
left join
  ventas v
on
  c.ID_cliente = v.id_cliente
where
  v.id_cliente is null;

--Consulta 3 — Productos sin ventas (LEFT JOIN) 
select 
 p.nombre_producto,
 p.id_categoria,
 p.precio
from
  productos p
Left join
 ventas v
on
 p.id_producto = v.id_producto
where
 v.id_producto is null;

 --Consulta 4 — Consolidado por canal (UNION ALL) Usá UNION ALL para combinar en un solo resultado las ventas Online y Presencial, agregando una columna canal que identifique el origen de cada fila. Al final calculá el total por canal con un GROUP BY.
--No se como ejecutar esta consulta. No tenemos 2 tablas de vtas en la Base de datos que creamos en M3
--No tenemos columnas de "canal" en ninguna tabla y no se que canal de venta agregar a que venta.