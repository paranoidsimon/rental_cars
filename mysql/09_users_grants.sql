-- 1. Crear el usuario vendedor_user con una contraseña segura
CREATE USER IF NOT EXISTS 'vendedor_user'@'localhost'
  IDENTIFIED BY 'Vend3dor_Seg#2026';
 
-- 2. Solo lectura (SELECT) sobre VEHICULOS, CATEGORIAS y SUCURSALES
GRANT SELECT ON RENTAL_CARS.VEHICULOS  TO 'vendedor_user'@'localhost';
GRANT SELECT ON RENTAL_CARS.CATEGORIAS TO 'vendedor_user'@'localhost';
GRANT SELECT ON RENTAL_CARS.SUCURSALES TO 'vendedor_user'@'localhost';
 
-- 3. Lectura y escritura sobre ALQUILERES y PAGOS
GRANT SELECT, INSERT, UPDATE, DELETE ON RENTAL_CARS.ALQUILERES TO 'vendedor_user'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON RENTAL_CARS.PAGOS      TO 'vendedor_user'@'localhost';
 
-- 4. Crear admin_user con todos los privilegios sobre la base de datos completa
CREATE USER IF NOT EXISTS 'admin_user'@'localhost'
  IDENTIFIED BY 'Adm1n_Seg#2026';
 
GRANT ALL PRIVILEGES ON RENTAL_CARS.* TO 'admin_user'@'localhost';
 
-- 5. Revocar DELETE sobre ALQUILERES al vendedor
REVOKE DELETE ON RENTAL_CARS.ALQUILERES FROM 'vendedor_user'@'localhost';
 
-- Verificación de permisos
SHOW GRANTS FOR 'vendedor_user'@'localhost';
SHOW GRANTS FOR 'admin_user'@'localhost';