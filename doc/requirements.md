# Requerimientos — Base de datos RENTAL_CARS

## 1. Descripción

Base de datos relacional para un sistema de **alquiler de vehículos**. Centraliza la información de sucursales, empleados, clientes, flota organizada por categorías, alquileres, reservas, pagos, seguros, multas, mantenimientos y chequeos de entrada y salida, y garantiza la integridad y la trazabilidad de la operación.

## 2. Stack tecnológico

| Componente | Detalle |
|------------|---------|
| Motor de base de datos | MySQL 8.4 |
| Contenedores | Docker y Docker Compose |
| Administración | phpMyAdmin y DBeaver |
| Motor de almacenamiento | InnoDB |

## 3. Requisitos funcionales (RF)

### Gestión de datos maestros

- **RF-01** El sistema debe registrar sucursales con nombre, dirección, ciudad y teléfono.
- **RF-02** El sistema debe registrar empleados con nombre, cargo, sucursal asignada, fecha de ingreso y salario. Cada empleado pertenece a una única sucursal.
- **RF-03** El sistema debe registrar clientes con nombre, email, teléfono, ciudad, fecha de registro y licencia de conducir. La licencia debe ser única por cliente.
- **RF-04** El sistema debe organizar la flota en categorías con nombre y descripción.
- **RF-05** El sistema debe registrar vehículos con marca, modelo, año, precio por día, kilometraje actual, patente única, categoría, sucursal y estado de disponibilidad.

### Gestión operativa

- **RF-06** El sistema debe registrar alquileres que relacionen cliente, vehículo y empleado, con fechas de inicio y fin, total, estado, sucursal de retiro y sucursal de devolución, que pueden ser distintas.
- **RF-07** El sistema debe registrar reservas de vehículos por cliente, con fecha de reserva, período solicitado y estado.
- **RF-08** El sistema debe registrar los pagos asociados a un alquiler, permitiendo más de un pago por alquiler.
- **RF-09** El sistema debe registrar los seguros contratados en un alquiler, con compañía, número de póliza, cobertura y costo.
- **RF-10** El sistema debe registrar multas asociadas a un alquiler, indicando motivo, monto, fecha y si fueron pagadas.
- **RF-11** El sistema debe registrar los mantenimientos de cada vehículo, con fecha, tipo, costo y observaciones.
- **RF-12** El sistema debe registrar chequeos de salida y de entrada de cada alquiler, con fecha, kilometraje y nivel de combustible, en una única estructura diferenciada por tipo.
- **RF-13** El sistema debe permitir modificar datos existentes: dar de alta clientes, actualizar salarios según cargo y antigüedad, trasladar vehículos entre sucursales y dar de baja vehículos que no tengan alquileres, reservas ni mantenimientos asociados.

### Consultas y reportes

- **RF-14** El sistema debe permitir consultar la flota filtrando y ordenando por marca, modelo, año, categoría, sucursal y precio.
- **RF-15** El sistema debe permitir consultar clientes y empleados según criterios como fecha de registro, nombre, cargo y salario.
- **RF-16** El sistema debe permitir obtener indicadores agregados: vehículos por categoría, precio promedio por categoría, alquileres por empleado, alquileres por cliente, sucursales por ciudad y total recaudado en multas pagadas.
- **RF-17** El sistema debe permitir identificar vehículos que nunca fueron alquilados y los alquileres activos de un período determinado.
- **RF-18** El sistema debe ofrecer una vista con el detalle legible de los alquileres (cliente, vehículo, empleado, sucursales, fechas y total) sin mostrar identificadores numéricos.
- **RF-19** El sistema debe ofrecer una vista con la cantidad de vehículos de cada sucursal y su ciudad.
- **RF-20** El sistema debe ofrecer una vista con la cantidad de alquileres finalizados y el monto facturado por categoría.

### Automatización y reglas de negocio

- **RF-21** Cada vez que se registre un alquiler, el sistema debe dejar un registro de auditoría con el alquiler, el cliente, el vehículo, la fecha y hora y la acción realizada.
- **RF-22** Cuando se registre un alquiler con estado activo, el sistema debe marcar automáticamente el vehículo como no disponible.
- **RF-23** El sistema debe ofrecer un procedimiento para registrar alquileres que valide la existencia y disponibilidad del vehículo y la coherencia de las fechas, calcule el total (días por precio diario), inserte el alquiler como activo y confirme la operación.
- **RF-24** El sistema debe ofrecer un procedimiento para registrar multas que valide que el alquiler exista, inserte la multa como no pagada con la fecha actual y confirme la operación.

