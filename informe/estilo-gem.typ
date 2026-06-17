// Estilo visual del informe, inspirado en la maquetación del GEM España:
// titulares en azul marino con barra de acento, pies de figura sobrios y
// fuente de datos en gris. Los colores son los de R/theme_gem.R: si cambia
// la identidad, actualizar ambos ficheros.

#let azul-gem = rgb("#0E2A3A")
#let verde-gem = rgb("#3FA535")
#let teal-gem = rgb("#1F6E7E")
#let gris-gem = rgb("#8A9BA8")

// Títulos de capítulo: grandes, azul marino, con barra de acento verde debajo
#show heading.where(level: 1): it => block(below: 1.2em)[
  #set text(size: 22pt, weight: "bold", fill: azul-gem)
  #it
  #v(4pt)
  #rect(width: 30%, height: 3.5pt, fill: verde-gem)
]

// Secciones (H2): teal con marca verde a la izquierda
#show heading.where(level: 2): it => block(above: 1.2em, below: 0.6em)[
  #grid(columns: (5pt, 1fr), gutter: 8pt,
    rect(width: 5pt, height: 0.95em, radius: 2pt, fill: verde-gem),
    text(size: 14pt, weight: "bold", fill: teal-gem)[#it])
]

// Subsecciones (H3): verde GEM
#show heading.where(level: 3): set text(fill: verde-gem, weight: "bold", size: 11.5pt)

// Pies de figura y tabla: pequeños, "Figura N." en negrita como en GEM España
#show figure.caption: set text(size: 8.5pt, fill: gris-gem)

// Pie de página minimalista: filete verde, título a la izquierda y nº de
// página a la derecha. El encabezado se mantiene como esté definido aparte.
#set page(
  footer: context [
    // Filete doble: tramo verde corto de acento + hairline gris a lo ancho
    #box(width: 100%)[
      #place(left, line(length: 100%, stroke: 0.6pt + rgb("#D9DEE2")))
      #place(left, line(length: 26%, stroke: 1.6pt + verde-gem))
    ]
    #v(4pt)
    #set text(size: 8pt, fill: gris-gem)
    #grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      [Global Entrepreneurship Monitor · #text(fill: verde-gem, weight: "bold")[Extremadura 2025/26]],
      box(fill: verde-gem, inset: (x: 8pt, y: 3pt), radius: 5pt)[
        #text(fill: white, weight: "bold", size: 8pt)[#counter(page).display()]
      ],
    )
  ],
)
