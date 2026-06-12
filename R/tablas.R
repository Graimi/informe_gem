# Tablas gt con el estilo del informe GEM España.

library(gt)

# Cuadro sintético de indicadores: bloques con banda de color, una fila por
# indicador y columnas por año, con el año actual destacado en oscuro
# (réplica del "Cuadro de indicadores" del GEM España).
#
# Espera un data frame tidy: bloque | indicador | anio | valor
tabla_indicadores <- function(datos, anio_actual = max(datos$anio)) {
  datos |>
    tidyr::pivot_wider(names_from = anio, values_from = valor) |>
    gt(groupname_col = "bloque") |>
    cols_label(indicador = "") |>
    fmt_number(columns = where(is.numeric), decimals = 1, dec_mark = ",") |>
    tab_style(
      style = list(
        cell_fill(color = colores_gem$teal),
        cell_text(color = "white", weight = "bold", size = "small")
      ),
      locations = cells_row_groups()
    ) |>
    tab_style(
      style = list(
        cell_fill(color = colores_gem$azul),
        cell_text(color = "white", weight = "bold")
      ),
      locations = list(
        cells_column_labels(columns = tidyselect::all_of(as.character(anio_actual))),
        cells_body(columns = tidyselect::all_of(as.character(anio_actual)))
      )
    ) |>
    tab_options(
      table.font.size = "small",
      data_row.padding = gt::px(3),
      table.width = gt::pct(100)
    )
}
