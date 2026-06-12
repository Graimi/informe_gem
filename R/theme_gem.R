# Identidad gráfica del informe. Paleta tomada de la portada 2025/26
# (azul marino + verde GEM + teal); las convenciones de maquetación de los
# gráficos (etiquetas de datos, leyenda abajo, rejilla mínima) replican el
# estilo del informe GEM España. Si la imagen corporativa cambia, este y
# informe/estilo-gem.typ son los ÚNICOS ficheros que hay que tocar.

colores_gem <- list(
  azul    = "#0E2A3A",  # azul marino de fondo de portada
  verde   = "#A6CE39",  # verde GEM (titulares "Extremadura", acentos)
  teal    = "#1F6E7E",  # tono intermedio de la red de nodos
  gris    = "#8A9BA8",  # texto secundario / ejes
  claro   = "#EEF3F5",  # fondos de paneles
  negro   = "#1A1A1A"   # serie secundaria en comparativas por año
)

# Paleta discreta para series (ámbitos, categorías)
paleta_gem <- unname(unlist(colores_gem[c("verde", "azul", "teal", "gris")]))

# Paleta para comparativas de 2-3 años (estilo GEM España: azul/negro/verde),
# del año más antiguo al actual.
paleta_anios <- unname(unlist(colores_gem[c("azul", "negro", "verde")]))

theme_gem <- function(base_size = 11) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        face = "bold", colour = colores_gem$azul, size = base_size + 2
      ),
      plot.subtitle = ggplot2::element_text(colour = colores_gem$gris),
      plot.caption = ggplot2::element_text(colour = colores_gem$gris, size = base_size - 3),
      axis.title = ggplot2::element_text(colour = colores_gem$azul),
      axis.text = ggplot2::element_text(colour = colores_gem$azul),
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = "bottom",
      legend.title = ggplot2::element_blank()
    )
}

# Formato de porcentaje para etiquetas de datos sobre puntos/barras, como en
# los gráficos del GEM España (cada observación lleva su valor impreso).
# Uso: geom_text(aes(label = fmt_pct(tea)), vjust = -1, size = 3)
fmt_pct <- function(x, decimales = 1) {
  paste0(format(round(x, decimales), decimal.mark = ",", trim = TRUE), "%")
}