### Seguridad y control de acceso

- **RF-25** El sistema debe contar con un rol de vendedor con permisos de solo lectura sobre vehículos, categorías y sucursales, y de lectura y escritura sobre alquileres y pagos, sin posibilidad de eliminar alquileres.
- **RF-26** El sistema debe contar con un rol de administrador con todos los privilegios sobre la base de datos.

## 4. Requisitos no funcionales (RNF)

### Integridad y consistencia

- **RNF-01** Las relaciones entre tablas deben garantizarse con claves foráneas, y el motor InnoDB debe estar activo para que se apliquen.
- **RNF-02** El borrado de registros con dependencias debe rechazarse (`RESTRICT`), de modo que no se pierda el historial de alquileres, reservas ni mantenimientos.
- **RNF-03** Los campos obligatorios deben definirse como `NOT NULL`, y los identificadores de negocio (patente, licencia de conducir) como `UNIQUE`.
- **RNF-04** El modelo debe estar normalizado, evitando datos repetidos como el texto de la categoría en cada vehículo.

### Seguridad

- **RNF-05** Las credenciales deben almacenarse en un archivo `.env` excluido del control de versiones.
- **RNF-06** Los usuarios deben seguir el principio de mínimo privilegio y utilizar contraseñas robustas.
- **RNF-07** Los puertos de MySQL y de phpMyAdmin no deben exponerse en entornos accesibles desde internet.

### Disponibilidad y persistencia

- **RNF-08** Los datos deben persistir en un volumen de Docker, de modo que se conserven al detener o recrear los contenedores.
- **RNF-09** Los servicios deben reiniciarse automáticamente ante fallos (`restart: unless-stopped`).
- **RNF-10** El servicio de MySQL debe contar con un chequeo de salud, y phpMyAdmin debe iniciarse únicamente cuando la base de datos esté lista.

### Compatibilidad y configuración

- **RNF-11** La base de datos debe usar codificación `utf8mb4` con colación `utf8mb4_unicode_ci` para soportar tildes y caracteres especiales.
- **RNF-12** Los contenedores deben operar en la zona horaria `America/Argentina/San_Juan`, ya que las fechas automáticas dependen de ella.
- **RNF-13** El entorno debe ser configurable mediante variables (puertos, credenciales, base inicial y zona horaria) sin modificar el `docker-compose.yml`.
- **RNF-14** El entorno debe ser accesible desde clientes gráficos (DBeaver) y desde la interfaz web de phpMyAdmin.

### Mantenibilidad y rendimiento

- **RNF-15** Los scripts deben poder ejecutarse más de una vez sin fallar (`IF NOT EXISTS`, `DROP ... IF EXISTS`, `CREATE OR REPLACE`).
- **RNF-16** Las claves primarias deben ser enteros autoincrementales, y las restricciones deben tener nombres descriptivos (por ejemplo `fk_alq_cliente`) para facilitar su identificación.
- **RNF-17** Los filtros por fechas deben expresarse como rangos para aprovechar índices.
- **RNF-18** Los datos de prueba deben ser suficientes y consistentes para que cada consulta devuelva al menos un resultado, y las fechas relativas deben calcularse con `CURDATE()` para que sigan siendo válidas con el paso del tiempo.
- **RNF-19** El entorno debe poder reconstruirse desde cero con `docker compose down -v` y `docker compose up -d`.

## 5. Configuración del entorno

| Variable | Descripción |
|----------|-------------|
| `MYSQL_ROOT_PASSWORD` | Contraseña del usuario `root` |
| `MYSQL_DATABASE` | Base de datos inicial |
| `MYSQL_USER` / `MYSQL_PASSWORD` | Usuario y contraseña de aplicación |
| `MYSQL_PORT` | Puerto de MySQL (por defecto `3306`) |
| `PHPMYADMIN_PORT` | Puerto de phpMyAdmin (por defecto `8080`) |
| `TZ` | Zona horaria de los contenedores |

Puesta en marcha:

```bash
docker compose up -d
```

phpMyAdmin queda disponible en `http://localhost:8080`.
