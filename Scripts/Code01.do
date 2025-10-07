/****************************************************************************************
* TALLER 5 – HACIENDO ECONOMÍA
* Autor: Samuel Blanco Castellanos
* Fecha: 7 de octubre de 2025
* Descripción:
*   (1) Importación de datos Bloomberg (Excel → Stata)
*   (2) Generación de variables
*   (3) Gráficos comparativos de precios y volúmenes (con nombres visibles)
*   (4) Exportación de figuras
****************************************************************************************/


* --------------------------------------------------------------------
* 1. Definir rutas principales
* --------------------------------------------------------------------
global path "C:\Users\Lenovo\Documents\Universidad\Material Clases\Haciendo Economía\Taller_5"

global rawdata "$path\RawData"
global created "$path\CreatedData"
global outputs "$path\Outputs"


* --------------------------------------------------------------------
* 2. Importar datos desde Excel
* --------------------------------------------------------------------
import excel using "$rawdata\datos_bloomberg_Prices_Volume.xlsx", ///
    sheet("Hoja3") firstrow clear

save "$created\datos_bloomberg.dta", replace


* --------------------------------------------------------------------
* 3. Preparación: renombrar variables
* --------------------------------------------------------------------
use "$created\datos_bloomberg.dta", clear

rename APPL_PRICE  Apple
rename MSFT_PRICE  Microsoft
rename AMZN_PRICE  Amazon
rename NVDA_PRICE  Nvidia
rename META_PRICE  Meta
rename GOOGL_PRICE Alphabet
rename TSM_PRICE   TSMC
rename SONY_PRICE  Sony
rename ASML_PRICE  ASML
rename NOK_PRICE   Nokia

rename APPL_VOLUME  Apple_vol
rename MSFT_VOLUME  Microsoft_vol
rename AMZN_VOLUME  Amazon_vol
rename NVDA_VOLUME  Nvidia_vol
rename META_VOLUME  Meta_vol
rename GOOGL_VOLUME Alphabet_vol
rename TSM_VOLUME   TSMC_vol
rename SONY_VOLUME  Sony_vol
rename ASML_VOLUME  ASML_vol
rename NOK_VOLUME   Nokia_vol


* --------------------------------------------------------------------
* 4. Crear variables de volumen en millones
* --------------------------------------------------------------------
foreach v in Apple_vol Microsoft_vol Amazon_vol Nvidia_vol Meta_vol Alphabet_vol ///
             TSMC_vol Sony_vol ASML_vol Nokia_vol {
    gen `v'_M = `v'/1000000
}

* Guardar versión con todo limpio
save "$created\datos_bloomberg_limpio.dta", replace


* --------------------------------------------------------------------
* 5. Crear base larga para precios
* --------------------------------------------------------------------
use "$created\datos_bloomberg_limpio.dta", clear
keep FECHAS Apple Microsoft Amazon Nvidia Meta Alphabet TSMC Sony ASML Nokia

tempfile precios_long
save `precios_long', emptyok replace

foreach var in Apple Microsoft Amazon Nvidia Meta Alphabet TSMC Sony ASML Nokia {
    use "$created\datos_bloomberg_limpio.dta", clear
    keep FECHAS `var'
    rename FECHAS fecha
    rename `var' precio
    gen empresa = "`var'"
    append using `precios_long'
    save `precios_long', replace
}

use `precios_long', clear

graph box precio, over(empresa, label(angle(45) labsize(small))) ///
    title("Distribución de precios por acción (2014–2024)", size(medsmall)) ///
    ytitle("Precio (USD)", size(small)) ///
    legend(off) ///
    scheme(s1color) ///
    graphregion(color(white)) ///
    box(1, fcolor(gs14))

graph export "$outputs\Figures\\box_all_prices_labels.png", replace


* --------------------------------------------------------------------
* 6. Crear base larga para volúmenes (en millones)
* --------------------------------------------------------------------
use "$created\datos_bloomberg_limpio.dta", clear
keep FECHAS Apple_vol_M Microsoft_vol_M Amazon_vol_M Nvidia_vol_M Meta_vol_M Alphabet_vol_M ///
     TSMC_vol_M Sony_vol_M ASML_vol_M Nokia_vol_M

tempfile vol_long
save `vol_long', emptyok replace

foreach var in Apple_vol_M Microsoft_vol_M Amazon_vol_M Nvidia_vol_M Meta_vol_M Alphabet_vol_M ///
               TSMC_vol_M Sony_vol_M ASML_vol_M Nokia_vol_M {
    use "$created\datos_bloomberg_limpio.dta", clear
    keep FECHAS `var'
    rename FECHAS fecha
    rename `var' volumenM
    local cleanname : subinstr local var "_vol_M" "", all
    gen empresa = "`cleanname'"
    append using `vol_long'
    save `vol_long', replace
}

