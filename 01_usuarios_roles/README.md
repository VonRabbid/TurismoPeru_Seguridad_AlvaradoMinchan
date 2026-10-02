# Actividad 4: Administración de la Seguridad y Principio de Mínimo Privilegio

**Asignatura:** Base de Datos II (Grupo B) — Evaluación 3  
**Institución:** Universidad Nacional de Cajamarca  
**Autor:** Cristian Paul Alvarado Minchan / VonRabbid  
**Base de Datos:** `TURISMOPERU_CPAM`  
**Servidor:** `161.132.54.162` (Microsoft SQL Server 2022)

---

## 1. Justificación Técnica: ¿Por qué NO es adecuado asignar `db_owner` al Vendedor o al Analista?

En la administración profesional de bases de datos relacionales (RDBMS), el rol fijo `db_owner` confiere privilegios irrestrictos sobre todos los objetos, tablas, procedimientos y configuraciones dentro de una base de datos específica (actuando como superusuario de base de datos). Asignar `db_owner` a usuarios con perfiles operativos o analíticos (`rol_vendedor` o `rol_analista`) constituye una mala práctica crítica de ciberseguridad y gobernanza por los siguientes fundamentos:

### 1.1 Principio de Mínimo Privilegio (Principle of Least Privilege - PoLP)
El principio PoLP dicta que cada cuenta o servicio debe poseer únicamente los permisos estrictamente necesarios para cumplir con sus funciones asignadas:
- **Rol Vendedor (`turismo_vendedor`):** Su alcance funcional es operativo y comercial: consultar catálogos de hospedaje (`alojamiento`, `habitacion`), registrar clientes (`CPAM.cliente`) y generar reservaciones (`CPAM.reserva`). No requiere privilegios para alterar el esquema (`ALTER TABLE`, `DROP TABLE`), ni para gestionar usuarios de base de datos, ni para crear copias de respaldo.
- **Rol Analista (`turismo_analista`):** Su función se limita a la inteligencia de negocios, minería de datos y reportería analítica. Exige acceso de solo lectura (`SELECT`). Concederle permisos de escritura, modificación o borrado vulnera el principio de aislamiento de datos y pone en riesgo la confiabilidad de los registros.

### 1.2 Mitigación de Riesgos Frente a Inyección SQL (SQL Injection - SQLi)
Si los módulos de software de la empresa (aplicaciones web, sistemas de punto de venta o portales de reserva) utilizan conexiones autenticadas con privilegios de `db_owner`, cualquier falla de validación de entrada susceptible a inyecciones SQL otorgaría al atacante control total sobre el motor de base de datos:
- Podría ejecutar `DROP TABLE`, `TRUNCATE TABLE`, deshabilitar restricciones de integridad (`NOCHECK CONSTRAINT`), sustraer información confidencial de clientes o crear cuentas de acceso secundarias con privilegios administrativos.
- Con la asignación granular de permisos, si la cuenta del vendedor sufre un intento de explotación SQLi, el motor SQL Server rechaza cualquier sentencia `DELETE`, bloqueando el daño. De igual forma, si la cuenta del analista se ve comprometida, no podrá realizar ninguna acción de inserción, actualización ni borrado (`DENY INSERT, UPDATE, DELETE`).

### 1.3 Control de Borrado Accidental e Integridad Histórica / Tributaria (SUNAT)
- En un sistema de gestión turística, los registros de ventas, reservas y clientes constituyen documentos de valor legal, contable y tributario. La normativa tributaria peruana (SUNAT) exige la conservación e inalterabilidad de los comprobantes y expedientes de transacción comercial.
- Un usuario con rol `db_owner` podría accidentalmente ejecutar un comando `DELETE` o `UPDATE` masivo sin cláusula `WHERE`. La aplicación explícita de `DENY DELETE ON CPAM.cliente` y `DENY DELETE ON CPAM.reserva` garantiza que los datos históricos no puedan ser purgados físicamente por los operadores, obligando a emplear cambios de estado lógico (anulaciones controladas) para preservar la trazabilidad y la auditoría.

### 1.4 Separación de Funciones (Separation of Duties - SoD) bajo Normas Internacionales
Estándares internacionales de seguridad y cumplimiento (tales como **ISO/IEC 27001**, **PCI-DSS v4.0** y **COBIT**) establecen que deben separarse estrictamente las responsabilidades:
- **Administración y Seguridad (DBA / `turismo_admin`):** Mantenimiento de esquemas, roles, usuarios y respaldos.
- **Operación Comercial (`turismo_vendedor`):** Registro de transacciones ordinarias de ventas.
- **Auditoría e Inteligencia (`turismo_analista`):** Consulta analítica y evaluación estadística.
La concentración de privilegios administrativos en cuentas de usuario final viola las políticas de control interno y anula la validez de cualquier auditoría forense.

---

## 2. Matriz de Permisos Implementada

