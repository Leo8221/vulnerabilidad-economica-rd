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


#limpieza de la base de datos de poblacion

header <- slice(poblacion,1:2)
