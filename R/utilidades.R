# Funciones comunes de configuración y lectura de datos.
# Los capítulos .qmd y los scripts cargan este fichero al principio.
#
# La raíz del proyecto se localiza con el fichero centinela .gem_root, no con
# `here`: como _quarto.yml vive en informe/, `here` anclaría ahí y no en la raíz
# del repo (donde están R/ y ediciones/). El centinela es robusto a cualquier
# directorio de trabajo.

raiz_proyecto <- function() {
  rprojroot::find_root(rprojroot::has_file(".gem_root"))
}

# Atajos para construir rutas desde la raíz del proyecto.
ruta_R <- function(...) file.path(raiz_proyecto(), "R", ...)

ruta_edicion <- function(..., edicion = leer_config()$edicion) {
  file.path(raiz_proyecto(), "ediciones", edicion, ...)
}

# Lee informe/_variables.yml: misma configuración para Quarto y para R.
# Forzamos lectura UTF-8 para no depender del locale del sistema (en algunos
# entornos es C y rompería los acentos del fichero).
leer_config <- function() {
  ruta <- file.path(raiz_proyecto(), "informe", "_variables.yml")
  yaml::yaml.load(paste(readLines(ruta, encoding = "UTF-8", warn = FALSE),
                        collapse = "\n"))
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
