# Módulo de Reportes Analíticos e Inteligencia de Negocios (Parte 5)

**Asignatura:** Base de Datos II (Grupo B) — Evaluación 3  
**Institución:** Universidad Nacional de Cajamarca  
**Autor:** Cristian Paul Alvarado Minchan / VonRabbid  
**Base de Datos:** `TURISMOPERU_CPAM`  
**Servidor:** `161.132.54.162` (Microsoft SQL Server 2022)  
**Alternativa Seleccionada:** Alternativa B (Desarrollo Analítico con Python)

---

## 1. Descripción de Entregables Generados

El módulo analítico implementado en `06_python/app.py` extrae en tiempo real los registros transaccionales de `TURISMOPERU_CPAM` mediante SQLAlchemy y PyODBC, procesa las métricas financieras con Pandas y genera de forma completamente automatizada los siguientes documentos ejecutivos:

- **`05_reportes/reportes.pdf`**: Documento ejecutivo de alta fidelidad generado mediante la librería ReportLab. Incluye portada institucional formal, tabla resumen de KPIs con paleta corporativa, desglose financiero por método de pago, visualizaciones gráficas integradas en alta resolución (300 DPI) y las 5 conclusiones analíticas institucionales.
- **`05_reportes/reportes.docx`**: Reporte técnico-ejecutivo en formato editable Microsoft Word generado mediante `python-docx`. Presenta formato tipográfico formal (Aptos / Calibri, 11pt, interlineado 1.15), portada ejecutiva, tablas con cabeceras estilizadas (`#1B365D`) y alineación numérica a la derecha, gráficos incrustados y conclusiones numeradas.

Ambos documentos son autogenerados de forma síncrona al ejecutar el script principal de análisis.

---

## 2. Resumen Ejecutivo: 4 KPIs Clave del Negocio

Las métricas clave de desempeño (KPIs) calculadas sobre la base de datos `TURISMOPERU_CPAM` reflejan el estado comercial y operativo de la empresa de turismo:

| Indicador Clave (KPI) | Valor Registrado | Unidad de Medida | Interpretación de Gestión |
| :--- | :---: | :---: | :--- |
| **Total de Clientes** | **57** | Clientes únicos | Cartera activa consolidada en la plataforma relacional. |
| **Total de Reservas** | **100** | Transacciones | Contratos turísticos formalizados durante el período evaluado. |
| **Total de Ingresos Cobrados** | **S/. 351,975.00** | Soles (PEN) | Recaudación total efectiva acumulada en la tabla `CPAM.pago`. |
| **Ticket Promedio por Reserva** | **S/. 3,519.75** | Soles (PEN) / Reserva | Monto promedio efectivamente cobrado por cada reserva generada. |

> **Nota Financiera Adicional:** La facturación bruta contratada (suma del campo `precio_total` en la tabla `CPAM.reserva`) asciende a **S/. 407,100.00**, lo que representa una tasa de recaudación y cobranza efectiva del **86.46%** sobre el total contratado.

---

## 3. Desglose Financiero por Medio de Pago

Auditoría detallada del flujo monetario según el canal de liquidación utilizado por los clientes en `CPAM.pago` y `CPAM.medio_pago`:

| Medio de Pago | Monto Recaudado (S/.) | Porcentaje (%) | N° Transacciones | Participación de Mercado |
| :--- | :---: | :---: | :---: | :--- |
| **Visa** | S/. 148,500.00 | 42.19% | 46 | Líder absoluto en cobros y reservas corporativas |
| **Mastercard** | S/. 84,025.00 | 23.87% | 29 | Segunda fuerza en transacciones con tarjeta |
| **Transferencia Bancaria** | S/. 51,725.00 | 14.70% | 17 | Canal preferido para paquetes turísticos de alto valor |
| **Yape** | S/. 46,575.00 | 13.23% | 15 | Billetera digital predominante en microtransacciones |
| **Efectivo Soles** | S/. 18,450.00 | 5.24% | 5 | Pagos presenciales directos en ventanilla |
| **Plin** | S/. 2,700.00 | 0.77% | 2 | Canal secundario de billeteras interbancarias |
| **TOTAL GENERAL** | **S/. 351,975.00** | **100.00%** | **114** | **100% de operaciones conciliadas** |