use `vol_long', clear

graph box volumenM, over(empresa, label(angle(45) labsize(small))) ///
    title("Distribución de volúmenes por acción (millones, 2014–2024)", size(medsmall)) ///
    ytitle("Volumen negociado (millones de acciones)", size(small)) ///
    legend(off) ///
    scheme(s1color) ///
    graphregion(color(white)) ///
    box(1, fcolor(gs14))

graph export "$outputs\Figures\\box_all_volumes_labels.png", replace


* --------------------------------------------------------------------
* 7. Gráficos individuales (para anexos)
* --------------------------------------------------------------------
use "$created\datos_bloomberg_limpio.dta", clear

foreach var in Apple Microsoft Amazon Nvidia Meta Alphabet TSMC Sony ASML Nokia {
    graph box `var', ///
        title("Distribución de precios - `var' (2014–2024)", size(medsmall)) ///
        ytitle("Precio (USD)", size(small)) ///
        legend(off) ///
        scheme(s1color) ///
        graphregion(color(white))
    graph export "$outputs\Figures\\box_`var'.png", replace
}

foreach var in Apple_vol_M Microsoft_vol_M Amazon_vol_M Nvidia_vol_M Meta_vol_M Alphabet_vol_M ///
               TSMC_vol_M Sony_vol_M ASML_vol_M Nokia_vol_M {
    graph box `var', ///
        title("Distribución de volúmenes - `var' (2014–2024)", size(medsmall)) ///
        ytitle("Volumen negociado (millones de acciones)", size(small)) ///
        legend(off) ///
        scheme(s1color) ///
        graphregion(color(white))
    graph export "$outputs\Figures\\box_`var'.png", replace
}

display "✅ TODOS LOS GRÁFICOS GENERADOS EXITOSAMENTE en Outputs/Figures."

///GRAFICAS PROMEDIO POR REGION

use "$created\datos_bloomberg_limpio.dta", clear

* --------------------------------------------------------------
* 1. Crear variable de año
* --------------------------------------------------------------
gen year = year(FECHAS)

* --------------------------------------------------------------
* 2. Calcular promedios anuales de precios por región
* --------------------------------------------------------------
collapse (mean) Apple Microsoft Amazon Nvidia Meta Alphabet ///
                 ASML Nokia TSMC Sony, by(year)

* Promedios por región
egen America = rowmean(Apple Microsoft Amazon Nvidia Meta Alphabet)
egen Europa  = rowmean(ASML Nokia)
egen Asia    = rowmean(TSMC Sony)

* Guardar base resumen
save "$created\promedios_regionales.dta", replace


* --------------------------------------------------------------
* 3. Gráfico de líneas: precios promedio por región
* --------------------------------------------------------------
twoway ///
(line America year, lcolor(blue) lwidth(thick)) ///
(line Europa year, lcolor(red) lwidth(thick) lpattern(dash)) ///
(line Asia year, lcolor(green) lwidth(thick) lpattern(shortdash)) ///
, ///
title("Precios promedio por región (2014–2024)", size(medsmall)) ///
ytitle("Precio promedio (USD)", size(small)) ///
xtitle("Año", size(small)) ///
legend(order(1 "América" 2 "Europa" 3 "Asia") region(lcolor(white)) size(small)) ///
graphregion(color(white)) ///
scheme(s1color)

graph export "$outputs\Figures\\line_precios_regiones.png", replace

display "✅ Gráfico de líneas generado y exportado en Outputs/Figures."


///SECCIÓN 3

* --------------------------------------------------------------------
* 1. Cargar base limpia y generar variable de año
* --------------------------------------------------------------------
use "$created\datos_bloomberg_limpio.dta", clear
gen year = year(FECHAS)


* --------------------------------------------------------------------
* 2. Crear variables de volumen en millones si no existen
* --------------------------------------------------------------------
foreach v in Apple_vol Microsoft_vol Amazon_vol Nvidia_vol Meta_vol Alphabet_vol ///
             ASML_vol Nokia_vol TSMC_vol Sony_vol {
    capture confirm variable `v'_M
    if _rc gen `v'_M = `v' / 1000000
}


* --------------------------------------------------------------------
* 3. Calcular promedios anuales por acción
* --------------------------------------------------------------------
collapse (mean) Apple Microsoft Amazon Nvidia Meta Alphabet ///
                 ASML Nokia TSMC Sony ///
         (mean) Apple_vol_M Microsoft_vol_M Amazon_vol_M Nvidia_vol_M Meta_vol_M Alphabet_vol_M ///
                 ASML_vol_M Nokia_vol_M TSMC_vol_M Sony_vol_M, by(year)


