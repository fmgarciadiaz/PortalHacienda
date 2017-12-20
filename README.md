
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PortalHacienda

Un paquete de interface R a la API del Portal de Datos del Ministerio de
Hacienda. - **Buscar** - **descargar** - **proyectar** rápidamente
series. Las series se cargan en formato XTS.

## Instalación

Para instalar ejecutar:

``` r
# install.packages("devtools")
devtools::install_github("fmgarciadiaz/PortalHacienda")
```

## Ejemplo

Búsqueda de Series en el listado incluído en el paquete o en la base
online

``` r
# Cargar el paquete
library(PortalHacienda)
#> Loading required package: zoo
#> 
#> Attaching package: 'zoo'
#> The following objects are masked from 'package:base':
#> 
#>     as.Date, as.Date.numeric
#> ===========================================================================
#> Acceso API Portal datos Hacienda - v 0.1 - 12-2017 por Fernando García Díaz
#> Última actualización de la base de series incluída en el paquete: 0 días
# Buscar las series de tipo de cambio
Series_TCN <- Search("tipo de cambio")         
# mostrar las primeras series encontradas
# Series_TCN <- Search_online("tipo de cambio")         
knitr::kable(head(Series_TCN) ,"html") %>% kableExtra::kable_styling(font_size = 7)    
```

<table class="table" style="font-size: 7px; margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

catalogo\_id

</th>

<th style="text-align:right;">

dataset\_id

</th>

<th style="text-align:right;">

distribucion\_id

</th>

<th style="text-align:left;">

serie\_id

</th>

<th style="text-align:left;">

indice\_tiempo\_frecuencia

</th>

<th style="text-align:left;">

serie\_titulo

</th>

<th style="text-align:left;">

serie\_unidades

</th>

<th style="text-align:left;">

serie\_descripcion

</th>

<th style="text-align:left;">

distribucion\_titulo

</th>

<th style="text-align:left;">

distribucion\_descripcion

</th>

<th style="text-align:left;">

distribucion\_url\_descarga

</th>

<th style="text-align:left;">

dataset\_responsable

</th>

<th style="text-align:left;">

dataset\_fuente

</th>

<th style="text-align:left;">

dataset\_titulo

</th>

<th style="text-align:left;">

dataset\_descripcion

</th>

<th style="text-align:left;">

dataset\_tema

</th>

<th style="text-align:left;">

serie\_indice\_inicio

</th>

<th style="text-align:left;">

serie\_indice\_final

</th>

<th style="text-align:right;">

serie\_valores\_cant

</th>

<th style="text-align:right;">

serie\_dias\_no\_cubiertos

</th>

<th style="text-align:left;">

serie\_actualizada

</th>

<th style="text-align:right;">

serie\_valor\_ultimo

</th>

<th style="text-align:right;">

serie\_valor\_anterior

</th>

<th style="text-align:right;">

serie\_var\_pct\_anterior

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

sspm

</td>

<td style="text-align:right;">

115

</td>

<td style="text-align:right;">

115.1

</td>

<td style="text-align:left;">

115.1\_TCRM\_0\_A\_29

</td>

<td style="text-align:left;">

R/P1Y

</td>

<td style="text-align:left;">

tipo\_cambio\_real\_multilateral

</td>

<td style="text-align:left;">

Índice Dic-2001=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral: Valores anuales Índice
Diciembre 2001=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores anuales.

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores
anuales.

</td>

<td style="text-align:left;">

<http://infra.datos.gob.ar/catalog/sspm/dataset/115/distribution/115.1/download/indice-tipo-cambio-real-multilateral-valores-anuales.csv>

</td>

<td style="text-align:left;">

Subsecretaría de Programación Macroeconómica.

</td>

<td style="text-align:left;">

Banco Central de la República Argentina (BCRA)

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base Diciembre de 2001 = 100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base Diciembre de 2001 = 100

</td>

<td style="text-align:left;">

Dinero y Bancos

</td>

<td style="text-align:left;">

1991-01-01

</td>

