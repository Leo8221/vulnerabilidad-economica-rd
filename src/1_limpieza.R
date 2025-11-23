library(tidyverse)
library(janitor)
library(readxl)
# Limpieza de la base de datos de pobreza
pobreza_monetaria <- read_xlsx("data/raw/tasa_pobreza.xlsx",col_names = FALSE,skip=4) |> 
  slice(1:11)
#como tiene un doble titulo lo extraemos para unirlo luego
header <- pobreza_monetaria |> slice(1:2)
#unimos y limpiamos los titulos
header_clean <- header |> 
  as_tibble() |> 
  mutate(row = row_number()) |> 
  pivot_longer(cols = -row,
               names_to = "col",
               values_to = "valor") |> 
  pivot_wider(names_from = row,
              values_from = valor,
              names_glue = "r{row}") |> 
  mutate(
    tipo_pobreza = if_else(r1 == "", NA_character_, r1),
    region = if_else(r2 == "", NA_character_, r2))|> 
  fill(tipo_pobreza, .direction = "down") |> 
  mutate(
    nombre = case_when(
      tipo_pobreza == "Año" ~ "anio",
      TRUE ~ str_c(tipo_pobreza, "_", region)
    ),
    nombre = make_clean_names(nombre))
# asignamos los titulos al dataframe
colnames(pobreza_monetaria) <- header_clean$nombre  
#eliminamos las dos primeras filas ya que tenemos los titulos
pobreza_monetaria_con_titulos <- pobreza_monetaria[3:nrow(pobreza_monetaria),]

#pasamos el dataframe a formato largo para trabajar mas facilmente
pobreza_monetaria_longer <- pobreza_monetaria_con_titulos |> 
  mutate(
    anio = as.integer(anio)
  ) |> 
  pivot_longer(cols = starts_with("pobreza"),
               names_to   = "variable",
               values_to = "porcentaje_de_pobreza") |> 
  mutate(
    porcentaje_de_pobreza = as.numeric(porcentaje_de_pobreza)
  ) |> 
  mutate(porcentaje_de_pobreza = porcentaje_de_pobreza/100)

write_csv(
  pobreza_monetaria_longer,
  "data/processed/pobresa_monetaria_2016_2024.csv"
)

#limpieza de la base de datos de poblacion
poblacion <- read_xlsx("data\\raw\\cuadro-estimaciones-proyecciones-población-total-por-año-según-región-provincia-2000-2030.xlsx",skip = 5,col_names = FALSE)

header <- slice(poblacion,1:2)

header_clean <- header |>
  as_tibble() |>
  mutate(row = row_number()) |>
  pivot_longer(
    cols      = -row,
    names_to  = "col",
    values_to = "valor"
  ) |>
  pivot_wider(
    names_from  = row,
    values_from = valor,
    names_glue  = "r{row}"
  ) |>
  mutate(
    r1 = na_if(r1, ""),
    r2 = na_if(r2, "")
  ) |>
  
  # 1) Construimos el año (anio)
  mutate(
    anio = case_when(
      # La cabecera de la primera columna
      str_detect(r1, "Región") ~ NA_character_,
      
      # Filas de "Total": toman el año de la siguiente fila (la de Hombre)
      r1 == "Total" ~ lead(r1),
      
      # Filas con año explícito: se quedan como están
      !is.na(r1) ~ r1,
      
      # Filas Mujer con r1 NA: toman el año de la fila anterior (la de Hombre)
      is.na(r1) & r2 == "Mujer" ~ lag(r1),
      
      TRUE ~ NA_character_
    )
  ) |>
  
  # 2) Construimos el sexo
  mutate(
    sexo = case_when(
      str_detect(r1, "Región") ~ "total", 
      r1 == "Total"            ~ "total",
      is.na(r2)                ~ "total",
      TRUE                     ~ str_to_lower(r2)
    )
  ) |>
  
  # 3) Nombre final de la columna
  mutate(
    nombre = case_when(
      str_detect(r1, "Región") ~ "region_provincia",
      TRUE ~ str_c("poblacion_", anio, "_", sexo)
    ),
    nombre = make_clean_names(nombre)
  )