| Objeto / Esquema | Operación | Rol: `rol_vendedor` | Rol: `rol_analista` | Justificación |
| :--- | :--- | :--- | :--- | :--- |
| `CPAM.cliente` | `SELECT` | **GRANT** | **GRANT** | Ambos roles requieren consultar la cartera de clientes. |
| `CPAM.cliente` | `INSERT` | **GRANT** | **DENY** | Solo el vendedor puede registrar clientes; el analista solo consulta. |
| `CPAM.cliente` | `DELETE` | **DENY** | **DENY** | Prohibición absoluta de borrado físico para preservar trazabilidad. |
| `CPAM.reserva` | `SELECT` | **GRANT** | **GRANT** | Ambos consultan contratos de reservas. |
| `CPAM.reserva` | `INSERT` | **GRANT** | **DENY** | El vendedor crea reservas; el analista no genera contratos. |
| `CPAM.reserva` | `DELETE` | **DENY** | **DENY** | Restricción estricta de borrado de contratos turísticos. |
| `CPAM.pago` | `SELECT` | Denegado por defecto | **GRANT** | El analista requiere auditar los flujos monetarios y recaudación. |
| `CPAM.pago` | `INSERT`, `UPDATE`, `DELETE` | Denegado por defecto | **DENY** | Ningún analista puede alterar la contabilidad de pagos. |
| `CPAM.alojamiento` / `habitacion` | `SELECT` | **GRANT** | **GRANT** | Consulta del catálogo de hoteles y disponibilidad. |
| `CPAM.paquete` / `lugar_turistico`| `SELECT` | Denegado por defecto | **GRANT** | Auditoría y minería de destinos y paquetes turísticos. |
| Esquemas `CPAM` y `dbo` | Modificaciones DML | Denegado por defecto | **DENY** | Denegación explícita total de modificación en todas las tablas. |
| Base de Datos | `BACKUP DATABASE/LOG` | **DENY** | **DENY** | Tarea exclusiva del DBA administrador (`turismo_admin`). |
| Base de Datos | `ALTER ANY USER/ROLE` | **DENY** | **DENY** | Prohibición de escalamiento de privilegios o gestión de cuentas. |

---

## 3. Demostración Práctica de Denegación (Error 229)

Las pruebas fueron codificadas y ejecutadas en el script `04_seguridad/pruebas_permisos.sql` utilizando la instrucción `EXECUTE AS USER`:

### 3.1 Auditoría del Usuario `turismo_analista`
1. **Lectura Autorizada (`SELECT` en `CPAM.pago`):**
   ```sql
   EXECUTE AS USER = 'turismo_analista';
   SELECT TOP 3 id_pago, id_reserva, monto, fecha_pago, estado FROM CPAM.pago;
   ```
   *Resultado:* **Éxito**. Se consultaron 3 registros correctamente sin restricción.
2. **Rechazo Obligatorio de Escritura (`INSERT` en `CPAM.pago`):**
   ```sql
   INSERT INTO CPAM.pago (id_reserva, id_medio_pago, monto, fecha_pago, estado)
   VALUES (1, 1, 999.99, GETDATE(), 'AuditTest');
   ```
   *Resultado del Motor SQL Server:*
   ```text
   Msg 229, Level 14, State 5, Server 85a955a86989
   The INSERT permission was denied on the object 'pago', database 'TURISMOPERU_CPAM', schema 'CPAM'.
   ```
   *Mensaje de control:* `Error 229: Permiso INSERT denegado como se esperaba para turismo_analista.`

### 3.2 Auditoría del Usuario `turismo_vendedor`
1. **Lectura Autorizada (`SELECT` en `CPAM.reserva`):**
   ```sql
   EXECUTE AS USER = 'turismo_vendedor';
   SELECT TOP 3 id_reserva, codigo_reserva, precio_total, fecha_reserva FROM CPAM.reserva;
   ```
   *Resultado:* **Éxito**. Consulta comercial ejecutada correctamente.
2. **Rechazo Obligatorio de Eliminación (`DELETE` en `CPAM.reserva`):**
   ```sql
   DELETE FROM CPAM.reserva WHERE id_reserva = -1;
   ```
   *Resultado del Motor SQL Server:*
   ```text
   Msg 229, Level 14, State 5, Server 85a955a86989
   The DELETE permission was denied on the object 'reserva', database 'TURISMOPERU_CPAM', schema 'CPAM'.
   ```
   *Mensaje de control:* `Error 229: Permiso DELETE en reserva denegado como se esperaba para turismo_vendedor.`
3. **Rechazo Obligatorio de Eliminación (`DELETE` en `CPAM.cliente`):**
   ```sql
   DELETE FROM CPAM.cliente WHERE id_persona = -1;
   ```
   *Resultado del Motor SQL Server:*
   ```text
   Msg 229, Level 14, State 5, Server 85a955a86989
   The DELETE permission was denied on the object 'cliente', database 'TURISMOPERU_CPAM', schema 'CPAM'.
   ```
   *Mensaje de control:* `Error 229: Permiso DELETE en cliente denegado como se esperaba para turismo_vendedor.`

---

## 4. Evidencia Gráfica en Consola
La captura de la terminal demostrando la autenticación y la captura de las excepciones de Error 229 se encuentra guardada en el repositorio en:
- `evidencias/login.png`: Autenticación y configuración de membresías.
- `evidencias/permisos.png`: Auditoría de ejecución y capturas del Error 229.
