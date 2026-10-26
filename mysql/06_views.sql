USE RENTAL_CARS;
-- 1
CREATE OR REPLACE VIEW VW_ALQUILERES_DETALLE AS
SELECT a.fecha_inicio,
       a.fecha_fin,
       cl.nombre  AS cliente,
       v.marca,
       v.modelo,
       e.nombre   AS empleado,
       sr.nombre  AS sucursal_retiro,
       sd.nombre  AS sucursal_devolucion,
       a.total
FROM ALQUILERES a
INNER JOIN CLIENTES   cl ON cl.id = a.id_cliente
INNER JOIN VEHICULOS  v  ON v.id  = a.id_vehiculo
INNER JOIN EMPLEADOS  e  ON e.id  = a.id_empleado
INNER JOIN SUCURSALES sr ON sr.id = a.id_sucursal_retiro
INNER JOIN SUCURSALES sd ON sd.id = a.id_sucursal_devolucion;


-- 2
CREATE OR REPLACE VIEW VW_VEHICULOS_POR_SUCURSAL AS
SELECT s.nombre AS sucursal,
       s.ciudad,
       COUNT(v.id) AS cantidad_vehiculos
FROM SUCURSALES s
LEFT JOIN VEHICULOS v ON v.id_sucursal = s.id
GROUP BY s.id, s.nombre, s.ciudad;


-- 3

CREATE OR REPLACE VIEW VW_INGRESOS_POR_CATEGORIA AS
SELECT c.nombre AS categoria,
       COUNT(a.id_alquiler) AS alquileres_finalizados,
       COALESCE(SUM(a.total), 0) AS monto_total_facturado
FROM CATEGORIAS c
LEFT JOIN VEHICULOS  v ON v.id_categoria = c.id
LEFT JOIN ALQUILERES a ON a.id_vehiculo = v.id
                      AND a.estado = 'finalizado'
GROUP BY c.id, c.nombre;