* --------------------------------------------------------------------
* 4. Calcular los pesos con base en volúmenes de 2015
* --------------------------------------------------------------------
preserve
keep if year == 2015

* ---- América ----
egen totalA = rowtotal(Apple_vol_M Microsoft_vol_M Amazon_vol_M Nvidia_vol_M Meta_vol_M Alphabet_vol_M)
foreach x in Apple Microsoft Amazon Nvidia Meta Alphabet {
    gen w_`x' = `x'_vol_M / totalA
}

* ---- Europa ----
egen totalE = rowtotal(ASML_vol_M Nokia_vol_M)
foreach x in ASML Nokia {
    gen w_`x' = `x'_vol_M / totalE
}

* ---- Asia ----
egen totalAS = rowtotal(TSMC_vol_M Sony_vol_M)
foreach x in TSMC Sony {
    gen w_`x' = `x'_vol_M / totalAS
}

keep w_* 
save "$created\pesos_2015.dta", replace
restore


* --------------------------------------------------------------------
* 5. Aplicar los pesos de 2015 a todos los años (joinby)
* --------------------------------------------------------------------
tempfile pesos
use "$created\pesos_2015.dta", clear
gen key = 1
save `pesos', replace

use "$created\datos_bloomberg_limpio.dta", clear
gen year = year(FECHAS)
collapse (mean) Apple Microsoft Amazon Nvidia Meta Alphabet ///
                 ASML Nokia TSMC Sony ///
         (mean) Apple_vol_M Microsoft_vol_M Amazon_vol_M Nvidia_vol_M Meta_vol_M Alphabet_vol_M ///
                 ASML_vol_M Nokia_vol_M TSMC_vol_M Sony_vol_M, by(year)

gen key = 1
joinby key using `pesos'
drop key


* --------------------------------------------------------------------
* 6. Calcular índices ponderados y simples
* --------------------------------------------------------------------
* ---- América ----
gen America_pond = (Apple * w_Apple + Microsoft * w_Microsoft + Amazon * w_Amazon + ///
                    Nvidia * w_Nvidia + Meta * w_Meta + Alphabet * w_Alphabet)
egen America_simple = rowmean(Apple Microsoft Amazon Nvidia Meta Alphabet)

* ---- Europa ----
gen Europa_pond = (ASML * w_ASML + Nokia * w_Nokia)
egen Europa_simple = rowmean(ASML Nokia)

* ---- Asia ----
gen Asia_pond = (TSMC * w_TSMC + Sony * w_Sony)
egen Asia_simple = rowmean(TSMC Sony)


* --------------------------------------------------------------------
* 7. Estandarizar índices (base 2015 = 100)
* --------------------------------------------------------------------
foreach var in America_pond America_simple Europa_pond Europa_simple Asia_pond Asia_simple {
    quietly summarize `var' if year == 2015
    scalar base_`var' = r(mean)
    gen `var'_index = (`var' / base_`var') * 100
}


* --------------------------------------------------------------------
* 8. Graficar índice simple vs ponderado por región
* --------------------------------------------------------------------

* ---- América ----
twoway (line America_simple_index year, lcolor(blue) lpattern(dash)) ///
       (line America_pond_index year, lcolor(blue) lwidth(thick)) ///
, title("América: Índice simple vs ponderado (2015–2024)") ///
  ytitle("Índice (Precio promedio, base 2015 = 100)") ///
  xtitle("Año") ///
  legend(order(1 "Simple" 2 "Ponderado") region(lcolor(white))) ///
  scheme(s1color)
graph export "$outputs\Figures\\line_indice_america.png", replace


* ---- Europa ----
twoway (line Europa_simple_index year, lcolor(red) lpattern(dash)) ///
       (line Europa_pond_index year, lcolor(red) lwidth(thick)) ///
, title("Europa: Índice simple vs ponderado (2015–2024)") ///
  ytitle("Índice (Precio promedio, base 2015 = 100)") ///
  xtitle("Año") ///
  legend(order(1 "Simple" 2 "Ponderado") region(lcolor(white))) ///
  scheme(s1color)
graph export "$outputs\Figures\\line_indice_europa.png", replace


* ---- Asia ----
twoway (line Asia_simple_index year, lcolor(green) lpattern(dash)) ///
       (line Asia_pond_index year, lcolor(green) lwidth(thick)) ///
, title("Asia: Índice simple vs ponderado (2015–2024)") ///
  ytitle("Índice (Precio promedio, base 2015 = 100)") ///
  xtitle("Año") ///
  legend(order(1 "Simple" 2 "Ponderado") region(lcolor(white))) ///
  scheme(s1color)
graph export "$outputs\Figures\\line_indice_asia.png", replace


display "✅ Índices ponderados y simples generados correctamente. Gráficos exportados a Outputs/Figures."