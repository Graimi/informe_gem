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
│       ├── prototipos/         # PNGs de validación de estilo (scripts/99_*)
│       └── recursos/           # portada, logos de la edición
├── R/                          # funciones reutilizables (tema gráfico, lectura de datos)
│   ├── theme_gem.R             # tema ggplot2 + helper geom_pill (barras con esquinas redondeadas)
│   └── graficos_cap1.R         # funciones de cada gráfico del capítulo 1
├── scripts/                    # procesamiento de microdatos y utilidades
│   ├── 01_procesar_microdatos.R   # modo B: calcula indicadores desde APS/NES
│   └── 99_prototipos_graficos.R   # genera PNGs de validación de estilo en prototipos/
├── informe/                    # fuentes Quarto del informe
│   ├── informe.qmd             # documento maestro: ensambla los capítulos
│   ├── _index.qmd              # presentación / portadilla
│   ├── _resumen-ejecutivo.qmd  # resumen ES/EN
│   ├── _introduccion.qmd       # introducción y metodología
│   ├── _cuadro-indicadores.qmd # cuadro sintético de indicadores
│   ├── _01-contexto-emprendedor.qmd   # cap 1 — COMPLETO (27 gráficos)
│   ├── _02-proceso-emprendedor.qmd    # cap 2 — stub
│   ├── _03-perfil-emprendedor.qmd     # cap 3 — stub
│   ├── _04-digitalizacion.qmd         # cap 4 — stub
│   ├── _05-sostenibilidad-ods.qmd     # cap 5 — stub
│   ├── _90-bibliografia.qmd    # bibliografía APA
│   ├── _91-anexos.qmd          # anexos
│   ├── _variables.yml          # configuración de la edición (única fuente de verdad)
│   ├── _quarto.yml             # formatos de salida (HTML + PDF Typst)
│   └── estilo-gem.typ          # estilo de maquetación PDF
├── setup.ps1                   # instala paquetes R en Windows (ver abajo)
└── .gem_root                   # marcador de la raíz del proyecto (lo usa R/utilidades.R)
```

Para reordenar, añadir o quitar capítulos se edita la lista de `{{< include >}}`
de `informe/informe.qmd`.

Los capítulos siguen la estructura del informe GEM Extremadura (presentación,
resumen ejecutivo ES/EN, introducción y metodología, cuadro sintético de
indicadores, 1 contexto emprendedor, 2 proceso emprendedor, 3 perfil emprendedor,
4 digitalización, 5 sostenibilidad y ODS, bibliografía y anexos), con la calidad
de maquetación del informe GEM España como referencia.

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

Requisitos: [Quarto](https://quarto.org) ≥ 1.4 (trae Typst incorporado, no hace
falta LaTeX), la fuente Liberation Sans (`fonts-liberation` en Debian/Ubuntu) y
R ≥ 4.3 con los paquetes `ggplot2`, `dplyr`, `tidyr`, `readr`, `gt`, `scales`,
`yaml`, `rprojroot` (y `haven`, `srvyr` para el modo B).

```sh
cd informe
quarto render            # genera _book/informe.html y _book/informe.pdf
```

El render está validado: produce el HTML y el PDF maquetado (estilo GEM España)
a partir de los CSV de `procesados/`.

> En contenedores con el *locale* en C puede hacer falta `export LANG=C.UTF-8`
> antes de renderizar para que los acentos se lean bien (el código ya fuerza
> lectura UTF-8 del YAML, pero conviene para el resto del pipeline).

**Integración continua:** `.github/workflows/render.yml` renderiza el informe en
cada push y PR y publica `informe/_book/` como artefacto descargable.

Primera vez en una máquina nueva: `Rscript -e 'renv::restore()'` si existe
`renv.lock`. Para crearlo/actualizarlo tras instalar paquetes:
`Rscript -e 'renv::snapshot()'`. Congelar versiones garantiza poder regenerar
cualquier edición pasada.

### Windows

Quarto no está en PATH por defecto; usar la ruta completa:

```powershell
& "$env:LOCALAPPDATA\Programs\Quarto\bin\quarto.exe" render informe.qmd
```

Para instalar todos los paquetes R de una vez:

```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1
```

La fuente Liberation Sans no está disponible en Windows; Typst usa un fallback
serif en el cuerpo del PDF local (no afecta a CI, que corre en Linux con
`fonts-liberation`). Para preview local fiel, instalar Liberation Sans o
cambiar `mainfont` en `_quarto.yml` a `Arial` temporalmente.

## Convenciones de gráficos

- El título `"Gráfico N.M. …"` va **dentro del plot** (estilo GEM España); los
  chunks **no** llevan `#| fig-cap:` ni `#| label:` para evitar el doble rótulo
  "Figura N:" que añadiría Quarto.
- Barras con esquinas redondeadas via `geom_pill()` definida en `R/theme_gem.R`
  (borde mismo color + `linejoin = "round"`). **No** usar `ggrounded` ni
  `device = ragg` — ambas opciones causan segfault en Windows.
- Líneas con halo blanco (`geom_line` con `colour = "white"` y mayor grosor
  debajo de la línea principal).
- Cada variable tiene un color fijo asignado; ver `R/theme_gem.R` y la memoria
  de colores del proyecto.
- Para validar el estilo sin renderizar el informe completo:
  ```r
  Rscript scripts/99_prototipos_graficos.R
  # → PNGs en ediciones/2025-26/prototipos/
  ```
