USE RENTAL_CARS;
 
-- tabla de auditoria para el primer trigger
CREATE TABLE IF NOT EXISTS AUDITORIA_ALQUILERES (
  id_auditoria   INT AUTO_INCREMENT PRIMARY KEY,
  id_alquiler    INT NOT NULL,
  id_cliente     INT NOT NULL,
  id_vehiculo    INT NOT NULL,
  fecha_registro DATETIME NOT NULL,
  accion         VARCHAR(50) NOT NULL
);
 
 
-- 1
--este drop permite volver a ejecutar el script sin que falle por un trigger ya creado
DROP TRIGGER IF EXISTS TR_AUDITAR_ALQUILER;
 
DELIMITER $$
 
CREATE TRIGGER TR_AUDITAR_ALQUILER
AFTER INSERT ON ALQUILERES
FOR EACH ROW
BEGIN
  INSERT INTO AUDITORIA_ALQUILERES (id_alquiler, id_cliente, id_vehiculo, fecha_registro, accion)
  VALUES (NEW.id_alquiler, NEW.id_cliente, NEW.id_vehiculo, NOW(), 'NUEVO ALQUILER');
END$$
 
DELIMITER ;


-- 2

DROP TRIGGER IF EXISTS TR_ACTUALIZAR_ESTADO_VEHICULO;
 
DELIMITER $$
 
CREATE TRIGGER TR_ACTUALIZAR_ESTADO_VEHICULO
AFTER INSERT ON ALQUILERES
FOR EACH ROW
BEGIN
  IF NEW.estado = 'activo' THEN
    UPDATE VEHICULOS
    SET estado = FALSE
    WHERE id = NEW.id_vehiculo;
  END IF;
END$$
 
DELIMITER ;