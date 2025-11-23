library(tidyverse)
library(plotly)
panel <- read_csv("data/processed/panel_regdesarrollo_2016_2024.csv")

# Creamos z-score e índice
panel_z <- panel |> 
  mutate(
    z_pobreza   = as.numeric(scale(tasa_pobreza)),
    z_pob_pobre = as.numeric(scale(poblacion_pobre)),
    iv          = (z_pobreza + z_pob_pobre) / 2
  )

# Llevamos el índice a valores 0-100
panel_z <- panel_z |> 
  mutate(
    iv_rescale = scales::rescale(iv, to = c(0, 100))
  )

# Creamos un ranking por año
panel_z <- panel_z |> 
  group_by(anio) |> 
  mutate(rank_iv = dense_rank(desc(iv))) |> 
  ungroup()

# Reordenamos las regiones por vulnerabilidad promedio
panel_z <- panel_z |>
  group_by(region_desarrollo) |>
  mutate(iv_media = mean(iv_rescale, na.rm = TRUE)) |>
  ungroup() |>
  mutate(
    region_desarrollo = fct_reorder(region_desarrollo, iv_media)
  )


# Gráfico 1: Evolución de la tasa de pobreza por región (facet)
#--------------------------------------------------
p_pobreza <- panel_z |> 
  ggplot(aes(x = anio, y = tasa_pobreza * 100, group = region_desarrollo)) +
  geom_line() +
  facet_wrap(~ region_desarrollo) +
  labs(
    title = "Evolución de la Tasa de Pobreza por Región de Desarrollo",
    x = "Año",
    y = "Tasa de Pobreza (%)"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    strip.text = element_text(size = 9)
  )

# Exportamos el gráfico 1
ggsave(
  filename = "output/figuras/evolucion_tasa_pobreza_por_region.png",
  plot     = p_pobreza,
  width    = 10,
  height   = 6,
  dpi      = 300
)


#--------------------------------------------------
# Gráfico 2: Índice de vulnerabilidad por región (líneas)
#--------------------------------------------------
p_iv <- panel_z |> 
  ggplot(aes(x = anio, y = iv_rescale, color = region_desarrollo)) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.5) +
  labs(
    title = "Índice de Vulnerabilidad Económica por Región de Desarrollo",
    x = "Año",
    y = "Índice de Vulnerabilidad (0-100)",
    color = "Región"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.title = element_text(size = 11)
  )

# Versión interactiva
ggplotly(p_iv)

# Exportamos el gráfico 2
ggsave(
  filename = "output/figuras/indice_vulnerabilidad_por_region.png",
  plot     = p_iv,
  width    = 10,
  height   = 6,
  dpi      = 300
)

#--------------------------------------------------
# Gráfico 3: Dispersión tasa de pobreza vs población pobre (año 2024)
#--------------------------------------------------
p_disp <- panel_z |> 
  filter(anio == 2024) |> 
  ggplot(aes(x = poblacion_pobre, y = tasa_pobreza * 100, color = region_desarrollo)) +
  geom_point(size = 3, alpha = 0.8) +
  labs(
    title = "Vulnerabilidad Económica por Región de Desarrollo - 2024",
    x = "Población en Pobreza",
    y = "Tasa de Pobreza (%)",
    color = "Región",
    caption = "Fuente: MEPyD y ONE"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title  = element_text(face = "bold", size = 13),
    axis.title  = element_text(size = 11)
  )

# Exportamos el gráfico 3
ggsave(
  filename = "output/figuras/dispersion_vulnerabilidad_2024.png",
  plot     = p_disp,
  width    = 8,
  height   = 5,
  dpi      = 300
)