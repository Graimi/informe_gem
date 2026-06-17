# Renderiza todos los gráficos del Capítulo 1 a PNG (verificación visual).
raiz <- rprojroot::find_root(rprojroot::has_file(".gem_root"))
source(file.path(raiz, "R", "utilidades.R"))
source(file.path(raiz, "R", "theme_gem.R"))
source(file.path(raiz, "R", "graficos_cap1.R"))

out <- file.path(raiz, "ediciones", "2025-26", "prototipos", "cap1")
dir.create(out, showWarnings = FALSE, recursive = TRUE)
sv <- function(f, p, w = 9, h = 6) ggplot2::ggsave(file.path(out, f), p, width = w, height = h, dpi = 200, bg = "white")

fa <- "Fuente: GEM Extremadura, APS 2025."
fg <- "Fuente: GEM Global / GEM Extremadura, APS 2025."
fn <- "Fuente: GEM Extremadura, NES 2025. Escala 0-10; línea punteada = umbral 5."

ext_esp_ue <- c("Extremadura", "España", "Unión Europea")
ext_cac_bad <- c("Extremadura", "Cáceres", "Badajoz")
ext_bad_cac <- c("Extremadura", "Badajoz", "Cáceres")

sv("G1-01.png", g_barras_anio("percepciones_anio.csv",
   "Gráfico 1.1. Percepción de la población para emprender en Extremadura (2024-2025)", fa), 10, 6)
sv("G1-02.png", g_barras_ambito("percepciones_benchmark.csv", ext_esp_ue,
   "Gráfico 1.2. Percepción del contexto emprendedor: Extremadura, España y Europa", fg), 10, 6.2)
sv("G1-03.png", g_barras_ambito("percepciones_provincias.csv", ext_cac_bad,
   "Gráfico 1.3. Percepción del contexto emprendedor por provincias", fa), 10, 6.2)
sv("G1-04.png", g_serie_colectivo("percepciones_series.csv", "Modelos de referencia",
   "Gráfico 1.4. Evolución de la percepción de modelos de referencia (2015-2025)", fa), 10, 5.4)
sv("G1-05.png", g_genero("percepciones_genero.csv", "Modelos de referencia",
   "Gráfico 1.5. Modelos de referencia por género", fa), 9, 4.6)
sv("G1-06.png", g_prov_colectivo("percepciones_prov_colectivo.csv", "Modelos de referencia",
   "Gráfico 1.6. Modelos de referencia por provincias", fa), 9, 4.2)
sv("G1-07.png", g_serie_colectivo("percepciones_series.csv", "Oportunidades",
   "Gráfico 1.7. Evolución de la percepción de oportunidades (2015-2025)", fa), 10, 5.4)
sv("G1-08.png", g_genero("percepciones_genero.csv", "Oportunidades",
   "Gráfico 1.8. Percepción de oportunidades por género", fa), 9, 4.6)
sv("G1-09.png", g_prov_colectivo("percepciones_prov_colectivo.csv", "Oportunidades",
   "Gráfico 1.9. Percepción de oportunidades por provincias", fa), 9, 4.2)
sv("G1-10.png", g_serie_colectivo("percepciones_series.csv", "Habilidades",
   "Gráfico 1.10. Evolución de la percepción de habilidades (2015-2025)", fa), 10, 5.4)
sv("G1-11.png", g_genero("percepciones_genero.csv", "Habilidades",
   "Gráfico 1.11. Percepción de habilidades por género", fa), 9, 4.6)
sv("G1-12.png", g_prov_colectivo("percepciones_prov_colectivo.csv", "Habilidades",
   "Gráfico 1.12. Percepción de habilidades por provincias", fa), 9, 4.2)
sv("G1-13.png", g_serie_colectivo("percepciones_series.csv", "Miedo al fracaso",
   "Gráfico 1.13. Evolución de la percepción del miedo al fracaso (2015-2025)", fa), 10, 5.4)
sv("G1-14.png", g_genero("percepciones_genero.csv", "Miedo al fracaso",
   "Gráfico 1.14. Percepción del miedo al fracaso por género", fa), 9, 4.6)
sv("G1-15.png", g_prov_colectivo("percepciones_prov_colectivo.csv", "Miedo al fracaso",
   "Gráfico 1.15. Percepción del miedo al fracaso por provincias", fa), 9, 4.2)
sv("G1-16.png", g_barras_ambito("nes_benchmark.csv", ext_esp_ue,
   "Gráfico 1.16. Condiciones del entorno: Extremadura, España y UE", fn,
   col = "nes", campo_cat = "condicion"), 10, 6.8)
sv("G1-17.png", g_nes_evolucion("nes_evolucion.csv",
   "Gráfico 1.17. Evolución de las condiciones del entorno (2021-2025)", fn), 11, 7)
sv("G1-18.png", g_barras_ambito("nes_provincias.csv", ext_bad_cac,
   "Gráfico 1.18. Condiciones del entorno por provincias", fn,
   col = "nes", campo_cat = "condicion"), 10, 6.8)
sv("G1-19.png", g_nes_items("nes_items.csv", "Mujeres",
   "Gráfico 1.19. Condiciones del entorno para mujeres emprendedoras", fn), 9.5, 4.6)
sv("G1-20.png", g_nes_items("nes_items.csv", "Sostenibilidad",
   "Gráfico 1.20. Condiciones del entorno en sostenibilidad", fn), 9.5, 6.2)
sv("G1-21.png", g_nes_items("nes_items.csv", "Financiación",
   "Gráfico 1.21. Condiciones del entorno: financiación", fn), 9.5, 6)
sv("G1-22.png", g_nes_items("nes_items.csv", "Políticas gubernamentales",
   "Gráfico 1.22. Condiciones del entorno: políticas gubernamentales", fn), 9.5, 4.6)
sv("G1-23.png", g_nes_items("nes_items.csv", "Programas de apoyo",
   "Gráfico 1.23. Condiciones del entorno: programas de apoyo", fn), 9.5, 4.2)
sv("G1-24.png", g_nes_items("nes_items.csv", "Educación",
   "Gráfico 1.24. Condiciones del entorno: educación", fn), 9.5, 4)
sv("G1-25.png", g_nes_items("nes_items.csv", "Transferencia de I+D",
   "Gráfico 1.25. Condiciones del entorno: transferencia de I+D", fn), 9.5, 4)
sv("G1-26.png", g_nes_items("nes_items.csv", "Normas sociales y culturales",
   "Gráfico 1.26. Condiciones del entorno: normas sociales y culturales", fn), 9.5, 3.8)
sv("G1-27.png", g_nes_items("nes_items.csv", "Infraestructura",
   "Gráfico 1.27. Condiciones del entorno: infraestructuras", fn), 9.5, 4.2)

cat("OK cap1 ->", out, "\n")
