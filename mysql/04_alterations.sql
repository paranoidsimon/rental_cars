-- 1
INSERT INTO CLIENTES (nombre, email, telefono, ciudad, fecha_registro, licencia_conducir)
VALUES ('Romina Acosta', 'romina.acosta@mail.com', '264-5559009', 'San Juan', CURDATE(), 'LIC-0009');
-- prueba
SELECT * FROM CLIENTES WHERE licencia_conducir = 'LIC-0009';

-- 2
UPDATE EMPLEADOS
SET salario = 200000.00
WHERE cargo IN ('Vendedor', 'Vendedora')
  AND fecha_ingreso < '2021-01-01';
--prueba
SELECT id, nombre, cargo, fecha_ingreso, salario FROM EMPLEADOS;

-- 3
-- compruebo que no haya registros asociados (las tres consultas deben dar 0)
SELECT COUNT(*) AS alquileres      FROM ALQUILERES    WHERE id_vehiculo = 10;
SELECT COUNT(*) AS reservas        FROM RESERVAS      WHERE id_vehiculo = 10;
SELECT COUNT(*) AS mantenimientos  FROM MANTENIMIENTOS WHERE id_vehiculo = 10;
 
DELETE FROM VEHICULOS
WHERE id = 10;
-- prueba (no debe devolver filas)
SELECT * FROM VEHICULOS WHERE id = 10;

-- 4
UPDATE VEHICULOS
SET id_sucursal = 2
WHERE id = 1;
-- prueba
SELECT id, marca, modelo, id_sucursal FROM VEHICULOS WHERE id = 1;