<td style="text-align:left;">

2015-01-01

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

715

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

164.89815

</td>

<td style="text-align:right;">

908.60646

</td>

<td style="text-align:right;">

\-0.8185153

</td>

</tr>

<tr>

<td style="text-align:left;">

sspm

</td>

<td style="text-align:right;">

115

</td>

<td style="text-align:right;">

115.2

</td>

<td style="text-align:left;">

115.2\_TCRM\_0\_T\_29

</td>

<td style="text-align:left;">

R/P3M

</td>

<td style="text-align:left;">

tipo\_cambio\_real\_multilateral

</td>

<td style="text-align:left;">

Índice Dic-2001=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral: Valores trimestrales Índice
Diciembre 2001=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores trimestrales.

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores
trimestrales.

</td>

<td style="text-align:left;">

<http://infra.datos.gob.ar/catalog/sspm/dataset/115/distribution/115.2/download/indice-tipo-cambio-real-multilateral-valores-trimestrales.csv>

</td>

<td style="text-align:left;">

Subsecretaría de Programación Macroeconómica.

</td>

<td style="text-align:left;">

Banco Central de la República Argentina (BCRA)

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base Diciembre de 2001 = 100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base Diciembre de 2001 = 100

</td>

<td style="text-align:left;">

Dinero y Bancos

</td>

<td style="text-align:left;">

1991-01-01

</td>

<td style="text-align:left;">

2015-10-01

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

715

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

935.13083

</td>

<td style="text-align:right;">

884.10854

</td>

<td style="text-align:right;">

0.0577104

</td>

</tr>

<tr>

<td style="text-align:left;">

sspm

</td>

<td style="text-align:right;">

115

</td>

<td style="text-align:right;">

115.3

</td>

<td style="text-align:left;">

115.3\_TCRM\_0\_M\_29

</td>

<td style="text-align:left;">

R/P1M

</td>

<td style="text-align:left;">

tipo\_cambio\_real\_multilateral

</td>

<td style="text-align:left;">

Índice Dic-2001=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral: Valores mensuales Índice
Diciembre 2001=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores mensuales.

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores
mensuales.

</td>

<td style="text-align:left;">

<http://infra.datos.gob.ar/catalog/sspm/dataset/115/distribution/115.3/download/indice-tipo-cambio-real-multilateral-valores-mensuales.csv>

</td>

<td style="text-align:left;">

Subsecretaría de Programación Macroeconómica.

</td>

<td style="text-align:left;">

Banco Central de la República Argentina (BCRA)

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base Diciembre de 2001 = 100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base Diciembre de 2001 = 100

</td>

<td style="text-align:left;">

Dinero y Bancos

</td>

<td style="text-align:left;">

1991-01-01

</td>

<td style="text-align:left;">

2015-12-01

</td>

<td style="text-align:right;">

300

</td>

<td style="text-align:right;">

715

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

1040.58318

</td>

<td style="text-align:right;">

888.22200

</td>

<td style="text-align:right;">

0.1715350

</td>

</tr>

<tr>

<td style="text-align:left;">

sspm

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

116.1

</td>

<td style="text-align:left;">

116.1\_TCRB\_0\_A\_23

</td>

<td style="text-align:left;">

R/P1Y

</td>

<td style="text-align:left;">

tipo\_cambio\_real\_brasil

</td>

<td style="text-align:left;">

Índice 17-Dic-2015=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Brasil: Valores anuales Índice 17 de
Diciembre 2015=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores anuales. Base 2015

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores anuales. Base
2015

</td>

<td style="text-align:left;">

<http://infra.datos.gob.ar/catalog/sspm/dataset/116/distribution/116.1/download/indice-tipo-cambio-real-multilateral-valores-anuales-base-2015.csv>

</td>

<td style="text-align:left;">

Subsecretaría de Programación Macroeconómica.

</td>

<td style="text-align:left;">

Banco Central de la República Argentina (BCRA)

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base 17 de Diciembre de 2015
= 100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base 17 de Diciembre de 2015
= 100

