USE RENTAL_CARS;
 
-- 1
DROP PROCEDURE IF EXISTS SP_REGISTRAR_ALQUILER;
 
DELIMITER $$
 
CREATE PROCEDURE SP_REGISTRAR_ALQUILER (
  IN p_id_cliente   INT,
  IN p_id_vehiculo  INT,
  IN p_id_empleado  INT,
  IN p_fecha_inicio DATE,
  IN p_fecha_fin    DATE
)
BEGIN
  DECLARE v_estado   TINYINT       DEFAULT NULL;
  DECLARE v_precio   DECIMAL(9,2)  DEFAULT NULL;
  DECLARE v_sucursal INT           DEFAULT NULL;
  DECLARE v_dias     INT;
  DECLARE v_total    DECIMAL(9,2);
 
  -- Validación de fechas
  IF p_fecha_fin < p_fecha_inicio THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Error: la fecha de fin no puede ser anterior a la fecha de inicio';
  END IF;
 
  -- Datos del vehículo
  SELECT estado, precio_dia, id_sucursal
    INTO v_estado, v_precio, v_sucursal
  FROM VEHICULOS
  WHERE id = p_id_vehiculo;
 
  -- a) Verificar que el vehículo exista y esté disponible (estado = TRUE)
  IF v_estado IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Error: el vehículo no existe';
  ELSEIF v_estado = FALSE THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Error: el vehículo no está disponible';
  END IF;
 
  -- b) Calcular el total = días de alquiler * precio por día
  SET v_dias  = DATEDIFF(p_fecha_fin, p_fecha_inicio);
  SET v_total = v_dias * v_precio;
 
  -- c) Insertar el alquiler con estado 'activo'
  --    Retiro y devolución en la sucursal donde está el vehículo
  INSERT INTO ALQUILERES
    (id_cliente, id_vehiculo, fecha_inicio, fecha_fin, total,
     id_empleado, id_sucursal_retiro, id_sucursal_devolucion, estado)
  VALUES
    (p_id_cliente, p_id_vehiculo, p_fecha_inicio, p_fecha_fin, v_total,
     p_id_empleado, v_sucursal, v_sucursal, 'activo');
 
  -- d) Mensaje de éxito
  SELECT 'Alquiler registrado correctamente' AS mensaje;
END$$
 
DELIMITER ;
 
 
-- 2
DROP PROCEDURE IF EXISTS SP_CALCULAR_MULTA;
 
DELIMITER $$
 
CREATE PROCEDURE SP_CALCULAR_MULTA (
  IN p_id_alquiler INT,
  IN p_motivo      VARCHAR(120),
  IN p_monto       DECIMAL(9,2)
)
BEGIN
  -- a) Verificar que el alquiler exista
  IF NOT EXISTS (SELECT 1 FROM ALQUILERES WHERE id_alquiler = p_id_alquiler) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Error: el alquiler no existe';
  END IF;
 
  -- b) Insertar la multa (no pagada, con la fecha actual)
  INSERT INTO MULTAS (id_alquiler, fecha, motivo, monto, pagada)
  VALUES (p_id_alquiler, CURDATE(), p_motivo, p_monto, FALSE);
 
  -- c) Mensaje de éxito
  SELECT 'Multa registrada correctamente' AS mensaje;
END$$
 
DELIMITER ;
 
 
--pruebas
 
-- Alquiler válido: vehículo 9 (Peugeot 208, disponible), 3 días * 28000 = 84000
CALL SP_REGISTRAR_ALQUILER(7, 9, 6, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 3 DAY));
SELECT * FROM ALQUILERES ORDER BY id_alquiler DESC LIMIT 1;
 
-- Debe fallar: vehículo 7 no está disponible
CALL SP_REGISTRAR_ALQUILER(7, 7, 6, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 3 DAY));
 
-- Multa válida
CALL SP_CALCULAR_MULTA(1, 'Rayón en el paragolpes', 20000.00);
SELECT * FROM MULTAS ORDER BY id DESC LIMIT 1;
 
-- Debe fallar: el alquiler no existe
CALL SP_CALCULAR_MULTA(999, 'Prueba', 1000.00);
 