# =====================================================
# Libreria para Carga de Datos del Portal de Hacienda
# Buscar, descargar y proyectar rápidamente series.
# FERGD 12-2017
# =====================================================

# Importar el operador de pipe
#' @importFrom magrittr "%>%"
#' @export
magrittr::`%>%`
#' @importFrom utils "download.file"

# Mensaje de Bienvenida
.onAttach <- function(libname, pkgname) {
  dias <- format(as.numeric(difftime(Sys.time(), LastUpdate, units = "days")), digits = 0)
  packageStartupMessage(
    "===========================================================================" %+% "\n" %+%
    "Acceso API Portal datos Hacienda - v 0.1 - 12-2017 por Fernando García Díaz" %+% "\n" %+%
    "Última actualización de la base de series incluída en el paquete: " %+% dias %+% " días")
}

# Definicion Funciones internas helpers
# Concatenar
"%+%" <- function(x, y) paste(x, y, sep = "")
# Detectar periocididad para lags
freq <- function(x) {
                      switch(xts::periodicity(x)$scale,
                      daily = 365,
                      weekly = 52,
                      monthly = 12,
                      quarterly = 4,
                      yearly = 1)
  }

# ==========================================================================
#' Acceder a la API del Portal de Datos
#'
#' \code{Get} devuelve la serie seleccionada en series = ID. Para un detalle sobre las opciones
#' disponibles en parámetros consultar:
#' \url{http://series-tiempo-ar-api.readthedocs.io/es/latest/api_reference/#tabla-de-parametros}
#'
#' @param series ID de la serie a obtener
#' @param start_date Fecha de inicio
#' @param end_date Fecha de final
#' @param representacion_mode Indica el modo de representación de las series
#' @param collapse Modifica la frecuencia de muestreo de los datos de la serie
#' @param collapse_aggregation Indica la función de agregación temporal que debe usarse para homogeneizar la frecuencia temporal de todas las series solicitadas
#'
#' @return Un objeto XTS con la serie seleccionada en ID
#' @export
#' @examples
#' # Cargar serie mensual de TCN
#' TCN     <- Get("174.1_T_DE_CATES_0_0_32")
#' # Cargar serie mensual de TCN, transformada en anual y en variaciones
#' TCN_var <- Get("174.1_T_DE_CATES_0_0_32" , start_date = 1999 , collapse = "year" , collapse_aggregation = "avg", representation_mode = "percent_change")  * 100
Get <- function(series, start_date = NULL, end_date = NULL, representation_mode = NULL,
                collapse = NULL, collapse_aggregation = NULL) {
  url_base <- "http://apis.datos.gob.ar/series/api/series?"          # Cambiar URL base si cambia en la WEB
  suppressMessages(serie <- httr::content(httr::GET(url = url_base, query = list(ids = series,
                                                                      start_date = start_date,
                                                                      end_date = end_date,
                                                                      representation_mode = representation_mode,
                                                                      collapse = collapse,
                                                                      collapse_aggregation = collapse_aggregation,
                                                                      format = "csv",
                                                                      limit = 1000), encoding = "UTF-8")))
  serie <- xts::xts(serie[, -1], order.by = lubridate::ymd(serie$indice_tiempo), unique = TRUE)  # Pasar a XTS
  attr(serie, "frequency") <- freq(serie)                                        # Fijar frecuencia de la serie en el XTS
  print("Cargados " %+% length(serie) %+% " datos, desde " %+% min(zoo::index(serie)) %+%
          " hasta " %+% max(zoo::index(serie)) %+% " Periodicidad estimada: " %+% xts::periodicity(serie)$scale)
  return(serie)
}

