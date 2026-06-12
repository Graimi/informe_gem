# Funciones comunes de configuración y lectura de datos.
# Los capítulos .qmd y los scripts cargan este fichero con source().

library(here)

# Lee informe/_variables.yml: misma configuración para Quarto y para R.
leer_config <- function() {
  yaml::read_yaml(here("informe", "_variables.yml"))
}

ruta_edicion <- function(..., edicion = leer_config()$edicion) {
  here("ediciones", edicion, ...)
}

# Lee un indicador de procesados/ por nombre, p. ej. leer_indicador("serie_tea").
# Da un error claro si falta el fichero, con la pista de qué modo lo genera.
leer_indicador <- function(nombre, edicion = leer_config()$edicion) {
  fichero <- ruta_edicion("procesados", paste0(nombre, ".csv"), edicion = edicion)
  if (!file.exists(fichero)) {
    stop(
      "No existe ", fichero, ".\n",
      "Modo A: vuelca la tabla entregada a ese CSV ",
      "(ver ediciones/", edicion, "/datos_entregados/README.md).\n",
      "Modo B: ejecuta scripts/01_procesar_microdatos.R."
    )
  }
  readr::read_csv(fichero, show_col_types = FALSE)
}
