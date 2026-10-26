
INSERT INTO SUCURSALES (nombre, direccion, ciudad, telefono) VALUES
('Sucursal Centro San Juan', 'Av. Libertador 1200',  'San Juan', '264-4201001'),
('Sucursal Aeropuerto',      'Ruta 20 Km 12',        'San Juan', '264-4201002'),
('Sucursal Mendoza',         'Av. San Martín 850',   'Mendoza',  '261-4305500'),
('Sucursal Córdoba',         'Av. Colón 1500',       'Córdoba',  '351-4207700');
 
INSERT INTO CATEGORIAS (nombre, descripcion) VALUES
('Sedán',     'Autos de cuatro puertas, ideales para ciudad y ruta'),
('SUV',       'Vehículos utilitarios deportivos, mayor espacio y altura'),
('Pick-up',   'Camionetas de carga, ideales para terrenos difíciles'),
('Económico', 'Autos compactos de bajo consumo y bajo costo');
 
-- Clientes 7 y 8 se registran "el mes anterior" a la fecha en que se ejecute el script
INSERT INTO CLIENTES (nombre, email, telefono, ciudad, fecha_registro, licencia_conducir) VALUES
('Juan Martínez',   'juan.martinez@mail.com',   '264-5551001', 'San Juan', '2024-01-15', 'LIC-0001'),
('María López',     'maria.lopez@mail.com',     '264-5551002', 'San Juan', '2024-02-20', 'LIC-0002'),
('Pedro Sánchez',   'pedro.sanchez@mail.com',   '261-5552003', 'Mendoza',  '2024-03-05', 'LIC-0003'),
('Sofía Ramírez',   'sofia.ramirez@mail.com',   '351-5553004', 'Córdoba',  '2024-04-18', 'LIC-0004'),
('Diego Castro',    'diego.castro@mail.com',    '264-5551005', 'San Juan', '2024-06-10', 'LIC-0005'),
('Valentina Silva', 'valentina.silva@mail.com', '261-5552006', 'Mendoza',  '2024-08-22', 'LIC-0006'),
('Camila Díaz',     'camila.diaz@mail.com',     '351-5553007', 'Córdoba',  DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 'LIC-0007'),
('Federico Molina', 'federico.molina@mail.com', '264-5551008', 'San Juan', DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 'LIC-0008');
 
INSERT INTO EMPLEADOS (nombre, cargo, id_sucursal, fecha_ingreso, salario) VALUES
('Laura Gómez',     'Gerente',        1, '2018-02-15', 250000.00),
('Carlos Pérez',    'Vendedor',       1, '2019-06-10', 150000.00),
('Lucía Fernández', 'Vendedora',      2, '2020-09-01', 160000.00),
('Martín Ruiz',     'Vendedor',       3, '2022-03-20', 180000.00),
('Ana Torres',      'Administrativa', 3, '2021-05-12', 170000.00),
('Luis Herrera',    'Mecánico',       4, '2023-01-09', 190000.00);
 
-- Categorías: 1 Sedán, 2 SUV, 3 Pick-up, 4 Económico
-- Vehículos 9 y 10 nunca fueron alquilados; el 10 no tiene reservas ni mantenimientos (se puede borrar en la Sección 3)
INSERT INTO VEHICULOS (marca, modelo, anio, precio_dia, estado, id_categoria, id_sucursal, patente, km_actual) VALUES
('Toyota',     'Corolla',  2020, 45000.00, 1, 1, 1, 'AB123CD', 62000),
('Ford',       'Focus',    2019, 38000.00, 1, 1, 2, 'AC456EF', 81000),
('Chevrolet',  'Tracker',  2022, 60000.00, 1, 2, 1, 'AD789GH', 34000),
('Volkswagen', 'Amarok',   2021, 85000.00, 1, 3, 3, 'AE012IJ', 57000),
('Renault',    'Kwid',     2018, 25000.00, 1, 4, 1, 'AF345KL', 98000),
('Fiat',       'Cronos',   2023, 42000.00, 1, 1, 4, 'AG678MN', 15000),
('Jeep',       'Renegade', 2021, 65000.00, 0, 2, 3, 'AH901OP', 49000),
('Toyota',     'Hilux',    2024, 95000.00, 0, 3, 2, 'AI234QR',  8000),
('Peugeot',    '208',      2017, 28000.00, 1, 4, 4, 'AJ567ST', 110000),
('Nissan',     'Kicks',    2020, 58000.00, 1, 2, 1, 'AK890UV', 52000);
 