</td>

<td style="text-align:left;">

Dinero y Bancos

</td>

<td style="text-align:left;">

1997-01-01

</td>

<td style="text-align:left;">

2016-01-01

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

349

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

104.10892

</td>

<td style="text-align:right;">

88.56342

</td>

<td style="text-align:right;">

0.1755297

</td>

</tr>

<tr>

<td style="text-align:left;">

sspm

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

116.1

</td>

<td style="text-align:left;">

116.1\_TCRCA\_0\_A\_23

</td>

<td style="text-align:left;">

R/P1Y

</td>

<td style="text-align:left;">

tipo\_cambio\_real\_canada

</td>

<td style="text-align:left;">

Índice 17-Dic-2015=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Canadá: Valores anuales Índice 17 de
Diciembre 2015=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores anuales. Base 2015

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores anuales. Base
2015

</td>

<td style="text-align:left;">

<http://infra.datos.gob.ar/catalog/sspm/dataset/116/distribution/116.1/download/indice-tipo-cambio-real-multilateral-valores-anuales-base-2015.csv>

</td>

<td style="text-align:left;">

Subsecretaría de Programación Macroeconómica.

</td>

<td style="text-align:left;">

Banco Central de la República Argentina (BCRA)

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base 17 de Diciembre de 2015
= 100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base 17 de Diciembre de 2015
= 100

</td>

<td style="text-align:left;">

Dinero y Bancos

</td>

<td style="text-align:left;">

1997-01-01

</td>

<td style="text-align:left;">

2016-01-01

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

349

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

95.02524

</td>

<td style="text-align:right;">

84.97399

</td>

<td style="text-align:right;">

0.1182861

</td>

</tr>

<tr>

<td style="text-align:left;">

sspm

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

116.1

</td>

<td style="text-align:left;">

116.1\_TCRCH\_0\_A\_22

</td>

<td style="text-align:left;">

R/P1Y

</td>

<td style="text-align:left;">

tipo\_cambio\_real\_china

</td>

<td style="text-align:left;">

Índice 17-Dic-2015=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real China: Valores anuales Índice 17 de
Diciembre 2015=100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores anuales. Base 2015

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral. Valores anuales. Base
2015

</td>

<td style="text-align:left;">

<http://infra.datos.gob.ar/catalog/sspm/dataset/116/distribution/116.1/download/indice-tipo-cambio-real-multilateral-valores-anuales-base-2015.csv>

</td>

<td style="text-align:left;">

Subsecretaría de Programación Macroeconómica.

</td>

<td style="text-align:left;">

Banco Central de la República Argentina (BCRA)

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base 17 de Diciembre de 2015
= 100

</td>

<td style="text-align:left;">

Índice de Tipo de Cambio Real Multilateral Base 17 de Diciembre de 2015
= 100

</td>

<td style="text-align:left;">

Dinero y Bancos

</td>

<td style="text-align:left;">

1997-01-01

</td>

<td style="text-align:left;">

2016-01-01

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

349

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

89.92900

</td>

<td style="text-align:right;">

81.31056

</td>

<td style="text-align:right;">

0.1059941

</td>

</tr>

</tbody>

</table>

Bajar serie con `Get` y extender 12 meses con `Forecast` (usa modelo
auto-detectado del paquete ***forecast***). Luego hacer un plot
sencillo.

``` r

TCN <- Forecast(Get("174.1_T_DE_CATES_0_0_32" , start_date = 2000), 12)       
#> [1] "Cargados 215 datos, desde 2000-01-01 hasta 2017-11-01 Periodicidad estimada: monthly"
#> [1] "Serie extendida 12 períodos, usando el modelo auto detectado: ARIMA(0,2,1)(0,0,2)[12]"
# Mostrar resultado
plot(TCN , main = "Tipo de Cambio Nominal ($/USD)")
```

![](README-example2-1.png)<!-- -->

# Estado del Proyecto

  - \[x\] Funcionalidad básica
  - \[ \] Captura de errores de uso o en la devolución de datos
