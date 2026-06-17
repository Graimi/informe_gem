# Funciones de gráficos del Capítulo 1 (Contexto emprendedor).
# Cada función lee un CSV de procesados/ y devuelve un objeto ggplot listo para
# incrustar en el qmd. Requiere haber cargado antes theme_gem.R (col_var,
# theme_gem, geom_pill, fmt_pct, fmt_num, escala_var, colores_gem).

suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(readr)
})

# Envuelve etiquetas largas en varias líneas.
.wrap <- function(x, n = 30) vapply(x, function(s) paste(strwrap(s, n), collapse = "\n"), character(1))

# Lee un CSV de la carpeta procesados de la edición activa.
.leer <- function(archivo) {
  readr::read_csv(file.path(ruta_edicion("procesados"), archivo), show_col_types = FALSE)
}

# Solo rejilla vertical tenue (para barras horizontales).
.grid_x <- function() theme(panel.grid.major.y = element_blank(),
                            panel.grid.major.x = element_line(colour = colores_gem$gris_b, linewidth = 0.3),
                            axis.text.x = element_blank())

# --- A) Barras agrupadas por ámbito (Extr/Esp/UE o Extr/Cáceres/Badajoz) ------
g_barras_ambito <- function(archivo, orden, titulo, fuente, col = "pct",
                            campo_cat = "indicador", subt = NULL) {
  d <- .leer(archivo)
  cat_levels <- unique(d[[campo_cat]])
  d <- d |> mutate(ambito = factor(ambito, levels = orden),
                   cat = factor(.wrap(.data[[campo_cat]]), levels = rev(.wrap(cat_levels))))
  es_nes <- col == "nes"; valcol <- if (es_nes) "valor" else "pct"
  lab <- if (es_nes) fmt_num(d[[valcol]]) else fmt_pct(d[[valcol]])
  lim <- if (es_nes) c(0, 10.6) else c(0, max(d[[valcol]]) * 1.22)

  ggplot(d, aes(.data[[valcol]], cat, fill = ambito, colour = ambito)) +
    { if (es_nes) geom_vline(xintercept = 5, linetype = "dotted", colour = colores_gem$gris, linewidth = 0.4) } +
    geom_pill(width = 0.44, dodge = 0.92, radio = 2) +
    geom_text(aes(label = paste0("   ", lab)), position = position_dodge(0.92), hjust = 0,
              size = 2.5, fontface = "bold", show.legend = FALSE) +
    scale_fill_manual(values = escala_var(orden)) +
    scale_colour_manual(values = escala_var(orden)) +
    scale_x_continuous(limits = lim, expand = expansion(mult = c(0, 0))) +
    guides(colour = "none") +
    labs(title = titulo, subtitle = subt, x = NULL, y = NULL, caption = fuente) +
    theme_gem() + .grid_x()
}

# --- B) Extremadura: año anterior vs actual -----------------------------------
g_barras_anio <- function(archivo, titulo, fuente, subt = NULL) {
  d <- .leer(archivo)
  cat_levels <- unique(d$indicador)
  d <- d |> mutate(anio = factor(anio),
                   cat = factor(.wrap(indicador), levels = rev(.wrap(cat_levels))))
  cols <- c("2024" = colores_gem$gris_b, "2025" = unname(col_var["Extremadura"]))
  ggplot(d, aes(pct, cat, fill = anio, colour = anio)) +
    geom_pill(width = 0.46, dodge = 0.78, radio = 2) +
    geom_text(aes(label = paste0("   ", fmt_pct(pct)), colour = anio), position = position_dodge(0.78),
              hjust = 0, size = 2.6, fontface = "bold", show.legend = FALSE) +
    scale_fill_manual(values = cols) +
    scale_colour_manual(values = c("2024" = colores_gem$gris, "2025" = unname(col_var["Extremadura"]))) +
    scale_x_continuous(limits = c(0, max(d$pct) * 1.22), expand = expansion(mult = c(0, 0))) +
    guides(colour = "none") +
    labs(title = titulo, subtitle = subt, x = NULL, y = NULL, caption = fuente) +
    theme_gem() + .grid_x()
}

# --- C) Serie histórica 2015-2025 por colectivo (involucrada / no) ------------
g_serie_colectivo <- function(archivo, indicador_sel, titulo, fuente) {
  niveles <- c("Población involucrada", "Población no involucrada")
  d <- .leer(archivo) |> filter(indicador == indicador_sel) |>
    mutate(colectivo = factor(colectivo, levels = niveles))
  ult <- d |> filter(anio == max(anio))
  ggplot(d, aes(anio, pct, colour = colectivo)) +
    geom_line(linewidth = 1.3) +
    geom_point(size = 3.4, colour = "white") +
    geom_point(size = 2.1) +
    geom_text(data = ult, aes(label = fmt_pct(pct)), hjust = -0.25, size = 3,
              fontface = "bold", show.legend = FALSE) +
    scale_colour_manual(values = escala_var(niveles)) +
    scale_x_continuous(breaks = 2015:2025, expand = expansion(mult = c(0.02, 0.10))) +
    scale_y_continuous(labels = function(x) fmt_pct(x), limits = c(0, NA)) +
    labs(title = titulo, x = NULL, y = NULL, caption = fuente) +
    theme_gem() +
    theme(panel.grid.major.x = element_blank())
}

