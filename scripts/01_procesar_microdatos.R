# Modo B: calcula los indicadores del informe a partir de los microdatos APS/NES
# y los escribe como CSV en ediciones/<edicion>/procesados/, con el mismo formato
# que se usaría en el modo A (datos entregados). Los capítulos no distinguen
# de qué modo salieron los CSVs.
#
# Uso:  Rscript scripts/01_procesar_microdatos.R
#
# Requiere: haven (lectura .sav/.dta), srvyr (estimaciones con pesos muestrales).

library(dplyr)
library(haven)
library(srvyr)

source(here::here("R", "utilidades.R"))

cfg <- leer_config()
dir_micro <- ruta_edicion("microdatos")
dir_out <- ruta_edicion("procesados")
dir.create(dir_out, showWarnings = FALSE, recursive = TRUE)

# ---------------------------------------------------------------------------
# 1. APS (Adult Population Survey)
# ---------------------------------------------------------------------------
# Ajustar el nombre del fichero al que entregue GEM cada año.
fichero_aps <- file.path(dir_micro, paste0("GEM_APS_", cfg$anio_campo, ".sav"))
stopifnot("Falta el fichero APS en microdatos/" = file.exists(fichero_aps))

aps <- read_sav(fichero_aps) |>
  # Variables estándar del fichero armonizado GEM; revisar el codebook anual.
  as_survey_design(weights = weight)

# TEA: % de población 18-64 involucrada en actividad emprendedora naciente o nueva
tea_actual <- aps |>
  filter(age >= 18, age <= 64) |>
  summarise(tea = survey_mean(TEAyy == 1, na.rm = TRUE) * 100)

# Serie histórica: añade el dato nuevo a la serie de la edición anterior.
edicion_base <- if (is.null(cfg$edicion_anterior)) cfg$edicion else cfg$edicion_anterior
serie_previa <- ruta_edicion("procesados", "serie_tea.csv", edicion = edicion_base)
serie_tea <- if (file.exists(serie_previa)) {
  readr::read_csv(serie_previa, show_col_types = FALSE)
} else {
  tibble(anio = integer(), ambito = character(), tea = double())
}
serie_tea <- serie_tea |>
  bind_rows(tibble(anio = cfg$anio_campo, ambito = "Extremadura", tea = tea_actual$tea)) |>
  distinct(anio, ambito, .keep_all = TRUE) |>
  arrange(ambito, anio)

readr::write_csv(serie_tea, file.path(dir_out, "serie_tea.csv"))

# ---------------------------------------------------------------------------
# 2. NES (National Expert Survey) — mismo patrón: leer, estimar, escribir CSV
# ---------------------------------------------------------------------------
# TODO cuando haya microdatos NES: condiciones del entorno emprendedor.

message("Indicadores escritos en ", dir_out)
