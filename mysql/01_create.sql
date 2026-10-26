
--crear base de datos
CREATE DATABASE IF NOT EXISTS RENTAL_CARS
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
 
USE RENTAL_CARS;

--crear tablas
CREATE TABLE SUCURSALES (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  nombre    VARCHAR(80)  NOT NULL,
  direccion VARCHAR(120) NOT NULL,
  ciudad    VARCHAR(50)  NOT NULL,
  telefono  VARCHAR(30)
);
 
CREATE TABLE CATEGORIAS (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(50) NOT NULL,
  descripcion VARCHAR(120)
);
 
CREATE TABLE CLIENTES (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  nombre            VARCHAR(50) NOT NULL,
  email             VARCHAR(50),
  telefono          VARCHAR(50),
  ciudad            VARCHAR(50),
  fecha_registro    DATE NOT NULL,
  licencia_conducir VARCHAR(30) NOT NULL UNIQUE
);
 
CREATE TABLE EMPLEADOS (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(80) NOT NULL,
  cargo         VARCHAR(50) NOT NULL,
  id_sucursal   INT NOT NULL,
  fecha_ingreso DATE NOT NULL,
  salario       DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_empleados_sucursal
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSALES(id)
);
 
CREATE TABLE VEHICULOS (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  marca        VARCHAR(50) NOT NULL,
  modelo       VARCHAR(50) NOT NULL,
  anio         INT NOT NULL,
  precio_dia   DECIMAL(9,2) NOT NULL,
  estado       TINYINT(1) NOT NULL DEFAULT 1,   -- 1 = disponible, 0 = no disponible
  id_categoria INT NOT NULL,
  id_sucursal  INT NOT NULL,
  patente      VARCHAR(15) NOT NULL UNIQUE,
  km_actual    INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_vehiculos_categoria
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id),
  CONSTRAINT fk_vehiculos_sucursal
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSALES(id)
);
 
CREATE TABLE ALQUILERES (
  id_alquiler           INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente            INT NOT NULL,
  id_vehiculo           INT NOT NULL,
  fecha_inicio          DATE NOT NULL,
  fecha_fin             DATE NOT NULL,
  total                 DECIMAL(9,2) NOT NULL,
  id_empleado           INT NOT NULL,
  id_sucursal_retiro    INT NOT NULL,
  id_sucursal_devolucion INT NOT NULL,
  estado                VARCHAR(20) NOT NULL,   -- 'activo', 'finalizado', 'cancelado'
  CONSTRAINT fk_alq_cliente
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id),
  CONSTRAINT fk_alq_vehiculo
    FOREIGN KEY (id_vehiculo) REFERENCES VEHICULOS(id),
  CONSTRAINT fk_alq_empleado
    FOREIGN KEY (id_empleado) REFERENCES EMPLEADOS(id),
  CONSTRAINT fk_alq_suc_retiro
    FOREIGN KEY (id_sucursal_retiro) REFERENCES SUCURSALES(id),
  CONSTRAINT fk_alq_suc_devolucion
    FOREIGN KEY (id_sucursal_devolucion) REFERENCES SUCURSALES(id)
);
 
CREATE TABLE SEGUROS (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  id_alquiler   INT NOT NULL,
  compania      VARCHAR(80) NOT NULL,
  numero_poliza VARCHAR(50) NOT NULL,
  cobertura     VARCHAR(100),
  costo         DECIMAL(9,2) NOT NULL,
  CONSTRAINT fk_seguros_alquiler
    FOREIGN KEY (id_alquiler) REFERENCES ALQUILERES(id_alquiler)
);
 
CREATE TABLE PAGOS (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  id_alquiler INT NOT NULL,
  fecha_pago  DATE NOT NULL,
  monto       DECIMAL(9,2) NOT NULL,
  CONSTRAINT fk_pagos_alquiler
    FOREIGN KEY (id_alquiler) REFERENCES ALQUILERES(id_alquiler)
);
 
CREATE TABLE CHECK_ALQUILER (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  id_alquiler       INT NOT NULL,
  tipo              VARCHAR(10) NOT NULL,   -- 'salida' o 'entrada'
  fecha             DATETIME NOT NULL,
  km                INT NOT NULL,
  nivel_combustible INT NOT NULL,           -- porcentaje 0-100
  CONSTRAINT fk_check_alquiler
    FOREIGN KEY (id_alquiler) REFERENCES ALQUILERES(id_alquiler)
);
 
CREATE TABLE MULTAS (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  id_alquiler INT NOT NULL,
  fecha       DATE NOT NULL,
  motivo      VARCHAR(120) NOT NULL,
  monto       DECIMAL(9,2) NOT NULL,
  pagada      TINYINT(1) NOT NULL DEFAULT 0,
  CONSTRAINT fk_multas_alquiler
    FOREIGN KEY (id_alquiler) REFERENCES ALQUILERES(id_alquiler)
);
 
CREATE TABLE RESERVAS (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente    INT NOT NULL,
  id_vehiculo   INT NOT NULL,
  fecha_reserva DATE NOT NULL,
  fecha_inicio  DATE NOT NULL,
  fecha_fin     DATE NOT NULL,
  estado        VARCHAR(20) NOT NULL,
  CONSTRAINT fk_reservas_cliente
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id),
  CONSTRAINT fk_reservas_vehiculo
    FOREIGN KEY (id_vehiculo) REFERENCES VEHICULOS(id)
);
 
CREATE TABLE MANTENIMIENTOS (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo   INT NOT NULL,
  fecha         DATE NOT NULL,
  tipo          VARCHAR(50) NOT NULL,
  costo         DECIMAL(9,2) NOT NULL,
  observaciones VARCHAR(200),
  CONSTRAINT fk_mant_vehiculo
    FOREIGN KEY (id_vehiculo) REFERENCES VEHICULOS(id)
);