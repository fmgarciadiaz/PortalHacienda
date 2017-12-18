# =====================================================
# Libreria para Carga de Datos del Portal de Hacienda
# FERGD 12-2017
# =====================================================

#' @importFrom magrittr "%>%"
#' @export
magrittr::`%>%`
#' @importFrom utils "download.file"

# Mensaje de Bienvenida
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Acceso al Portal de Datos de Hacienda - v0.1 - 12-2017 - fgd")
}

# Estructura de carpetas
"%+%" <- function(x, y) paste(x, y, sep = "") # se define %+% como concatenacion


# Helpers
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
#' \code{Get} devuelve la serie seleccionada en series = ID
#' @param series ID de la serie a obtener
#' @param start_date Fecha de inicio
#' @param end_date Fecha de final
#'
#' @return Un objeto XTS con la serie seleccionada en ID
#' @export
#' @examples
#' X <- Get("138.1_PAPDE_0_M_41")
Get <- function(series, start_date = NULL, end_date = NULL) {
  url_base <- "http://apis.datos.gob.ar/series/api/series?"                      # Cambiar URL base si cambia en la WEB
  suppressMessages(serie <- httr::content(httr::GET(url = url_base, query = list(ids = series,
                                                                      start_date = start_date,
                                                                      end_date = end_date,
                                                                      format = "csv",
                                                                      limit = 1000), encoding = "UTF-8")))
  serie <- xts::xts(serie[, -1], order.by = lubridate::ymd(serie$indice_tiempo), unique = TRUE)  # Pasar a XTS
  attr(serie, "frequency") <- freq(serie)                                        # Fijar frecuencia de la serie en el XTS
  print("Cargados " %+% length(serie) %+% " datos, desde " %+% min(zoo::index(serie)) %+%
          " hasta " %+% max(zoo::index(serie)) %+% " Periodicidad: " %+% xts::periodicity(serie)$scale)
  return(serie)
}

# ==========================================================================
#' Extender series con forecast de auto.arima
#'
#' @param SERIE XTS a extender
#'
#' @param N Cantidad de períodos a extender
#'
#' @return XTS con la serie expandida e intervalos de confianza al 95%
#'
#' @export
#'
#' @importFrom zoo "as.Date"
#'
#' @examples
#' X <- PortalHacienda::Forecast(Get("138.1_PAPDE_0_M_41"),12)
Forecast <- function(SERIE, N = 6) {
  attr(SERIE, "frequency") <- freq(SERIE)                                                   # Fijar su frecuencia en base a estimacion de periocididad
  SERIE.model <- forecast::auto.arima(SERIE, seasonal = TRUE, allowdrift = TRUE)             # Estimar modelo (clave fijar frecuencia antes!)
  SERIE.fit <- forecast::forecast(SERIE.model, h = N, level = c(95))                         # Extraer forecasts
  #PIB <- xts(PIB, order.by = as.yearqtr(index(PIB), format = "%Y-%m-%d"))
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
#' Buscar series en el último archivo de meta-datos descargado
#' Busca series con el pattern deseado - descarga la serie
#' @param PATTERN Pattern de búsqueda en la descripción de la serie
#'
#' @return Tibble con las series disponibles que con descripción coincidente
#'
#' @export
#'
#' @examples
#' Listado <- SeriesSearch("PIB")
Search <- function(PATTERN = "*") {
  return(Listado %>% dplyr::filter(grepl(PATTERN, serie_descripcion, ignore.case = TRUE)) %>%
           tibble::as.tibble())
}

# ==========================================================================
#' Actualizar meta-datos series
#'
#'@export
#'
#' @examples
#' Listado_Update()
Listado_Update <- function() {
  Listado <- data.table::fread("http://infra.datos.gob.ar/catalog/modernizacion/dataset/1/distribution/1.2/download/series-tiempo-metadatos.csv")
  devtools::use_data(Listado , overwrite = TRUE)
  print("Meta-datos actualizados")
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
