library(tidyverse)
library(rio)

datos_ninos <- import("datos_ninos.xlsx", sheet = "resultados")
censo_oficial <- import("datos_ninos.xlsx", which = "censo-oficial")

datos_limpios <- datos_ninos %>%
  filter(
    !is.na(hemoglobina) & hemoglobina >= 9 & hemoglobina <= 17,
    !is.na(talla) & talla >= 1.10 & talla <= 1.50,
    !is.na(peso) & peso >= 28 & peso <= 55 , 
    !is.na(parasitos)
  )
datos_limpios

datos_limpios_completos <- datos_limpios %>%
  drop_na()
datos_limpios_completos

export(datos_limpios, "datos_ninos_limpios.xlsx")


censo_2 <- censo_oficial

censo_2 <- censo_2 %>%
  mutate(edad_actual = as.integer(difftime(Sys.Date(), as.Date(date_birth), units = "days") / 365.25))

censo_2

export(censo_2, "censo_2.xlsx")


tabla_principal <- left_join(datos_limpios, censo_2, by = "dni")

tabla_principal <- tabla_principal %>%
  filter(
    !is.na(hemoglobina),
    !is.na(talla),
    !is.na(peso),
    !is.na(date_birth)
  )

tabla_principal

export(tabla_principal, "tabla_principal.xlsx")