---

## 4. Conclusiones Analíticas Obligatorias

A partir de la minería de datos relacional y el análisis estadístico descriptivo ejecutado sobre las tablas `CPAM.reserva`, `CPAM.pago`, `CPAM.cliente` y `CPAM.persona`, se formulan formalmente las 5 conclusiones requeridas:

1. **1. Se observa que** la distribución operativa de las reservas refleja un alto nivel de cumplimiento comercial y madurez transaccional: un **36%** de los contratos se encuentra en estado **Completada** con liquidación total, mientras que un **20%** se ubica en estado **En proceso** o parcialmente pagada bajo esquema de anticipos, y únicamente un **6%** registra estado **Cancelada**. Esta tasa mínima de deserción evidencia la efectividad de las políticas de fidelización y confirmación oportuna de los itinerarios.

2. **2. El medio de pago con mayor** preferencia y volumen captado es **Visa**, concentrando **S/. 148,500.00** correspondientes al **42.19%** de la recaudación total. Al integrar Mastercard (23.87%), Transferencia Bancaria (14.70%) y Yape (13.23%), se constata que los canales digitales y bancarizados representan más del **94%** del volumen financiero del negocio, reduciendo sustancialmente el riesgo de manejo de efectivo físico (5.24%) y optimizando la conciliación contable.

3. **3. El periodo con mayor** dinamismo transaccional del semestre se concentra en el bimestre de media temporada: **Mayo** con 25 reservas formalizadas y **Junio** con 26 reservas formalizadas. En conjunto, estos dos meses agrupan el **51.0%** del total de contratos del período evaluado, coincidiendo con la preparación de temporadas festivas, feriados nacionales y turismo receptivo hacia destinos andinos y amazónicos.

4. **4. Los clientes que concentran** la mayor aportación al flujo de caja de la organización destacan por tickets individuales superiores: **Luisa María Herrera** lidera la facturación acumulada con **S/. 19,200.00**, seguida de **Yolanda Marín** con **S/. 18,800.00**. Asimismo, en frecuencia de compra destaca el cliente **Raúl Figueroa** con 4 reservas contratadas, constituyendo el segmento VIP prioritario para programas de retención y fidelización comercial.

5. **5. El comportamiento de** la recaudación evidencia una sólida rentabilidad operativa con un **Ticket Promedio de S/. 3,519.75** efectivamente cobrado por reserva. Frente a un valor medio contratado de S/. 4,071.00 por contrato, la relación entre ingresos proyectados (S/. 407,100.00) y cobrados (S/. 351,975.00) refleja una eficiencia de cobranza del **86.46%**, lo cual garantiza una posición de liquidez favorable para afrontar obligaciones con operadores hoteleros y de transporte.

---

## 5. Instrucciones de Regeneración y Ejecución

Para replicar el análisis y regenerar de manera autónoma los archivos `reportes.pdf` y `reportes.docx`:

### 5.1 Requisitos Previos
- Python 3.10 o superior instalado.
- Controlador oficial **ODBC Driver 18 for SQL Server** o **ODBC Driver 17 for SQL Server** instalado en el sistema operativo.

### 5.2 Instalación de Dependencias
Ejecutar desde el directorio raíz del proyecto:

```powershell
pip install -r 06_python/requirements.txt
```

### 5.3 Configuración de Variables de Entorno
Asegurarse de contar con el archivo `06_python/.env` configurado con las credenciales autorizadas (utilizar `06_python/.env.example` como plantilla):

```env
DB_SERVER=161.132.54.162
DB_PORT=1433
DB_NAME=TURISMOPERU_CPAM
DB_USER=estudiante
DB_PASSWORD=Unc.2026
DB_ENCRYPT=yes
DB_TRUST_CERT=yes
```

### 5.4 Ejecución del Módulo Analítico
Ejecutar el script principal:

```powershell
python 06_python/app.py
```

El script ejecutará las consultas SQL, generará las gráficas temporales y de distribución, compilará el reporte en PDF (`05_reportes/reportes.pdf`), creará el documento en Word (`05_reportes/reportes.docx`) y actualizará la captura de evidencia (`evidencias/reporte.png`).
