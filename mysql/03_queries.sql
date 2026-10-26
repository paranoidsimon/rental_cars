
-- CONSULTA 1
SELECT marca, modelo, anio
FROM VEHICULOS
ORDER BY anio ASC;
 
-- CONSULTA 2
SELECT nombre, email, ciudad
FROM CLIENTES
WHERE fecha_registro >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
  AND fecha_registro <  DATE_FORMAT(CURDATE(), '%Y-%m-01');
 
-- CONSULTA 3
SELECT marca, modelo, precio_dia
FROM VEHICULOS
WHERE id_categoria = 2;
 
-- CONSULTA 4
SELECT *
FROM EMPLEADOS
WHERE nombre LIKE 'L%';
 
-- CONSULTA 5
SELECT nombre, cargo
FROM EMPLEADOS
WHERE salario <> 180000.00;
 
-- CONSULTA 6
SELECT v.marca, v.modelo, c.nombre AS categoria
FROM VEHICULOS v
INNER JOIN CATEGORIAS c ON c.id = v.id_categoria;
 
-- CONSULTA 7
SELECT a.fecha_inicio,
       cl.nombre                           AS cliente,
       CONCAT(v.marca, ' ', v.modelo)      AS vehiculo,
       e.nombre                            AS empleado
FROM ALQUILERES a
INNER JOIN CLIENTES  cl ON cl.id = a.id_cliente
INNER JOIN VEHICULOS v  ON v.id  = a.id_vehiculo
INNER JOIN EMPLEADOS e  ON e.id  = a.id_empleado;
 
-- CONSULTA 8
SELECT nombre, ciudad, fecha_registro
FROM CLIENTES;
 
-- CONSULTA 9
SELECT v.marca, v.modelo, s.nombre AS sucursal, s.ciudad
FROM VEHICULOS v
INNER JOIN SUCURSALES s ON s.id = v.id_sucursal;
 
-- CONSULTA 10
SELECT a.id_alquiler,
       sr.nombre AS sucursal_retiro,
       sd.nombre AS sucursal_devolucion
FROM ALQUILERES a
INNER JOIN SUCURSALES sr ON sr.id = a.id_sucursal_retiro
INNER JOIN SUCURSALES sd ON sd.id = a.id_sucursal_devolucion;
 
-- CONSULTA 11
SELECT c.nombre AS categoria, COUNT(v.id) AS cantidad_vehiculos
FROM CATEGORIAS c
LEFT JOIN VEHICULOS v ON v.id_categoria = c.id
GROUP BY c.id, c.nombre;
 
-- CONSULTA 12
SELECT c.nombre AS categoria, ROUND(AVG(v.precio_dia), 2) AS precio_promedio_dia
FROM CATEGORIAS c
INNER JOIN VEHICULOS v ON v.id_categoria = c.id
GROUP BY c.id, c.nombre;
 
-- CONSULTA 13
SELECT e.nombre AS empleado, COUNT(a.id_alquiler) AS total_alquileres
FROM EMPLEADOS e
LEFT JOIN ALQUILERES a ON a.id_empleado = e.id
GROUP BY e.id, e.nombre
ORDER BY total_alquileres DESC;
 
-- CONSULTA 14
SELECT cl.nombre, COUNT(a.id_alquiler) AS cantidad_alquileres
FROM CLIENTES cl
INNER JOIN ALQUILERES a ON a.id_cliente = cl.id
GROUP BY cl.id, cl.nombre
HAVING COUNT(a.id_alquiler) > 1;
 
-- CONSULTA 15
SELECT ciudad, COUNT(*) AS cantidad_sucursales
FROM SUCURSALES
GROUP BY ciudad;
 
-- CONSULTA 16
SELECT marca, modelo, anio
FROM VEHICULOS
WHERE anio = (SELECT MIN(anio) FROM VEHICULOS);
 
-- CONSULTA 17
SELECT v.id, v.marca, v.modelo, v.anio
FROM VEHICULOS v
LEFT JOIN ALQUILERES a ON a.id_vehiculo = v.id
WHERE a.id_alquiler IS NULL;
 
-- CONSULTA 18
SELECT *
FROM ALQUILERES
WHERE estado = 'activo'
  AND fecha_inicio >= '2024-10-01'
  AND fecha_inicio <  '2024-11-01';
 
-- CONSULTA 19
SELECT marca, modelo, precio_dia
FROM VEHICULOS
ORDER BY precio_dia DESC
LIMIT 3;
 
-- CONSULTA 20
SELECT COUNT(*) AS multas_pagadas,
       COALESCE(SUM(monto), 0) AS monto_total_recaudado
FROM MULTAS
WHERE pagada = 1;
 