[![](https://img.shields.io/badge/Shiny-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://dar-337152118-appshiny-r.shinyapps.io/NBA_app/)

# **NBA App** :basketball:

Una aplicación interactiva de Shiny para analizar datos históricos de la NBA (1975 - actualidad). Explora estadísticas de equipos, jugadores y combinaciones legendarias con una interfaz moderna y visual.

**👇[Ver App en Vivo](https://dar-337152118-appshiny-r.shinyapps.io/NBA_app/)👇**

<a href="https://dar-337152118-appshiny-r.shinyapps.io/NBA_app/"><img src="https://github.com/dalerodr/NBA_app/blob/main/image/Basketball_app - franchise history.JPG" alt="screenshot_franchise_history"></a>

---

## 🌟 Características Clave

### 🏛️ Franchise History
Analiza la trayectoria de cualquier franquicia de la NBA.
- **Top Leaders**: Consulta los líderes históricos en puntos, asistencias, rebotes, tapones y robos.
- **Gráficos Interactivos**: Visualiza estadísticas personalizadas por temporada y oponente usando Plotly.

### 👥 Big 3 Analysis
Explora el rendimiento de jugadores individuales o combinaciones de 2 y 3 jugadores.
- **Sinergia en Pista**: Analiza cómo cambian las estadísticas y el porcentaje de victorias cuando los "Big 3" juegan juntos.
- **Tablas Detalladas**: Comparativas de rendimiento por equipo.

<a href="https://dar-337152118-appshiny-r.shinyapps.io/NBA_app/"><img src="https://github.com/dalerodr/NBA_app/blob/main/image/Basketball_app - big3.JPG" alt="screenshot_big3" style="width: 35%; height: auto;"></a>

### 🏅 Records & Advanced Search
Motor de búsqueda avanzado para encontrar actuaciones históricas.
- **Filtros Dinámicos**: Filtra por puntos, asistencias, rebotes, minutos y resultado del partido.
- **Hitos**: Encuentra rápidamente dobles-figuras (triple-dobles) y récords personales.

<a href="https://dar-337152118-appshiny-r.shinyapps.io/NBA_app/"><img src="https://github.com/dalerodr/NBA_app/blob/main/image/Basketball_app - records.JPG" alt="screenshot_records" style="width: 35%; height: auto;"></a>

---

## ⚡ Optimización de Datos (High Performance)

Dado el volumen masivo de datos históricos de la NBA, la aplicación ha sido diseñada específicamente para ofrecer respuestas inmediatas mediante el uso de tecnologías punteras:

- **[DuckDB](https://duckdb.org/)**: Motor de base de datos analítica incorporado (in-process). Permite realizar consultas SQL complejas directamente sobre archivos, priorizando el rendimiento OLAP (Online Analytical Processing).
- **[Apache Parquet](https://parquet.apache.org/)**: Formato de almacenamiento columnar que reduce drásticamente el uso de memoria y la latencia de lectura. Al leer solo las columnas necesarias, las consultas de la app son extremadamente veloces.
- **Escanéo de Archivos**: La aplicación aprovecha la capacidad de DuckDB para escanear directamente archivos Parquet (`parquet_scan`), eliminando la necesidad de cargar toda la base de datos en memoria y garantizando escalabilidad.

---

## 🛠️ Tecnologías

Este proyecto utiliza el ecosistema de **R** y **Shiny**:
- **Motor de Datos**: `duckdb`, `parquet`, `feather`.
- **UI/UX**: `bslib` (Bootstrap 5), `shinyWidgets`, `fontawesome`.
- **Visualización**: `plotly`, `reactable`.
- **Análisis**: `tidyverse` (`dplyr`, `tidyr`).

---

## 📁 Estructura del Proyecto

- `app.R`: Lógica principal de la aplicación Shiny.
- `data.R`: Gestión de datos optimizada con DuckDB y funciones auxiliares.

---

## 🔗 Contacto

[![](https://img.shields.io/badge/LinkedIn-Daniel_Alejo-blue?logo=linkedin)](https://es.linkedin.com/in/daniel-alejo-rodriguez-2601ba161)
[![](https://img.shields.io/badge/GitHub-dalerodr-black?logo=github)](https://github.com/dalerodr)
