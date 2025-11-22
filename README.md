# Proyecto Vulnerabilidad Económica RD
Este repositorio contiene un análisis aplicado sobre la **vulnerabilidad económica a nivel municipal en la República Dominicana**, combinando datos oficiales (ONE, BCRD, MEPyD, entre otros) con técnicas de limpieza de datos, construcción de indicadores y visualización.

El objetivo es construir un **índice sintético de vulnerabilidad económica municipal** y explorar sus determinantes principales, con énfasis en variables de pobreza, mercado laboral, educación, acceso a servicios y finanzas públicas locales.

---

## Objetivos del proyecto

- Integrar en una sola base de datos información socioeconómica relevante a nivel municipal.
- Construir un **indicador de vulnerabilidad económica** a partir de variables seleccionadas.
- Analizar patrones territoriales de vulnerabilidad (mapas, rankings y clusters).
- Producir visualizaciones y un reporte técnico que pueda servir como insumo para **diseño o evaluación de políticas públicas**.

---

## Estructura del repositorio

La estructura general del proyecto es la siguiente:

```text
vulnerabilidad-economica-rd/
│
├── data/
│   ├── raw/         # Datos originales descargados de las fuentes oficiales
│   └── processed/   # Datos limpios y listos para análisis
│
├── src/
│   ├── 01_download.R   # (Opcional) Descarga o importación de datos
│   ├── 02_etl.R        # Limpieza, transformación y unificación de bases
│   ├── 03_analysis.R   # Análisis descriptivo, índices y modelos
│   └── 04_report.R     # Generación de tablas/figuras usadas en el reporte
│
├── output/
│   ├── figuras/     # Gráficos finales (PNG, JPG) para el reporte y README
│   └── tablas/      # Tablas exportadas en CSV/XLSX
│
└── docs/
    ├── reporte.qmd  # Reporte técnico en Quarto
    └── reporte.html # Versión renderizada del reporte (HTML/PDF)
    
```
## Metodologia

De forma general, la metodología del proyecto contempla:

1. Recolección y unificación de datos

- Importación de bases de datos desde distintas instituciones.

- Homologación de códigos y nombres de municipios.

- Construcción de variables per cápita y tasas.

2. Limpieza y transformación

- Tratamiento de valores faltantes.

- Normalización/estandarización de variables (por ejemplo, z-score).

- Construcción de indicadores intermedios (pobreza, mercado laboral, servicios, etc.).

3. Construcción del índice de vulnerabilidad

- Definición de las dimensiones (ej.: ingreso, empleo, educación, servicios).

- Agregación mediante técnicas como:

- Promedios ponderados, y/o

- Análisis de Componentes Principales (PCA), y/o

- Clustering (k-means) para agrupar municipios por nivel de vulnerabilidad.

4. Análisis y visualización

- Análisis descriptivo por municipio/provincia/región.

- Mapas coropléticos de vulnerabilidad.

- Rankings de municipios más y menos vulnerables.

- Gráficos de relación entre vulnerabilidad y variables clave (ej. gasto público local, escolaridad, etc.).

5. Reporte final

- Elaboración de un reporte técnico en Quarto (docs/reporte.qmd).

- Presentación de la metodología, resultados y posibles aplicaciones en política pública.

## Fuente de datos
