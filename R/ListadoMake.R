# Generador de Listado de Metadatos
# Correr para actualizar RDA de datos utilizado por el paquete PortalHacienda

library(tidyverse)

"%+%" <- function(x, y) paste(x, y, sep = "") # se define %+% como concatenacion
data_raw <- "data-raw/"

# ==========================================================================
#' Armar la base de metadatos de series
#' Buscar series con el pattern deseado - descarga la serie
#' @param PATTERN Pattern de búsqueda en la descripción de la serie
#'
#' @return Tibble con las series disponibles que con descripción coincidente
#'
#' Listado <- List("PIB")
ListadoMake <- function() {
  if (is.element(difftime(Sys.time(), file.info(data_raw %+% "series-tiempo-metadatos.csv")$ctime, units = "days") > 30, T) | !file.exists(data_raw %+% "series-tiempo-metadatos.csv")) {
    print("Descargando archivo de metadatos, archivo no presente o descargado hace más de un mes.")
    download.file("http://infra.datos.gob.ar/catalog/modernizacion/dataset/1/distribution/1.2/download/series-tiempo-metadatos.csv", destfile = data_raw %+% "series-tiempo-metadatos.csv")
    Series <- data.table::fread(data_raw %+% "series-tiempo-metadatos.csv")
  } else {
    print("Utilizando archivo de metadatos descargado hace menos de un mes.")
    Series <- data.table::fread(data_raw %+% "series-tiempo-metadatos.csv")
  }
  Series <- Series %>% tibble::as.tibble()
  print("Encontradas " %+% length(Series$catalogo_id) %+% " serie/s.")
  return(Series)
}

# Descargar Metadatos si tienen mas de un mes
Listado <- ListadoMake()
LastUpdate <- Sys.time()
devtools::use_data(Listado, overwrite = TRUE)
devtools::use_data(LastUpdate, overwrite = TRUE)
