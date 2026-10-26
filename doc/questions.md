# TP N° 2 SQL | Base de Datos — Sección 8: Preguntas teóricas

## 1. ¿Por qué ALQUILERES tiene dos claves foráneas hacia SUCURSALES? ¿Qué relación representa?

Porque un alquiler involucra **dos sucursales con roles distintos**: la sucursal donde el cliente **retira** el vehículo (`id_sucursal_retiro`) y la sucursal donde lo **devuelve** (`id_sucursal_devolucion`). Pueden ser la misma o diferentes (por ejemplo, retirar en San Juan y devolver en Mendoza), y una sola columna no alcanza para guardar ambos datos.

Representa **dos relaciones de uno a muchos (1:N)** independientes entre SUCURSALES y ALQUILERES:

- Una sucursal puede ser el punto de retiro de muchos alquileres, y cada alquiler tiene un único punto de retiro.
- Una sucursal puede ser el punto de devolución de muchos alquileres, y cada alquiler tiene un único punto de devolución.

No es una relación muchos a muchos, ya que cada columna guarda exactamente una sucursal por alquiler y no hace falta una tabla intermedia. En las consultas hay que unir la tabla SUCURSALES dos veces con alias distintos (por ejemplo `sr` y `sd`) para distinguir los roles.

## 2. ¿Qué debería hacer la base de datos si se borra una CATEGORIA que tiene vehículos asociados?

Hay tres opciones para el comportamiento de la clave foránea `VEHICULOS.id_categoria`:

| Opción | Qué hace | Problema |
|--------|----------|----------|
| `RESTRICT` | Rechaza el `DELETE` mientras existan vehículos de esa categoría. | Obliga a reasignar o borrar antes los vehículos (es justamente lo deseable). |
| `CASCADE` | Borra automáticamente todos los vehículos de la categoría. | Peligroso: se pierden vehículos y, en cadena, su historial de alquileres, reservas y mantenimientos, si esas claves también son `CASCADE`. |
| `SET NULL` | Deja el `id_categoria` de esos vehículos en `NULL`. | La columna debería aceptar `NULL`, y la flota quedaría con vehículos sin categoría, lo que rompe consultas e ingresos por categoría. |

**La opción más adecuada para este modelo es `RESTRICT`.** Una categoría es un dato de catálogo del que dependen el precio, los reportes y el historial de la flota; borrarla es una decisión que debe ser deliberada y no puede arrastrar información de negocio. Con `RESTRICT` la base de datos protege la integridad referencial: primero hay que mover los vehículos a otra categoría y recién después eliminar la categoría. En InnoDB, si no se especifica nada, el comportamiento por defecto (`NO ACTION`) equivale a `RESTRICT`, que es lo que usa el script.

## 3. ¿Por qué la categoría está en una tabla separada (CATEGORIAS) y no como texto en VEHICULOS?

Por **normalización** y por integridad de los datos:

- **Evita la redundancia:** el nombre y la descripción de la categoría se guardan una sola vez, no repetidos en cada vehículo.
- **Evita anomalías de actualización:** si una categoría cambia de nombre (de "Económico" a "Compacto"), se modifica una sola fila y no cientos de vehículos.
- **Evita inconsistencias y errores de tipeo:** con texto libre podrían convivir "SUV", "suv" y "S.U.V.", y las agrupaciones (`GROUP BY`) darían resultados incorrectos. Con la clave foránea solo se pueden usar categorías que existen.
- **Permite guardar atributos propios de la categoría,** como la descripción, y agregar otros en el futuro (tarifa base, tipo de licencia requerida) sin tocar VEHICULOS.
- **Es más eficiente:** comparar y unir por un entero (`id_categoria`) es más liviano que comparar cadenas de texto.

## 4. ¿Qué tipo de relación existe entre SUCURSALES y EMPLEADOS?

Es una relación **de uno a muchos (1:N)**: una sucursal tiene muchos empleados, y cada empleado pertenece a una sola sucursal.

La justificación está en el modelo: la tabla EMPLEADOS tiene una única columna `id_sucursal` (clave foránea hacia SUCURSALES). Una columna guarda un solo valor por fila, así que un empleado solo puede estar asignado a una sucursal. La clave foránea siempre se coloca del lado "muchos".

Sería una relación muchos a muchos (N:M) únicamente si un empleado pudiera trabajar en varias sucursales a la vez; en ese caso haría falta una tabla intermedia (por ejemplo `EMPLEADO_SUCURSAL`) con ambas claves foráneas.

## 5. ¿Por qué CHECK_ALQUILER tiene un campo `tipo` ('salida' o 'entrada') en lugar de dos tablas separadas? ¿Qué ventaja aporta?

Porque el chequeo de salida y el de entrada **registran exactamente la misma información** (fecha, kilometraje y nivel de combustible) y pertenecen al mismo alquiler. La única diferencia es el momento en que se hacen, y eso se expresa con un campo.

Ventajas de este diseño:

- **Sin duplicación de estructura:** una sola tabla en lugar de dos idénticas, con menos mantenimiento ante cambios (si se agrega una columna, como "daños", se hace una sola vez).
- **Consultas más simples:** se puede comparar la salida con la entrada del mismo alquiler uniendo la tabla consigo misma, por ejemplo para calcular los kilómetros recorridos o el combustible consumido:

```sql
SELECT s.id_alquiler,
       e.km - s.km AS km_recorridos,
       s.nivel_combustible - e.nivel_combustible AS combustible_consumido
FROM CHECK_ALQUILER s
INNER JOIN CHECK_ALQUILER e
        ON e.id_alquiler = s.id_alquiler
       AND s.tipo = 'salida'
       AND e.tipo = 'entrada';
```

- **Extensible:** si mañana hace falta otro tipo de chequeo (por ejemplo 'inspección intermedia'), solo se agrega un valor nuevo sin crear tablas.
- **Un solo lugar** para listar o auditar todos los chequeos de un alquiler.

Para que el campo no acepte valores inválidos conviene restringirlo, por ejemplo con `CHECK (tipo IN ('salida', 'entrada'))` o con un `ENUM`.