colnames(poblacion) <- header_clean$nombre
poblacion_con_titulos <- poblacion[4:46,]

poblacion_longer <- poblacion_con_titulos |>
  clean_names() |>
  # Asegurarnos de que region_provincia se llama así
  rename(region_provincia = region_provincia) |>
  # Pivotear todas las columnas que empiezan por "poblacion_"
  pivot_longer(
    cols      = starts_with("poblacion_"),
    names_to  = "variable",
    values_to = "poblacion"
  ) |>
  mutate(
    poblacion = as.numeric(poblacion)
  )

poblacion_longer <- poblacion_longer |>
  separate(
    variable,
    into   = c("prefijo", "anio", "sexo"),
    sep    = "_",
    remove = TRUE
  ) |>
  mutate(
    anio = as.integer(anio),
    sexo = str_to_lower(sexo)
  )

poblacion_total_2016_2024 <- poblacion_longer |>
  filter(
    sexo == "total",
    anio >= 2016,
    anio <= 2024
  ) |>
  select(
    region_provincia,
    anio,
    poblacion
  )

poblacion_total_2016_2024 <- poblacion_total_2016_2024 |>
  mutate(
    region_provincia = str_squish(region_provincia)
  )

poblacion_regdes <- poblacion_total_2016_2024 |>
  filter(str_starts(region_provincia, "Región ")) |>
  rename(region_desarrollo = region_provincia)

#limpiamos los datos de pobreza
pobreza_limpia <- pobreza_monetaria_longer |>
  # 1) Identificamos tipo de pobreza
  mutate(
    tipo_pobreza = case_when(
      str_detect(variable, "pobreza_general") ~ "general",
      str_detect(variable, "pobreza_extrema") ~ "extrema",
      TRUE ~ NA_character_
    ),
    # 2) Quitamos el prefijo para quedarnos solo con el "slug" de la región
    region_slug = variable |>
      str_remove("^pobreza_general_") |>
      str_remove("^pobreza_extrema_")
  ) |>
  # 3) Mapeamos el slug a nombre bonito de región de desarrollo
  mutate(
    region_desarrollo = case_when(
      region_slug == "cibao_norte"              ~ "Región Cibao Norte",
      region_slug == "cibao_sur"                ~ "Región Cibao Sur",
      region_slug == "cibao_nordeste"           ~ "Región Cibao Nordeste",
      region_slug == "cibao_noroeste"           ~ "Región Cibao Noroeste",
      region_slug == "valdesia"                 ~ "Región Valdesia",
      region_slug == "enriquillo"               ~ "Región Enriquillo",
      region_slug == "el_valle"                 ~ "Región Del Valle",
      region_slug == "yuma"                     ~ "Región Yuma",
      region_slug == "higuamo"                  ~ "Región Higuamo",
      region_slug == "ozama_o_metropolitana"    ~ "Región Metropolitana",
      region_slug == "total"                    ~ "Total país",
      TRUE ~ NA_character_
    )
  ) |>
  # 4) Nos quedamos solo con pobreza general por región
  filter(
    tipo_pobreza == "general",
    region_desarrollo != "Total país"
  ) |>
  # 5) Seleccionamos columnas finales y renombramos
  transmute(
    anio,
    region_desarrollo,
    tasa_pobreza = porcentaje_de_pobreza   
  )

#ahora unimos ambas bases de datos
panel_regdes <- pobreza_limpia |>
  left_join(poblacion_regdes, by = c("region_desarrollo", "anio")) |> 
  mutate(poblacion_pobre = poblacion*tasa_pobreza)

readr::write_csv(panel_regdes, "data/processed/panel_regdesarrollo_2016_2024.csv")
