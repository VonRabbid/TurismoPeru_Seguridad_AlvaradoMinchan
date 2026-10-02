# Guía Técnica de Exportación e Importación de Paquetes BACPAC (.bacpac)

**Proyecto:** TurismoPerú - Tercera Evaluación de Base de Datos II (Grupo B)  
**Autor:** Cristian Paul Alvarado Minchan  
**Institución:** Universidad Nacional de Cajamarca  
**Base de Datos:** `TURISMOPERU_CPAM`  
**Servidor Remoto:** `161.132.54.162` (SQL Server 2022 CU20 sobre Linux Ubuntu)

---

## 1. Fundamento Técnico: Diferencias Críticas entre Archivos `.bak` y `.bacpac`

| Dimensión de Comparación | Respaldo Físico (`.bak`) | Paquete de Nivel de Aplicación (`.bacpac`) |
| :--- | :--- | :--- |
| **Naturaleza del Archivo** | Respaldo binario a nivel de páginas de datos y extents del motor de almacenamiento. | Archivo comprimido tipo ZIP que encapsula el modelo lógico (DACPAC XML) y datos tabulares (archivos BCP). |
| **Dependencia del Motor** | Estrictamente dependiente de la versión del motor y la arquitectura de almacenamiento físico. | Agnóstico a la infraestructura subyacente; diseñado para migración entre plataformas heterogéneas. |
| **Rutas de Almacenamiento** | Mantiene y exige la estructura de rutas físicas (archivos `.mdf` y `.ldf`), requiriendo cláusulas `WITH MOVE`. | Permite reconstrucción completa de esquemas en cualquier ruta o directorio destino automáticamente. |
| **Casos de Uso Primarios** | Recuperación ante Desastres (Disaster Recovery), alta disponibilidad, RTO y RPO exigentes. | Migración a la nube (Azure SQL Database), cambio de sistemas operativos (Linux a Windows) y entornos de desarrollo/staging. |
| **Logs de Transacciones** | Soporta restauración puntual en el tiempo (*Point-in-Time Recovery*) mediante cadenas de log LSN. | Respaldo lógico en un único instante; no soporta restauración en el tiempo ni cadenas de transacciones. |

---

## 2. Método 1: Exportación mediante Línea de Comandos (CLI) con `SqlPackage.exe`

La utilidad `SqlPackage.exe` (SQL Server Data-Tier Application Framework - DacFx) es la herramienta estándar y automatizable para la exportación e importación de paquetes BACPAC.

### 2.1 Ubicaciones Habituales de `SqlPackage.exe` en Windows
- **DacFx v160 / SSMS 19+:**  
  `C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe`
- **Visual Studio Build Tools:**  
  `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe`
- **Instalación Global vía .NET CLI:**  
  ```powershell
  dotnet tool install -g microsoft.sqlpackage
  sqlpackage --version
  ```

### 2.2 Comando CLI Exacto para Exportación
Ejecutar el siguiente comando en PowerShell o CMD:

```powershell
SqlPackage.exe /Action:Export `
  /SourceServerName:"161.132.54.162" `
  /SourceDatabaseName:"TURISMOPERU_CPAM" `
  /SourceUser:"estudiante" `
  /SourcePassword:"Unc.2026" `
  /TargetFile:"C:\Users\vonra\Documents\BD_Exam_3\TurismoPeru_Seguridad_AlvaradoMinchan\03_backups\TurismoPeru_CPAM_Fullbacpac.bacpac" `
  /p:TrustServerCertificate=True `
  /p:CommandTimeout=120
```

### 2.3 Explicación Detallada de Parámetros:
* `/Action:Export`: Especifica la operación de extracción de esquema y datos tabulares completos.
* `/SourceServerName:"161.132.54.162"`: Dirección IP de la instancia remota de SQL Server.
* `/SourceDatabaseName:"TURISMOPERU_CPAM"`: Base de datos autorizada de trabajo.
* `/SourceUser:"estudiante"`: Credencial de usuario con privilegios de lectura y esquema.
* `/SourcePassword:"Unc.2026"`: Clave de autenticación SQL.
* `/TargetFile:"...TurismoPeru_CPAM_Fullbacpac.bacpac"`: Ruta local donde se genera el paquete exportado.
* `/p:TrustServerCertificate=True`: Parámetro crítico para validar conexiones cifradas con certificados autofirmados.
* `/p:CommandTimeout=120`: Tiempo límite de espera para garantizar la extracción completa de tablas grandes.

---

## 3. Método 2: Exportación Asistida mediante SQL Server Management Studio (SSMS)

Para administradores que utilicen interfaz gráfica, el procedimiento oficial es el siguiente:

1. **Conexión a la Instancia:**
   - Iniciar SSMS y conectarse al servidor `161.132.54.162`.
   - Autenticación: `SQL Server Authentication`, Usuario: `estudiante`, Contraseña: `Unc.2026`.
   - En *Options* -> Marcar *Encrypt connection* y *Trust server certificate*.
2. **Ubicación de la Base de Datos:**
   - En el panel *Object Explorer*, expandir el nodo **Databases**.
   - Localizar y hacer clic derecho sobre **`TURISMOPERU_CPAM`**.
3. **Inicio del Asistente:**
   - Seleccionar **Tasks** (Tareas) -> **Export Data-tier Application...** (Exportar aplicación de capa de datos...).
4. **Configuración de Ajustes de Exportación:**
   - En la pestaña *Introduction*, pulsar **Next**.
   - En la pestaña *Export Settings*:
     - Seleccionar la opción **Save to local disk** (Guardar en disco local).
     - Hacer clic en **Browse...** y seleccionar la carpeta del proyecto:
       `C:\Users\vonra\Documents\BD_Exam_3\TurismoPeru_Seguridad_AlvaradoMinchan\03_backups\`
     - Asignar como nombre de archivo: `TurismoPeru_CPAM_Fullbacpac.bacpac`.
5. **Revisión y Ejecución:**
   - En la pestaña *Summary*, revisar que el origen sea `TURISMOPERU_CPAM` y el destino el archivo `.bacpac`.
   - Pulsar el botón **Finish**.
   - Esperar a que los pasos (*Extracting schema*, *Extracting data*, *Packaging*) muestren el estado **Success**.

---

## 4. Importación del Archivo `.bacpac` en un Nuevo Servidor o Entorno Local

Para restaurar o desplegar el paquete generado en cualquier motor SQL Server o Azure SQL:

```powershell
SqlPackage.exe /Action:Import `
  /TargetServerName:"localhost" `
  /TargetDatabaseName:"TURISMOPERU_CPAM_Restored" `
  /SourceFile:"C:\Users\vonra\Documents\BD_Exam_3\TurismoPeru_Seguridad_AlvaradoMinchan\03_backups\TurismoPeru_CPAM_Fullbacpac.bacpac" `
  /p:TrustServerCertificate=True
```
