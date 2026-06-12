# Datos entregados — edición 2025/26

Guarda aquí los ficheros **tal y como nos los entregan** (Excel, Word, PDF…),
sin modificarlos. Son el original de referencia ante cualquier duda.

El informe no lee de esta carpeta: cada tabla o serie se vuelca a un CSV en
`../procesados/` con estas convenciones.

## Convenciones de los CSV en `procesados/`

- Nombre en minúsculas con guiones bajos: `serie_tea.csv`, `perfil_edad.csv`…
- Formato *tidy*: una fila por observación, una columna por variable.
- Decimales con punto, sin separador de miles, porcentajes como número (5.2, no "5,2 %").
- Columnas habituales: `anio`, `ambito` (Extremadura / España), categoría e indicador.

## Indicadores que esperan los capítulos

| CSV                       | Columnas                                  | Usado en                                |
|---------------------------|-------------------------------------------|-----------------------------------------|
| `cuadro_indicadores.csv`  | `bloque`, `indicador`, `anio`, `valor`    | Cuadro sintético de indicadores         |
| `percepciones.csv`        | `indicador`, `colectivo`, `anio`, `pct`   | Cap. 1 Valores y percepciones           |
| `serie_tea.csv`           | `anio`, `ambito`, `tea`                   | Cap. 2 Actividad emprendedora           |
| `proceso_emprendedor.csv` | `fase`, `anio`, `pct`                     | Cap. 2 Proceso emprendedor              |
| `perfil_emprendedor.csv`  | `caracteristica`, `categoria`, `fase`, `pct` | Cap. 2 Perfil                        |
| `nes_condiciones.csv`     | `condicion`, `ambito`, `puntuacion`       | Cap. 4 Entorno emprendedor              |

Hay CSV de plantilla en `../procesados/` con valores `0.0`: son marcadores de
posición para que el informe renderice; sustituir por los datos reales.

Amplía esta tabla a medida que se añadan indicadores a los capítulos: es el
contrato entre los datos y el informe.