# ==========================================================================
#' Extender series con proyecciones de auto.arima (paquete Forecast)
#' (Recomendado sólo para estimaciones rápidas)
#'
#' @param SERIE XTS a extender
#'
#' @param N Cantidad de períodos a extender (detecta automáticamente la frecuencia de la serie)
#'
#' @return XTS con la serie expandida e intervalos de confianza al 95%
#'
#' @export
#'
#' @importFrom zoo "as.Date"
#'
#' @examples
#' # Forecast de 12 meses del tipo de cambio
#' X <- PortalHacienda::Forecast(Get("174.1_T_DE_CATES_0_0_32"),12)
Forecast <- function(SERIE, N = 6) {
  attr(SERIE, "frequency") <- freq(SERIE)                                                   # Fijar su frecuencia en base a estimacion de periocididad
  SERIE.model <- forecast::auto.arima(SERIE, seasonal = TRUE, allowdrift = TRUE)             # Estimar modelo (clave fijar frecuencia antes!)
  SERIE.fit <- forecast::forecast(SERIE.model, h = N, level = c(95))                         # Extraer forecasts
  # Construir el objeto XTS a partir del PIB.fit (porque sino devuelve fechas mal e inusable)
  SERIE.final <- cbind(y = SERIE, y.lo = NA, y.hi = NA)                                     # agregar columnas dymmy
  SERIE.final <- rbind(SERIE.final,                                                         # pega el forecast, al que a su vez le pego fechas corregidas
                       xts::xts(cbind(y = SERIE.fit$mean, y.lo = SERIE.fit$lower, y.hi = SERIE.fit$upper),
                       timetk::tk_make_future_timeseries(zoo::as.Date(timetk::tk_index(SERIE, timetk_idx = TRUE)),
                                     n_future = N,
                                     inspect_weekdays = TRUE,
                                     inspect_months = TRUE)))
  colnames(SERIE.final)[1] <- "y"
  print("Serie extendida " %+% N %+% " períodos, usando el modelo auto detectado: " %+% SERIE.model)
  return(SERIE.final )
}


# ==========================================================================
#' Buscar series en el archivo de meta-datos descargado con el paquete
#' Si se desea utilizar la versión online más actualizada usar Search_online (sólo con conexión a internet)
#'
#' @param PATTERN Pattern de búsqueda en la descripción de la serie
#'
#' @return Tibble con las series disponibles que con descripción coincidente
#'
#' @export
#'
#' @examples
#' Listado <- Search("Tipo de Cambio")
Search <- function(PATTERN = "*") {
  return(Listado %>% dplyr::filter(grepl(PATTERN, serie_descripcion, ignore.case = TRUE)) %>%
           tibble::as.tibble())
}


#' Buscar series
#'
#' Buscar en el archivo de meta-datos online del Portal de Hacienda.
#' Utilizar \code{Search_online("*")} para descargar todos los metadatos y hacer búsquedas posteriores
#' sin descargar toda la base nuevamente.
#'
#' @param PATTERN Pattern de búsqueda en la descripción de la serie
#'
#' @return Tibble con las series disponibles que con descripción coincidente
#' @export
#'
#' @examples
#' Listado <- Search_online("Tipo de Cambio")
#' Todaslasseries <- Search_online("*")
Search_online <- function(PATTERN = "*") {
  Temp <- data.table::fread("http://infra.datos.gob.ar/catalog/modernizacion/dataset/1/distribution/1.2/download/series-tiempo-metadatos.csv")
  return(Temp %>% dplyr::filter(grepl(PATTERN, serie_descripcion, ignore.case = TRUE)) %>%
           tibble::as.tibble())
}

#' Listado de Series del Portal de Hacienda
#'
#' Listado completo de series. Actualizar con \code{Listado_Update()}
#'
#'
#'@source \url{http://infra.datos.gob.ar/catalog/modernizacion/dataset/1/distribution/1.2/download/series-tiempo-metadatos.csv}
"Listado"

# Para correr antes de deploy
# devtools::document()
# devtools::use_testthat()
# lintr::lint_package()
# devtools::use_data_raw()      # Crear carpeta DATA_RAW donde van las bases en CSV y scripts de creacion
# devtools::use_readme_rmd()

# Imports
# devtools::use_package("dplyr", type = "Imports")
# devtools::use_package("forecast", type = "Imports")
# devtools::use_package("nlme", type = "Imports")
# devtools::use_package("foreign", type = "Imports")
# devtools::use_package("timetk", type = "Imports")
# devtools::use_package("data.table", type = "Imports")
# devtools::use_package("lubridate", type = "Imports")
# devtools::use_package("zoo", type = "Depends")
# devtools::use_package("tidyquant", type = "Imports")
# devtools::use_package("xts", type = "Imports")
# devtools::use_package("httr", type = "Imports")
# devtools::use_package("tibble", type = "Imports")
# devtools::use_package("magrittr", type = "Imports")
