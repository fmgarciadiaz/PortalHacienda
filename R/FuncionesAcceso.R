# Libreria para Carga de Datos del Portal de Hacienda#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'



# Mensaje de Bienvenida
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Acceso al Portal de Datos de Hacienda. FGD 2017.")
}


# Estructura de carpetas
"%+%" <- function(x,y) paste(x,y,sep="") # se define %+% como concatenacion
data_dir <- "/data/"

# Funcion de Carga de Datos desde la API y Helpers
# Detectar periocididad para lags
freq <- function(x) {switch(xts::periodicity(x)$scale,
                            daily=365,
                            weekly=52,
                            monthly=12,
                            quarterly=4,
                            yearly=1)}

#' Get
#' obtiene las series seleccionadas de la API del Portal de Datos
#' @param series ID de la serie a obtener
#' @param start_date Fecha de inicio
#' @param end_date Fecha de final
#'
#' @return Un objeto XTS con la serie seleccionada en ID
#' @export
#'
#' @examples
#' X <- Get("138.1_PAPDE_0_M_41")
Get <- function(series , start_date = NULL, end_date = NULL) {
  url_base = 'http://apis.datos.gob.ar/series/api/series?'                       # Cambiar URL base si cambia en la WEB
  suppressMessages(serie <- httr::content(httr::GET(url = url_base , query = list(ids = series ,
                                                                      start_date = start_date,
                                                                      end_date = end_date,
                                                                      format = "csv" ,
                                                                      limit = 1000), encoding = "UTF-8")))
  serie <- xts::xts(serie[,-1], order.by = lubridate::ymd(serie$indice_tiempo) , unique = TRUE)  # Pasar a XTS
  attr(serie, 'frequency') <- freq(serie)                                        # Fijar frecuencia de la serie en el XTS
  print("Cargados " %+% length(serie) %+% " datos, desde " %+% min(zoo::index(serie)) %+%
          " hasta " %+% max(zoo::index(serie)) %+% " Periodicidad: " %+% xts::periodicity(serie)$scale)
  return(serie)
}

#' Forecast
#' Extender series con forecast de auto.arima
#' @param SERIE XTS a extender
#' @param N Cantidad de períodos a extender
#'
#' @return XTS con la serie expandida e intervalos de confianza al 95%
#' @export
#'
#' @examples
#' Forecast(Get("138.1_PAPDE_0_M_41"),12)
Forecast <-function(SERIE , N = 6) {
  attr(SERIE, 'frequency') <- freq(SERIE)                                                   # Fijar su frecuencia en base a estimacion de periocididad
  SERIE.model <- forecast::auto.arima(SERIE, seasonal=TRUE , allowdrift = TRUE)             # Estimar modelo (clave fijar frecuencia antes!)
  SERIE.fit <- forecast::forecast(SERIE.model, h=N , level = c(95))                         # Extraer forecasts
  #PIB <- xts(PIB, order.by = as.yearqtr(index(PIB), format = "%Y-%m-%d"))
  # Construir el objeto XTS a partir del PIB.fit (porque sino devuelve fechas mal e inusable)
  SERIE.final <- cbind(y = SERIE, y.lo = NA, y.hi = NA)                                     # agregar columnas dymmy
  SERIE.final <- rbind(SERIE.final,                                                         # pega el forecast, al que a su vez le pego fechas corregidas
                       xts::xts(cbind(y = SERIE.fit$mean, y.lo = SERIE.fit$lower, y.hi = SERIE.fit$upper),
                       timetk::tk_make_future_timeseries(timetk::tk_index(SERIE), n_future = N)))
  colnames(SERIE.final)[1] <- "y"
  return(SERIE.final)
}

#' List
#' Buscar series con el pattern deseado
#' @param PATTERN Pattern de búsqueda en la descripción de la serie
#'
#' @return Tibble con las series disponibles que con descripción coincidente
#' @export
#'
#' @examples
#' SeriesPIB <- List("PIB")
List <- function(PATTERN = "*") {
  if (is.element(difftime(Sys.time(), file.info(data_dir %+% "series-tiempo-metadatos.csv")$ctime, units = "days") > 30, T) | !file.exists(data_dir %+% "series-tiempo-metadatos.csv"))
  {
    print("Descargando archivo de metadatos, archivo no presente o descargado hace más de un mes.")
    download.file("http://infra.datos.gob.ar/catalog/modernizacion/dataset/1/distribution/1.2/download/series-tiempo-metadatos.csv", destfile = data_dir %+% "series-tiempo-metadatos.csv")
    Series <- data.table::fread(data_dir %+% "series-tiempo-metadatos.csv")
  } else {
    print("Utilizando archivo de metadatos descargado hace menos de un mes.")
    Series <- data.table::fread(data_dir %+% "series-tiempo-metadatos.csv")
  }
  Series <- Series %>% dplyr::filter(grepl(PATTERN, serie_descripcion, ignore.case = TRUE)) %>% tibble::as.tibble()
  print("Encontradas " %+% length(Series$catalogo_id) %+% " serie/s.")
  return(Series)
}

# Para correr antes de deploy
#devtools::document()

# Imports
#devtools::use_package("dplyr", type = "Imports")
#devtools::use_package("forecast", type = "Imports")
#devtools::use_package("timetk", type = "Imports")
#devtools::use_package("data.table", type = "Imports")
#devtools::use_package("lubridate", type = "Imports")
#devtools::use_package("zoo", type = "Imports")
#devtools::use_package("tidyquant", type = "Imports")
#devtools::use_package("xts", type = "Imports")

