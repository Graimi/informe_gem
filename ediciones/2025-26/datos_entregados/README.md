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

| CSV                 | Columnas                       | Usado en capítulo            |
|---------------------|--------------------------------|------------------------------|
| `serie_tea.csv`     | `anio`, `ambito`, `tea`        | 01 Actividad emprendedora    |
| `perfil_edad.csv`   | `grupo_edad`, `ambito`, `pct`  | 02 Perfil del emprendedor    |
| `nes_condiciones.csv` | `condicion`, `ambito`, `puntuacion` | 03 Contexto            |

Amplía esta tabla a medida que se añadan indicadores a los capítulos: es el
contrato entre los datos y el informe.
