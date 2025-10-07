# Taller 5 – Haciendo Economía  
**Análisis de precios y volúmenes de acciones tecnológicas globales (2014–2024)**  
Autor: *Samuel Blanco Castellanos*  
Fecha: Octubre de 2025  

---

## 📘 Descripción general  

Este proyecto corresponde al **Taller 5 del curso Haciendo Economía**, cuyo objetivo es **analizar la evolución de precios y volúmenes de acciones tecnológicas en tres regiones del mundo (América, Europa y Asia)** durante el periodo 2014–2024, a partir de datos descargados desde Bloomberg y procesados mediante **Excel, Power Query y Stata**.  

El taller desarrolla una secuencia completa de tratamiento, análisis y visualización de datos financieros, culminando en la **construcción de un índice regional ponderado por volumen de transacciones**, con año base 2015.  

---

## 🧩 Estructura del proyecto  


---

## ⚙️ Flujo metodológico  

### 1. Preparación y limpieza de datos  
- Importación desde **Excel** de los precios y volúmenes diarios de 10 acciones tecnológicas.  
- Conversión de la base desde formato ancho a largo con **Power Query**, facilitando el análisis temporal.  
- Creación de variables de volumen en millones de acciones y renombrado de variables para estandarizar nombres.  

### 2. Análisis descriptivo  
- Cálculo de precios y volúmenes promedio anuales (2014–2024).  
- Generación de gráficos de **cajas y bigotes** para comparar distribuciones y detectar valores atípicos.  
- Cálculo de promedios por región (América, Europa, Asia) y análisis de variaciones pre y pospandemia.  

### 3. Construcción del índice regional  
- Cálculo de **pesos según volúmenes de 2015**, representando la importancia relativa de cada acción.  
- Creación de índices **simples y ponderados** por región, estandarizados con base 2015 = 100.  
- Visualización de la evolución de cada índice mediante **gráficos de líneas comparativos**.  

### 4. Análisis inferencial y visualización  
- Estimación de diferencias de precios promedio entre 2014 y 2024.  
- Cálculo de desviaciones estándar, número de observaciones e intervalos de confianza al 95%.  
- Representación gráfica de las diferencias con barras e intervalos de confianza para evaluar cambios significativos post-COVID.  

---

## 📈 Principales resultados  

- Los **precios promedio** presentan una tendencia ascendente en todas las regiones, con mayor dinamismo en **América**, impulsada por las grandes tecnológicas (*Apple, Microsoft, Amazon, Meta, Alphabet*).  
- En **Europa**, el crecimiento se concentra en *ASML Holding*, mientras que *Nokia* mantiene un desempeño más estable.  
- **Asia** muestra un aumento constante, con un comportamiento más homogéneo entre *TSMC* y *Sony*.  
- La comparación entre índices **simples y ponderados** evidencia que la ponderación por volumen suaviza las fluctuaciones y refleja mejor la estructura real del mercado.  
- Tras la pandemia, los precios muestran un crecimiento estructural asociado a la digitalización global y la expansión del sector tecnológico.  

---

## 🧮 Requisitos  

- **Stata 17 o superior**  
- **Microsoft Excel (con Power Query habilitado)**  
- **Overleaf o TeX Live** para la edición del documento final  

---

## 🚀 Ejecución  

1. Clonar el repositorio:  
   ```bash
   git clone https://github.com/<usuario>/Taller_5_HaciendoEconomia.git