# --- D) Por género (Hombre/Mujer) a través de colectivos ----------------------
g_genero <- function(archivo, indicador_sel, titulo, fuente) {
  d <- .leer(archivo) |> filter(indicador == indicador_sel) |>
    mutate(colectivo = factor(colectivo,
             levels = c("Total", "Población no involucrada", "Población involucrada")),
           sexo = factor(sexo, levels = c("Hombre", "Mujer")))
  ggplot(d, aes(pct, colectivo, fill = sexo, colour = sexo)) +
    geom_pill(width = 0.42, dodge = 0.78, radio = 2.4) +
    geom_text(aes(label = paste0("   ", fmt_pct(pct))), position = position_dodge(0.78), hjust = 0,
              size = 2.8, fontface = "bold", show.legend = FALSE) +
    scale_fill_manual(values = escala_var(c("Hombre", "Mujer"))) +
    scale_colour_manual(values = escala_var(c("Hombre", "Mujer"))) +
    scale_x_continuous(limits = c(0, max(d$pct) * 1.22), expand = expansion(mult = c(0, 0))) +
    guides(colour = "none") +
    labs(title = titulo, x = NULL, y = NULL, caption = fuente) +
    theme_gem() + .grid_x()
}

# --- E) Por provincia (Badajoz/Cáceres) a través de colectivos ----------------
g_prov_colectivo <- function(archivo, indicador_sel, titulo, fuente) {
  d <- .leer(archivo) |> filter(indicador == indicador_sel) |>
    mutate(colectivo = factor(colectivo, levels = c("Población no involucrada", "Población involucrada")),
           provincia = factor(provincia, levels = c("Badajoz", "Cáceres")))
  ggplot(d, aes(pct, colectivo, fill = provincia, colour = provincia)) +
    geom_pill(width = 0.42, dodge = 0.78, radio = 2.4) +
    geom_text(aes(label = paste0("   ", fmt_pct(pct))), position = position_dodge(0.78), hjust = 0,
              size = 2.8, fontface = "bold", show.legend = FALSE) +
    scale_fill_manual(values = escala_var(c("Badajoz", "Cáceres"))) +
    scale_colour_manual(values = escala_var(c("Badajoz", "Cáceres"))) +
    scale_x_continuous(limits = c(0, max(d$pct) * 1.22), expand = expansion(mult = c(0, 0))) +
    guides(colour = "none") +
    labs(title = titulo, x = NULL, y = NULL, caption = fuente) +
    theme_gem() + .grid_x()
}

# --- F) NES: ítems de un bloque (escala 0-10), píldoras ordenadas, línea media -
g_nes_items <- function(archivo, bloque_sel, titulo, fuente) {
  d <- .leer(archivo) |> filter(bloque == bloque_sel) |>
    mutate(item = .wrap(item, 46), item = reorder(item, valor))
  media <- mean(d$valor)
  ggplot(d, aes(valor, item)) +
    geom_pill(fill = colores_gem$teal, colour = colores_gem$teal, width = 0.58, radio = 2.6) +
    geom_text(aes(label = paste0("   ", fmt_num(valor))), hjust = 0, size = 2.6,
              fontface = "bold", colour = colores_gem$azul) +
    geom_vline(xintercept = media, linetype = "dashed", colour = col_var["España"], linewidth = 0.5) +
    annotate("text", x = media, y = 0.55, label = paste0("media ", fmt_num(media)),
             colour = col_var["España"], size = 2.5, hjust = -0.08, fontface = "bold") +
    scale_x_continuous(limits = c(0, 10.6), expand = expansion(mult = c(0, 0.02))) +
    labs(title = titulo, x = NULL, y = NULL, caption = fuente) +
    theme_gem() +
    theme(panel.grid.major.y = element_blank())
}

# --- G) NES: evolución 2021-2025 de las 13 condiciones (small multiples) ------
g_nes_evolucion <- function(archivo, titulo, fuente) {
  d <- .leer(archivo)
  orden <- d |> filter(anio == max(anio)) |> arrange(desc(valor)) |> pull(condicion)
  d <- d |> mutate(condicion = factor(.wrap(condicion, 26), levels = .wrap(orden, 26)))
  ult <- d |> group_by(condicion) |> filter(anio == max(anio)) |> ungroup()
  ggplot(d, aes(anio, valor)) +
    geom_line(colour = colores_gem$teal, linewidth = 1) +
    geom_point(colour = "white", size = 2.4) +
    geom_point(colour = colores_gem$teal, size = 1.4) +
    geom_text(data = ult, aes(label = fmt_num(valor)), vjust = -0.7, size = 2.4,
              fontface = "bold", colour = colores_gem$azul) +
    facet_wrap(vars(condicion), ncol = 4) +
    scale_x_continuous(breaks = c(2021, 2023, 2025)) +
    scale_y_continuous(limits = c(0, 8)) +
    labs(title = titulo, x = NULL, y = "Escala 0-10", caption = fuente) +
    theme_gem(base_size = 9) +
    theme(strip.text = element_text(size = 7, colour = colores_gem$azul, face = "bold"),
          panel.grid.major.x = element_blank())
}
