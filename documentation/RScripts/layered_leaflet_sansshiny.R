library(leaflet)
library(tigris)
library(sf)
library(tidycensus)
library(tidyverse)
library(htmltools)
library(magrittr)
library(here)
library(BAMMtools)
library(dplyr)
library(RColorBrewer)
library(classInt)
#### SET UP ####

# read in the complaint categories.
nyc_b_allcat <- read.csv(
  here("NYC311datafiles", "leaflet", "forlove.csv"),
  sep = ";") 
nyc_b_allcat <- nyc_b_allcat[,-1] # remove the first column, which contains row.names
View(nyc_b_allcat) # verify that this is true

#change "Data" containing FIPS code from numeric to character.
nyc_b_allcat <- nyc_b_allcat %>%
  mutate(Data = as.character(Data))
class(nyc_b_allcat$Data) # verify that this was done correctly

#create nyc bgs call from tidycensus. Join it with the complaint categories.
nyc_bgs <- block_groups(state = "NY",
                        county = c("New York",
                                   "Kings",
                                   "Bronx",
                                   "Richmond",
                                   "Queens"),
                        year = "2012")
nyc_b_bgs_joined <- nyc_bgs %>%
  left_join(nyc_b_allcat, by = c("GEOID" = "Data"))
View(nyc_b_bgs_joined)

# change NAD83 to WGS84
nyc_b_bgs_joined_wgs <- st_transform(nyc_b_bgs_joined, crs = "WGS84")

# derive Jenks breaks for all 5 categories (sans 2 right now)
# setting up RColorBrewer and classInt

jenks_0 <- classIntervals(nyc_b_bgs_joined_wgs$"X0", n = 5, style = "jenks")
jenks_1 <- classIntervals(nyc_b_bgs_joined_wgs$"X1", n = 5, style = "jenks")
jenks_3 <- classIntervals(nyc_b_bgs_joined_wgs$"X3", n = 5, style = "jenks")
jenks_4 <- classIntervals(nyc_b_bgs_joined_wgs$"X4", n = 5, style = "jenks")
jenks_5 <- classIntervals(nyc_b_bgs_joined_wgs$"X5", n = 5, style = "jenks")

cols_code_0 <- findColours(jenks_0, brewer.pal(5,"YlOrRd"))
cols_code_1 <- findColours(jenks_1, brewer.pal(5,"YlOrRd"))
cols_code_3 <- findColours(jenks_3, brewer.pal(5,"YlOrRd"))
cols_code_4 <- findColours(jenks_4, brewer.pal(5,"YlOrRd"))
cols_code_5 <- findColours(jenks_5, brewer.pal(5,"YlOrRd"))



# creating palette bins for all 5 categories
pal_bins0 <- colorBin("YlOrRd", domain = jenks_0$brks, bins = jenks_0$brks, pretty = FALSE)
pal_bins1 <- colorBin("YlOrRd", domain = jenks_1$brks, bins = jenks_1$brks, pretty = FALSE)
pal_bins3 <- colorBin("YlOrRd", domain = jenks_3$brks, bins = jenks_3$brks, pretty = FALSE)
pal_bins4 <- colorBin("YlOrRd", domain = jenks_4$brks, bins = jenks_4$brks, pretty = FALSE)
pal_bins5 <- colorBin("YlOrRd", domain = jenks_5$brks, bins = jenks_5$brks, pretty = FALSE)

#creating separate layers for all 5 categories
labels0 <- sprintf(
  "<strong>%s</strong><br/>%g calls",
  nyc_b_bgs_joined_wgs$GEOID, nyc_b_bgs_joined_wgs$"X0"
) %>% lapply(htmltools::HTML)
labels1 <- sprintf(
  "<strong>%s</strong><br/>%g calls",
  nyc_b_bgs_joined_wgs$GEOID, nyc_b_bgs_joined_wgs$"X1"
) %>% lapply(htmltools::HTML)
labels3 <- sprintf(
  "<strong>%s</strong><br/>%g calls",
  nyc_b_bgs_joined_wgs$GEOID, nyc_b_bgs_joined_wgs$"X3"
) %>% lapply(htmltools::HTML)
labels4 <- sprintf(
  "<strong>%s</strong><br/>%g calls",
  nyc_b_bgs_joined_wgs$GEOID, nyc_b_bgs_joined_wgs$"X4"
) %>% lapply(htmltools::HTML)
labels5 <- sprintf(
  "<strong>%s</strong><br/>%g calls",
  nyc_b_bgs_joined_wgs$GEOID, nyc_b_bgs_joined_wgs$"X5"
) %>% lapply(htmltools::HTML)


    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite) %>%
      addPolygons(data = nyc_b_bgs_joined_wgs,
                  fillColor = cols_code_0,
                  group = 'Residential-Noise',
                  color = 'black',
                  stroke = TRUE,
                  weight = 0.3, smoothFactor = 0, fillOpacity = 0.9,
                  highlightOptions = highlightOptions(
                    weight = 3,
                    color = '#F8C',
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = labels0,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
       addLegend(
        "topright",
        pal = pal_bins0,
        values = nyc_b_bgs_joined_wgs$"X0",
        group = 'Residential-Noise') %>%
      addPolygons(data = nyc_b_bgs_joined_wgs,
                  fillColor = cols_code_1,
                  group = 'Noise-people',
                  color = 'black',
                  stroke = TRUE,
                  weight = 0.3, smoothFactor = 0, fillOpacity = 0.9,
                  highlightOptions = highlightOptions(
                    weight = 3,
                    color = '#F8C',
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = labels1,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
      addLegend(
        "topright",
        pal = pal_bins1,
        values = nyc_b_bgs_joined_wgs$"X1",
        group = 'Noise-people') %>%
      addPolygons(data = nyc_b_bgs_joined_wgs,
                  fillColor = cols_code_3,
                  group = 'Parking',
                  color = 'black',
                  stroke = TRUE,
                  weight = 0.3, smoothFactor = 0, fillOpacity = 0.9,
                  highlightOptions = highlightOptions(
                    weight = 3,
                    color = '#F8C',
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = labels3,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>% 
      addLegend(
        "topright",
        pal = pal_bins3,
        values = nyc_b_bgs_joined_wgs$"X3",
        group = 'Parking') %>%
      addPolygons(data = nyc_b_bgs_joined_wgs,
                  fillColor = cols_code_4,
                  group = 'Junk-debris',
                  color = 'black',
                  stroke = TRUE,
                  weight = 0.3, smoothFactor = 0, fillOpacity = 0.9,
                  highlightOptions = highlightOptions(
                    weight = 3,
                    color = '#F8C',
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = labels4,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
      addLegend(
        "topright",
        pal = pal_bins4,
        values = nyc_b_bgs_joined_wgs$"X4",
        group = 'Junk-debris') %>%
      addPolygons(data = nyc_b_bgs_joined_wgs,
                  fillColor = cols_code_5,
                  group = 'Other',
                  color = 'black',
                  stroke = TRUE,
                  weight = 0.3, smoothFactor = 0, fillOpacity = 0.9,
                  highlightOptions = highlightOptions(
                    weight = 3,
                    color = '#F8C',
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = labels5,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
      addLegend(
        "topright",
        pal = pal_bins5,
        values = nyc_b_bgs_joined_wgs$"X5",
        group = 'Other') %>% 
      addLayersControl(
        position = "bottomright",
        baseGroups = c('Residential-Noise', 'Noise-people', 'Parking', 'Junk-debris', 'Other'),
        options = layersControlOptions(collapsed = TRUE)) 




