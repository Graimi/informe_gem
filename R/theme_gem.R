# Identidad gráfica del informe GEM Extremadura.
# Convenciones de maquetación inspiradas en el informe GEM España (etiquetas de
# datos, leyenda abajo, rejilla mínima). Si la imagen corporativa cambia, este
# fichero e informe/estilo-gem.typ son los ÚNICOS que hay que tocar.

# --- Paleta base de identidad (portada 2025/26) -----------------------------
colores_gem <- list(
  azul   = "#0E2A3A",  # azul marino de portada (= Unión Europea)
  verde  = "#3FA535",  # verde GEM (= Extremadura)
  teal   = "#1F6E7E",
  gris   = "#8A9BA8",  # ejes / texto secundario
  gris_b = "#D9DEE2",  # barras neutras (CCAA sin dato numérico)
  claro  = "#EEF3F5",
  negro  = "#1A1A1A"
)

# --- Registro de color por VARIABLE -----------------------------------------
# REGLA: cada variable tiene un color propio y ese color NO se reutiliza para
# otra variable, aunque aparezca en gráficos o capítulos distintos. Al añadir
# una variable nueva, asignarle aquí un color libre.
col_var <- c(
  # Ámbitos territoriales
  "Extremadura"     = "#3FA535",  # verde
  "España"          = "#D7263D",  # rojo
  "Unión Europea"   = "#0E2A3A",  # azul oscuro
  "Europa"          = "#0E2A3A",  # alias (media europea)
  "Cáceres"         = "#7B2D42",  # burdeos
  "Badajoz"         = "#F2B705",  # amarillo
  # Fases del proceso emprendedor (gama de azules)
  "Potenciales"     = "#9ECAE1",
  "TEA"             = "#3182BD",
  "Establecidas"    = "#08519C",
  "Consolidadas"    = "#08519C",
  "Nacientes"       = "#6BAED6",
  "Nuevas"          = "#C6DBEF",
  "Abandono"        = "#E6842E",  # naranja
  # Género (par fijo allá donde aparezca)
  "Hombre"          = "#2C7FB8",
  "Mujer"           = "#DD3497",
  # Colectivos APS
  "Población involucrada"     = "#3182BD",
  "Población no involucrada"  = "#9ECAE1"
)

# Devuelve el vector de colores para las variables presentes; avisa si falta.
escala_var <- function(...) {
  vars <- unique(unlist(list(...)))
  faltan <- setdiff(vars, names(col_var))
  if (length(faltan)) warning("Sin color asignado en col_var: ", paste(faltan, collapse = ", "))
  col_var[intersect(vars, names(col_var))]
}

theme_gem <- function(base_size = 12) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      plot.title    = ggplot2::element_text(face = "bold", colour = colores_gem$azul,
                        size = base_size + 3, margin = ggplot2::margin(b = 1)),
      plot.subtitle = ggplot2::element_text(colour = colores_gem$teal,
                        size = base_size - 1, margin = ggplot2::margin(b = 10)),
      plot.caption  = ggplot2::element_text(colour = colores_gem$gris, size = base_size - 4,
                        hjust = 0, margin = ggplot2::margin(t = 12)),
      axis.title    = ggplot2::element_text(colour = colores_gem$gris),
      axis.text     = ggplot2::element_text(colour = colores_gem$azul),
      panel.grid.minor   = ggplot2::element_blank(),
      panel.grid.major   = ggplot2::element_line(colour = colores_gem$gris_b, linewidth = 0.3),
      legend.position    = "bottom",
      legend.title       = ggplot2::element_blank(),
      legend.key.size    = grid::unit(11, "pt"),
      legend.text        = ggplot2::element_text(colour = colores_gem$azul, size = base_size - 2),
      plot.margin        = ggplot2::margin(14, 20, 10, 14)
    )
}

# Barras "píldora": esquinas redondeadas mediante borde del mismo color con
# unión redonda (estable, sin dependencias externas). Usar con aes(fill, colour).
geom_pill <- function(..., width = 0.62, dodge = NULL, radio = 2.4) {
  pos <- if (is.null(dodge)) "stack" else ggplot2::position_dodge(dodge)
  ggplot2::geom_col(..., position = pos, width = width,
                    linewidth = radio, linejoin = "round")
}

# Etiqueta de porcentaje con UN decimal y coma decimal (norma del informe).
# Acepta x en escala 0-100 (por defecto) o 0-1 (escala_0_1 = TRUE).
fmt_pct <- function(x, escala_0_1 = FALSE) {
  if (escala_0_1) x <- x * 100
  paste0(formatC(round(x, 1), format = "f", digits = 1, decimal.mark = ","), "%")
}

# Número con un decimal y coma (para escalas NES 0-10).
fmt_num <- function(x) formatC(round(x, 1), format = "f", digits = 1, decimal.mark = ",")
