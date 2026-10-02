# Módulo Analítico de Inteligencia de Negocios en Python (Alternativa B)

**Proyecto:** TurismoPerú - Tercera Evaluación de Base de Datos II (Grupo B)  
**Autor:** Cristian Paul Alvarado Minchan  
**Institución:** Universidad Nacional de Cajamarca (UNC)  
**Base de Datos:** `TURISMOPERU_CPAM`  
**Servidor:** `161.132.54.162` (SQL Server 2022)

---

## 1. Descripción del Módulo

Este módulo en Python implementa la **Alternativa B (Módulo Analítico en Python)** solicitada en la evaluación. Realiza de forma automatizada:
1. Conexión segura a la base de datos `TURISMOPERU_CPAM` en SQL Server mediante SQLAlchemy y PyODBC.
2. Extracción transaccional de datos de clientes, reservas, pagos y catálogos vinculados.
3. Procesamiento y cálculo de los **4 Indicadores Clave de Rendimiento (KPIs)** con Pandas:
   - **Total Clientes**
   - **Total Reservas**
   - **Total Ingresos Cobrados**
   - **Ticket Promedio**
4. Generación de los **5 Gráficos Estadísticos Obligatorios** con Matplotlib y Seaborn:
   - Gráfico 1: Reservas por estado operativo
   - Gráfico 2: Ingresos por medio de pago
   - Gráfico 3: Reservas por período/fecha (tendencia temporal mensual)
   - Gráfico 4: Top 10 clientes con mayor cantidad de reservas (frecuencia)
   - Gráfico 5: Ingresos totales generados por cliente (facturación acumulada)
5. Exportación del panel visual consolidado en `evidencias/reporte.png`.
6. Compilación de informes ejecutivos formales:
   - **PDF (`05_reportes/reportes.pdf`)**: Compilado con ReportLab.
   - **Word (`05_reportes/reportes.docx`)**: Compilado con `python-docx`.
   Ambos documentos incorporan portada formal, tablas de resumen de KPIs, tablas de datos, gráficos insertados y las **5 conclusiones analíticas fundamentadas obligatorias**.

---

## 2. Requisitos Previos

- Python 3.10 o superior (compatible con Python 3.14).
- Microsoft ODBC Driver 17 o 18 for SQL Server instalado en el sistema operativo.

---

## 3. Instalación Paso a Paso

### 3.1 Crear y Activar un Entorno Virtual (Opcional pero Recomendado)

En PowerShell:
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

### 3.2 Instalar Dependencias
```powershell
pip install -r requirements.txt
```

Las dependencias clave instaladas son:
- `pyodbc`: Driver de comunicación nativo con SQL Server.
- `sqlalchemy`: ORM y motor de abstracción de conexiones SQL.
- `pandas`: Procesamiento, agrupación y análisis matricial de datos.
- `matplotlib` & `seaborn`: Generación de visualizaciones estadísticas.
- `python-dotenv`: Carga de variables de entorno seguras.
- `reportlab`: Compilador programático de documentos PDF ejecutivos.
- `Pillow`: Procesamiento de imágenes para reportes.

---

## 4. Configuración de Variables de Entorno

1. Copiar el archivo de plantilla `.env.example` como `.env`:
   ```powershell
   Copy-Item .env.example .env
   ```
2. Verificar los parámetros de conexión dentro del archivo `.env`:
   ```env
   DB_SERVER=161.132.54.162
   DB_DATABASE=TURISMOPERU_CPAM
   DB_USER=estudiante
   DB_PASSWORD=Unc.2026
   DB_DRIVER=ODBC Driver 18 for SQL Server
   DB_ENCRYPT=yes
   DB_TRUST_CERT=yes
   ```

*(Nota: El archivo `.env` se encuentra ignorado en el `.gitignore` por directivas de seguridad informática).*

---

## 5. Ejecución del Módulo Analítico

Ejecutar el script principal desde la terminal:

```powershell
python app.py
```

O desde el directorio raíz del proyecto:

```powershell
python 06_python\app.py
```

---

## 6. Salidas y Entregables Generados

Al finalizar exitosamente, el script produce automáticamente:
- **`evidencias/reporte.png`**: Dashboard consolidado en alta resolución que reúne los 5 gráficos analíticos y la tarjeta resumen de KPIs.
- **`05_reportes/reportes.pdf`**: Documento ejecutivo formal en PDF con portada institucional de la Universidad Nacional de Cajamarca, tablas estadísticas, gráficos integrados y las 5 conclusiones analíticas institucionales.
- **`05_reportes/reportes.docx`**: Reporte ejecutivo formal en formato editable Microsoft Word (.docx) con diseño corporativo, tablas formateadas y conclusiones integradas.
