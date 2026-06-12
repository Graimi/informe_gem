# Informe GEM Extremadura

Proyecto reproducible para elaborar el informe anual GEM (Global Entrepreneurship
Monitor) de Extremadura. Construido con **Quarto + R**, pensado para que cada
edición solo requiera datos nuevos y revisión del texto interpretativo.

## Estructura

```
informe_gem/
├── ediciones/
│   └── 2025-26/
│       ├── datos_entregados/   # ficheros tal y como nos los entregan (no se tocan)
│       ├── microdatos/         # APS/NES originales (.sav/.dta) — NO se suben a git
│       ├── procesados/         # CSVs tidy de los que lee el informe
│       └── recursos/           # portada, logos de la edición
├── R/                          # funciones reutilizables (tema gráfico, lectura de datos)
├── scripts/                    # procesamiento de microdatos (solo modo B)
└── informe/                    # capítulos Quarto (.qmd) y configuración del libro
```

Los capítulos siguen la estructura del informe GEM Extremadura (presentación,
resumen ejecutivo ES/EN, introducción y metodología, cuadro sintético de
indicadores, 1 valores y percepciones, 2 actividad emprendedora, 3 aspiraciones,
4 entorno, 5 conclusiones, bibliografía y anexos), con la calidad de
maquetación del informe GEM España como referencia.

**Estilo visual:** los colores y convenciones gráficas viven en dos ficheros
espejo — `R/theme_gem.R` (gráficos y tablas) e `informe/estilo-gem.typ`
(maquetación PDF). Si cambia la identidad corporativa, solo se tocan esos dos.

**Principio rector:** el informe (los `.qmd`) lee *únicamente* de
`ediciones/<edicion>/procesados/`. Todo lo que depende del año vive en datos y
en `informe/_variables.yml`; todo lo que no, vive en funciones y plantillas.

## Los dos modos de trabajo

### Modo A — nos entregan texto y datos (edición 2025/26)

1. Guarda los ficheros originales (Excel, Word, PDF…) en
   `ediciones/<edicion>/datos_entregados/` sin modificarlos.
2. Vuelca cada tabla/serie a un CSV en `ediciones/<edicion>/procesados/`
   siguiendo la convención de nombres y columnas descrita en
   `ediciones/2025-26/datos_entregados/README.md`.
3. Pega/adapta el texto entregado en los capítulos de `informe/`.

### Modo B — tenemos los microdatos y calculamos nosotros

1. Deposita los microdatos APS/NES en `ediciones/<edicion>/microdatos/`
   (la carpeta está en `.gitignore`; los microdatos GEM son confidenciales).
2. Ejecuta `Rscript scripts/01_procesar_microdatos.R`, que calcula los
   indicadores (TEA, etc.) con los pesos muestrales y escribe los mismos CSVs
   en `procesados/` que en el modo A.
3. A partir de ahí el flujo es idéntico: los capítulos no distinguen de dónde
   salieron los CSVs.

## Cómo preparar una nueva edición

1. `cp -r ediciones/2025-26 ediciones/2026-27` y vacía `procesados/`,
   `datos_entregados/` y `microdatos/` (conserva los README).
2. Actualiza `informe/_variables.yml` (edición, año de campo, monográfico, portada).
3. Añade los datos por el modo A o B.
4. Renderiza y revisa.

## Renderizar

Requisitos: [Quarto](https://quarto.org) ≥ 1.4 y R ≥ 4.3 con los paquetes
`tidyverse`, `gt`, `yaml`, `here` (y `haven`, `srvyr` para el modo B).

```sh
cd informe
quarto render            # genera PDF (Typst) y HTML en informe/_book/
```

Primera vez en una máquina nueva: `Rscript -e 'renv::restore()'` si existe
`renv.lock`. Para crearlo/actualizarlo tras instalar paquetes:
`Rscript -e 'renv::snapshot()'`. Congelar versiones garantiza poder regenerar
cualquier edición pasada.