-- Los alquileres 5 y 6 están 'activo' y comenzaron en octubre de 2024
INSERT INTO ALQUILERES
  (id_cliente, id_vehiculo, fecha_inicio, fecha_fin, total, id_empleado, id_sucursal_retiro, id_sucursal_devolucion, estado) VALUES
(1, 1, '2024-03-10', '2024-03-15', 225000.00, 1, 1, 1, 'finalizado'),
(2, 3, '2024-05-01', '2024-05-04', 180000.00, 2, 1, 2, 'finalizado'),
(1, 4, '2024-07-20', '2024-07-27', 595000.00, 3, 3, 3, 'finalizado'),
(3, 2, '2024-09-05', '2024-09-10', 190000.00, 1, 2, 2, 'finalizado'),
(4, 7, '2024-10-03', '2024-10-10', 455000.00, 4, 3, 1, 'activo'),
(5, 8, '2024-10-15', '2024-10-20', 475000.00, 2, 2, 2, 'activo'),
(2, 5, '2024-11-02', '2024-11-05',  75000.00, 5, 1, 1, 'finalizado'),
(6, 6, '2024-12-01', '2024-12-06', 210000.00, 6, 4, 4, 'finalizado');
 
INSERT INTO SEGUROS (id_alquiler, compania, numero_poliza, cobertura, costo) VALUES
(1, 'La Segunda',  'POL-1001', 'Todo riesgo',        15000.00),
(3, 'Sancor Seguros', 'POL-1002', 'Responsabilidad civil', 8000.00),
(5, 'La Segunda',  'POL-1003', 'Todo riesgo',        20000.00),
(6, 'Zurich',      'POL-1004', 'Todo riesgo premium', 25000.00);
 
INSERT INTO PAGOS (id_alquiler, fecha_pago, monto) VALUES
(1, '2024-03-10', 225000.00),
(2, '2024-05-01', 100000.00),
(2, '2024-05-04',  80000.00),
(3, '2024-07-20', 595000.00),
(4, '2024-09-05', 190000.00),
(5, '2024-10-03', 200000.00),
(6, '2024-10-15', 475000.00),
(7, '2024-11-02',  75000.00);
 
INSERT INTO CHECK_ALQUILER (id_alquiler, tipo, fecha, km, nivel_combustible) VALUES
(1, 'salida',  '2024-03-10 09:00:00', 61500, 100),
(1, 'entrada', '2024-03-15 18:30:00', 62000,  60),
(2, 'salida',  '2024-05-01 10:15:00', 33500, 100),
(2, 'entrada', '2024-05-04 17:45:00', 34000,  50),
(5, 'salida',  '2024-10-03 11:00:00', 48500,  90),
(6, 'salida',  '2024-10-15 08:30:00',  7500, 100);
 
INSERT INTO MULTAS (id_alquiler, fecha, motivo, monto, pagada) VALUES
(1, '2024-03-12', 'Exceso de velocidad',               35000.00, 1),
(2, '2024-05-03', 'Estacionamiento prohibido',         18000.00, 1),
(3, '2024-07-24', 'Devolución con combustible bajo',   12000.00, 0),
(4, '2024-09-08', 'Semáforo en rojo',                  45000.00, 0);
 
INSERT INTO RESERVAS (id_cliente, id_vehiculo, fecha_reserva, fecha_inicio, fecha_fin, estado) VALUES
(7, 1, '2024-12-10', '2024-12-20', '2024-12-27', 'confirmada'),
(8, 3, '2024-12-12', '2025-01-05', '2025-01-12', 'pendiente'),
(3, 4, '2024-11-20', '2024-12-01', '2024-12-05', 'cancelada');
 
INSERT INTO MANTENIMIENTOS (id_vehiculo, fecha, tipo, costo, observaciones) VALUES
(1, '2024-02-20', 'Cambio de aceite',  25000.00, 'Cambio de aceite y filtro'),
(2, '2024-04-10', 'Cambio de frenos',  60000.00, 'Pastillas y discos delanteros'),
(5, '2024-08-15', 'Alineación y balanceo', 18000.00, 'Desgaste irregular de cubiertas'),
(9, '2024-09-30', 'Revisión general',  30000.00, 'Revisión previa a inactividad');
 