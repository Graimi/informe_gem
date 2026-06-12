// Estilo visual del informe, inspirado en la maquetación del GEM España:
// titulares en azul marino con barra de acento, pies de figura sobrios y
// fuente de datos en gris. Los colores son los de R/theme_gem.R: si cambia
// la identidad, actualizar ambos ficheros.

#let azul-gem = rgb("#0E2A3A")
#let verde-gem = rgb("#A6CE39")
#let gris-gem = rgb("#8A9BA8")

// Títulos de capítulo: grandes, azul marino, con barra de acento verde debajo
#show heading.where(level: 1): it => block(below: 1.2em)[
  #set text(size: 22pt, weight: "bold", fill: azul-gem)
  #it
  #v(4pt)
  #rect(width: 30%, height: 3.5pt, fill: verde-gem)
]

// Secciones: azul marino
#show heading.where(level: 2): set text(fill: azul-gem, weight: "bold")
#show heading.where(level: 3): set text(fill: azul-gem)

// Pies de figura y tabla: pequeños, "Figura N." en negrita como en GEM España
#show figure.caption: set text(size: 8.5pt, fill: gris-gem)
