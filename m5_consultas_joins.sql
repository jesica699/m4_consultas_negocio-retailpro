
--Entregable modulo 5

--Consulta 1 — Vista base del proyecto (INNER JOIN)
SELECT 
    v.fecha_venta,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    p.id_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
    v.canal
FROM 
    ventas v
INNER JOIN 
    clientes c ON v.id_cliente = c.id_cliente
INNER JOIN 
    productos p ON v.id_producto = p.id_producto
INNER JOIN 
    territorios t ON v.id_territorio = t.id_territorio
INNER JOIN 
    categorias c ON v.id_categoria = c.id_categoria;
	
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

 --Consulta 4 — Consolidado por canal (UNION ALL) sigo sin entender como ejecutar este script si la tabla "presencial" y "on line" no existen
 
 SELECT 
    v.canal,
    SUM(v.monto) AS total_ventas,
    COUNT(*) AS cantidad_operaciones
FROM (
    SELECT 'Online' AS canal, monto FROM ventas_online
    UNION ALL
    SELECT 'Presencial' AS canal, monto FROM ventas_presencial
) v
GROUP BY v.canal;

