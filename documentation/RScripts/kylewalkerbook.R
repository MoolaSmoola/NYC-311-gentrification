install.packages("tigris")
library(tigris)
options(tigris_use_cache = TRUE)
st <- states()
class(st)
st
plot(st$geometry)
nm_counties <- counties("NM")
plot(nm_counties$geometry)
la_tracts <- tracts("NM", "Los Alamos")
plot(la_tracts$geometry)
la_water <- area_water("NM", "Los Alamos")
plot(la_water$geometry)
dc_landmarks <- landmarks("DC", type = "point")
plot(dc_landmarks$geometry)
dc_block_groups <- block_groups("DC")
plot(dc_block_groups$geometry)
library(ggplot2)
ggplot(la_tracts) +
  geom_sf() +
  theme_void()
install.packages("patchwork")
library(patchwork)
mi_counties <- counties("MI")
mi_counties_cb <- counties("MI", cb = TRUE)
mi_tiger_gg <- ggplot(mi_counties) +
  geom_sf() +
  theme_void() +
  labs(title = "TIGER/Line")
mi_cb_gg <- ggplot(mi_counties_cb) +
  geom_sf() +
  theme_void() +
  labs(title = "Cartographic boundary")
mi_tiger_gg + mi_cb_gg
options(tigris_use_cache = TRUE)
library(glue)
library(tidyverse)
#comparing yearly differences in TIGER/line files
yearly_plots <- map(seq(1990, 2020, 10), ~{
  year_tracts <- tracts("NY", "New York", year = .x,
                        cb = TRUE)
  ggplot(year_tracts) +
    geom_sf() +
    theme_void() +
    labs(title = glue("{.x}: {nrow(year_tracts)} tracts"))
})

(yearly_plots[[1]] + yearly_plots[[2]]) /
  (yearly_plots[[3]] + yearly_plots[[4]])

us_bgs_2020 <- block_groups(cb = TRUE, year = 2020)
nrow(us_bgs_2020)


state_codes <- c(state.abb, "DC", "PR")
us_bgs_2018 <- map_dfr(
  state_codes,
  ~block_groups(
    state = .x,
    cb = TRUE,
    year = 2018
  ) )
nrow(us_bgs_2018)

#5.4 coordinate reference systems (pg, 109)

library(sf)
fl_counties <- counties("FL", cb = TRUE)
st_crs(fl_counties)
