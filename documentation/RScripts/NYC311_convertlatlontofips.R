#reading the NY block groups shapefile

library(sf)
library(dplyr)
library(haven)
library(readr)
library(data.table)
NYC311g2pared <- read_dta('/Users/benetge/Downloads/57/NYC311datafiles/pared data stata compress/NYC311g2paredcompress.dta')
block_groups <- st_read("/Users/benetge/Downloads/57/cb_2018_36_bg_500k/cb_2018_36_bg_500k.shp", quiet = TRUE)
View(NYC311g2pared)

#original solution that calls an API, which works but is not scalable for our data set size

library(tigris)
system.time({
  census_block <- tigris::call_geolocator_latlon(lat = NYC311b2pared$latitude[1],
                                                 lon = NYC311b2pared$longitude[1])
})
(census_tract <- substr(census_block, start = 1, stop = 11))

#improved solution using st_intersects

latlong_sf <- NYC311g2pared %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = st_crs(block_groups))

system.time({
  intersected <- st_intersects(latlong_sf, block_groups)
})

latlong_final <- latlong_sf %>% 
  mutate(intersection = as.integer(intersected),
         fips = if_else(is.na(intersection), "",
                        block_groups$GEOID[intersection]))
head(latlong_final)
View(latlong_final) # it worked!!!!

block_groups %>% # plotting Manhattan block groups
  filter(startsWith(GEOID, "36061")) %>%
  select(geometry) %>%
  plot()
latlong_final %>% #testing a random Manhattan block group
  filter(fips == "360610090002") %>%
  select(geometry) %>%
  slice_sample(n = 10) %>%
  plot(add = TRUE, reset = FALSE, pch = 16, col = "red")

#saving as csv so that it may be exported and appended
write.csv(latlong_final,"/Users/benetge/Downloads/57/NYC311datafiles/pared block group data/paredbg_g.csv", row.names=FALSE)


#saving as csv try 2. avoid the geometry comma split & the row.names debacle. THIS WORKS!
write.csv2(latlong_final,"/Users/benetge/Downloads/57/NYC311datafiles/pared block group data/paredbg_b_test.csv", row.names=TRUE, quote=TRUE)




