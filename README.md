# Proyecto: Vulnerabilidad Económica Territorial en la República Dominicana (2016–2024)
![renv reproducible](https://img.shields.io/badge/reproducible-renv-blue)
![R](https://img.shields.io/badge/Made%20with-R-276DC3?logo=r)
![Índice de Vulnerabilidad](output/figuras/indice_vulnerabilidad_por_region.png)

## Principales hallazgos

-   persistencia de brechas territoriales: En promedio 2016–2024, las mayores tasas de pobreza se observan en la Región Enriquillo (\~34.5%) y la Región Ozama o Metropolitana (\~34.3%), mientras que la menor se registra en la Región Cibao Nordeste (\~19.3%). La vulnerabilidad no se distribuye de forma homogénea en el territorio.

-   Reducción significativa de la pobreza monetaria: Entre 2016 y 2024, todas las regiones de desarrollo presentan caídas en la tasa de pobreza. Las reducciones más fuertes se dan en la Región Cibao Noroeste (−23.2 p.p.), Región Higuamo (−19.7 p.p.), Región Valdesia (−19.6 p.p.) y Región Ozama o Metropolitana (−18.5 p.p.).

-   Disminución del número de personas en pobreza: En términos absolutos, la población en situación de pobreza se reduce con fuerza en varias regiones. Destacan la Región Cibao Norte (≈−209 mil personas) y Región Valdesia (≈−206 mil personas) entre 2016 y 2024, lo que sugiere un avance cuantitativo importante, aunque con niveles todavía elevados.

-   Alta concentración de vulnerabilidad: A pesar de la mejora general, regiones como Enriquillo, Ozama o Metropolitana y Higuamo combinan históricamente tasas altas de pobreza con poblaciones numerosas, lo que las ubica sistemáticamente entre las más vulnerables del país según el índice construido. Este repositorio contiene un análisis aplicado sobre la vulnerabilidad económica a nivel de regiones de desarrollo en la República Dominicana. El proyecto integra información oficial proveniente del MEPyD, ONE y otras fuentes públicas, con técnicas de limpieza, transformación y análisis de datos en R.

## Proposito del proyecto

El objetivo central es construir un índice territorial de vulnerabilidad económica, utilizando variables robustas y comparables en el tiempo (principalmente pobreza monetaria y población), y acompañarlo de un análisis descriptivo del contexto económico y laboral del país.

------------------------------------------------------------------------

## Objetivos del proyecto

-   Integrar en un solo panel datos oficiales de pobreza y población para el período 2016–2024.

-   Construir la primera versión de un índice de vulnerabilidad económica por región de desarrollo.

-   Analizar y comparar la evolución de pobreza y estructura poblacional entre regiones.

-   Generar visualizaciones, tablas y un reporte técnico que sirva como insumo para el diseño de políticas públicas orientadas al territorio.

------------------------------------------------------------------------

## Cómo reproducir el proyecto

El proyecto está organizado para ejecutarse de manera secuencial y reproducible. Para correrlo localmente:

``` r
# 1. (Opcional) Restaurar el entorno reproducible con renv
renv::restore()

# 2. Procesar y limpiar los datos
source("src/01_limpieza_de_datos.R")

# 3. Construir el índice, realizar análisis y generar visualizaciones
source("src/02_analysis.R")

# 4. Renderizar el reporte técnico en Quarto
quarto::render("docs/reporte.qmd")
## Estructura del repositorio
```

El flujo generará automáticamente:

-    `data/processed/` → datos limpios listos para análisis

-    `output/tablas/` → tablas finales exportadas

-    `output/figuras/` → gráficos usados en el README y en el reporte técnico

Requisitos mínimos: R \>= 4.2, tidyverse, readxl, janitor, scales, plotly, ggplot2 y Quarto (`quarto-cli`).

La estructura general del proyecto es la siguiente:

``` text
vulnerabilidad-economica-rd/
│
├── data/
│   ├── raw/         # Datos originales descargados de las fuentes oficiales
│   └── processed/   # Datos limpios y listos para análisis
│
├── src/
│   ├── 01_limpieza_de_datos.R  # Limpieza, transformación y unificación de bases
│   └── 02_analysis.R   # Análisis descriptivo, índices y modelos
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

1.  Recolección y unificación de datos

Importación de tabulados oficiales del MEPyD (pobreza monetaria).

Importación de tabulados de población de la ONE.

Estandarización de nombres de regiones de desarrollo.

Integración en un panel unificado: región de desarrollo × año (2016–2024).

2.  Limpieza y transformación

Manejo de encabezados múltiples en Excel.

Conversión de porcentajes a proporciones.

Construcción de variables derivadas, como:

población en pobreza (tasa × población),

diferencias interanuales,

rankings regionales.

3.Índice de Vulnerabilidad Territorial – Versión 1

Variables utilizadas:

-   Tasa de pobreza monetaria.

-   Población total.

Tratamiento técnico:

Normalización mediante z-score.

Construcción de un índice aditivo simple (versión inicial).

Comparación temporal y entre regiones.

Posibles mejoras futuras:

brecha y severidad de la pobreza,

indicadores educativos,

variables laborales subnacionales,

PCA u otros métodos de agregación más robustos.

4.  Análisis y visualización

Evolución de la pobreza por región de desarrollo.

Comparación del nivel de vulnerabilidad entre regiones.

Gráficos de distribución y rankings.

Análisis contextual del mercado laboral nacional (2014–2025).

## A futuro

Próximas extensiones

Incorporar brecha y severidad de la pobreza por región de desarrollo.

Integrar indicadores educativos y de mercado laboral si se publican a nivel subnacional.

Construir una versión multidimensional del índice con PCA o ponderaciones.

Explorar tipologías territoriales (clustering) cuando existan más variables.

Autor: Leonardo Mena Rol: Analista de Datos y Economía Aplicada
