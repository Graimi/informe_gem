# Identidad gráfica del informe, tomada de la portada de la edición 2025/26:
# azul marino profundo de fondo, verde GEM como acento, apoyos en teal.
# Si la imagen corporativa cambia, este es el ÚNICO fichero que hay que tocar.

colores_gem <- list(
  azul    = "#0E2A3A",  # azul marino de fondo de portada
  verde   = "#A6CE39",  # verde GEM (titulares "Extremadura", acentos)
  teal    = "#1F6E7E",  # tono intermedio de la red de nodos
  gris    = "#8A9BA8",  # texto secundario / ejes
  claro   = "#Eef3F5"   # fondos de paneles
)

# Paleta discreta para series (regiones, años, categorías)
paleta_gem <- unname(unlist(colores_gem[c("verde", "azul", "teal", "gris")]))

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
