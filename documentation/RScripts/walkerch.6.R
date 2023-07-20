#Generating a heat map of different categories of complaints. Let's do complaintcategories 0-5, social conflict 1&2

#Following along first with ch. 6 of Walker:

library(tidycensus)
options(tigris_use_cache = TRUE)

ny_complaints <- get_acs(
  geography = "cbg",
  variables = "B19013_001",
  state = "NY",
  county = "New York"
  year = 2016,
  geometry = TRUE
)

#and now we have our compatible complaint list: "forlove3". We will merge on the same block group code.
df_merge <- merge(ny_complaints, forlove3, by ="GEOID")
View(df_merge)
plot(df_merge["sum"])

interestingmerge <- merge()

colnames(forlove3)[1] = "GEOID"
colnames(forloveallcategories)[1] = "GEOID"

View(forlove3)

allcategories_merge <- merge(ny_complaints, forloveallcategories, by="GEOID")
View(allcategories_merge)

View(forloveallcategories)
View(ny_complaints)

variablesearch <- load_variables(2020, "acs5")
View(variablesearch)

plot(allcategories_merge["0"])
plot(allcategories_merge["1"])
plot(allcategories_merge["3"])
plot(allcategories_merge["4"])
plot(allcategories_merge["5"])
plot(allcategories_merge["estimate"])

# Okay picking up from there let's do more of the Kyle Walker chapter. Just to ease myself back into it

# Map making in ggplot.

library(tidyverse)
library(tigris)

us_median_age <- get_acs(
  geography = "state",
  variables = "B01002_001",
  year = 2019,
  survey = "acs1",
  geometry = TRUE,
  resolution = "20m"
) %>%
  shift_geometry()
plot(us_median_age$geometry)

ggplot(data = us_median_age, aes(fill = estimate)) +
  geom_sf()

#now graph it with a lot of specifications.

ggplot(data = us_median_age, aes(fill = estimate)) + # basic ggplot and labeling the color scale
  geom_sf() +
  scale_fill_distiller(palette = "RdPu", # color
                       direction = 1) + # darker being older, rather than the original graph
  labs(title = "  Median Age by State, 2019",
       caption = "Data source: 2019 1-year ACS, US Census Bureau",
       fill = "ACS estimate") +
  theme_void() # get rid of CRS in the background of the original


# Map making in tmap package

hennepin_race <- get_decennial(
  geography = "tract",
  state = "MN",
  county = "Hennepin",
  variables = c(
    Hispanic = "P2_002N",
    White = "P2_005N",
    Black = "P2_006N",
    Native = "P2_007N",
    Asian = "P2_008N"
  ),
  summary_var = "P2_001N",
  year = 2020,
  geometry = TRUE
) %>%
  mutate(percent = 100 * (value / summary_value))

install.packages("tmap")
library(tmap)

hennepin_black <- filter(hennepin_race,
                         variable == "Black")
tm_shape(hennepin_black) +
  tm_polygons()
tm_shape(hennepin_black) +
  tm_polygons(col = "percent")

View(hennepin_black)
hist(hennepin_black$percent) # we see that the default classing, "pretty," automatically came up with classes that hide the variation in one of them

tm_shape(hennepin_black) + # so we are now classing by "quantile"
  tm_polygons(col = "percent",
              style = "jenks",
              n = 5,
              palette = "Purples",
              title = "2020 US Census",
              legend.hist = TRUE) +
  tm_layout(title = "Percent Black\nby Census tract",
            frame = FALSE,
            legend.outside = TRUE,
            bg.color = "grey70",
            legend.hist.width = 5,
            fontfamily = "Verdana")

View(hennepin_race)

#adding reference elements to the map using mapboxapi

install.packages("mapboxapi")
library(mapboxapi)

mb_access_token("pk.eyJ1IjoibW9vbGFzbW9vbGEiLCJhIjoiY2xrN2N3eW56MDZrYjNycXowdDB4a2ozaSJ9.CYBmPNKrSTRh7ecthrCphw", install = TRUE)
readRenviron("~/.Renviron")

hennepin_tiles <- get_static_tiles(
  location = hennepin_black,
  zoom = 10,
  style_id = "light-v9",
  username = "mapbox"
)


tm_shape(hennepin_tiles) +
  tm_rgb() +
  tm_shape(hennepin_black) +
  tm_polygons(col = "percent",
              style = "jenks",
              n = 5,
              palette = "Purples",
              title = "2020 US Census",
              alpha = 0.7) +
  tm_layout(title = "Percent Black\nby Census tract",
            legend.outside = TRUE,
            fontfamily = "Verdana") +
  tm_scale_bar(position = c("left", "bottom")) +
  tm_compass(position = c("right", "top")) +
  tm_credits("(c) Mapbox, OSM    ",
             bg.color = "white",
             position = c("RIGHT", "BOTTOM"))

tm_shape(hennepin_tiles) +
  tm_rgb() +
  tm_shape(hennepin_black) +
  tm_polygons(col = "percent",
              style = "jenks",
              n = 5,
              palette = "Purples",
              title = "2020 US Census",
              alpha = 0.7) +
  tm_layout(title = "Percent Black\nby Census tract",
            legend.outside = TRUE,
            fontfamily = "Verdana") +
  tm_scale_bar(position = c("left", "bottom")) +
  tm_compass(position = c("right", "top")) +
  tm_credits("(c) Mapbox, OSM    ",
             bg.color = "white",
             position = c("RIGHT", "BOTTOM"))

install.packages("tmap-tools")


#6.4.1 with 311

nyc_bgs <- block_groups(state = "NY", 
                        county = c("New York",
                                   "Kings",
                                   "Bronx",
                                   "Richmond",
                                   "Queens"),
                        year = "2012")
View(nyc_bgs)
nyc_bgs_joined <- nyc_bgs %>%
  left_join(forloveallcategories, by = c("GEOID" = "GEOID"))
table(is.na(nyc_bgs_joined$GEOID))
View(nyc_bgs_joined)

nyc_bgs_joined_all <- nyc_bgs %>%
  left_join(forlove, by = c("GEOID" = "Data"))
table(is.na(nyc_bgs_joined_all$GEOID))
View(nyc_bgs_joined_all)


tm_shape(nyc_bgs_joined_all) +
  tm_facets(by = "COUNTYFP", scale.factor = 4) +
  tm_fill(col = "0",
          style = "quantile",
          n = 6,
          palette = "Blues",
          title = "2012 Residential Complaints By Borough",) +
  tm_layout(bg.color = "grey",
            legend.position = c(-0.7, 0.15),
            panel.label.bg.color = "white")

View(hennepin_race)
table(hennepin_race$variable)

irs_data <- read_csv("https://www.irs.gov/pub/irs-soi/18zpallnoagi.csv")

ncol(irs_data)
View(boston_se_data)
mapview(boston_zctas)


View(nyc_bgs_joined_all)
class(nyc_bgs_joined_all)
leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(data = nyc_bgs_joined_all_wgs,
              color = ~pal("0"),
              weight = 0.5,
              smoothFactor = 0.2,
              fillOpacity = 0.5,
              label = ~"0") %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = nyc_bgs_joined_all_wgs$"0",
    title = "# type 0 complaints NYC all"
  )

nyc_bgs_joined_all_wgs <- st_transform(nyc_bgs_joined_all, crs = "WGS84")

View(nyc_bgs_joined_all_wgs)
View(nyc_bgs_joined_all)

library(leaflet)
pal <- leaflet::colorNumeric(
  palette ="magma",
  domain = nyc_bgs_joined_all_wgs$"0"
)

leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(data = nyc_bgs_joined_all_wgs,
              color = pal(nyc_bgs_joined_all_wgs$"0"),
              weight = 0.5,
              smoothFactor = 0.2,
              fillOpacity = 0.5,
              label = nyc_bgs_joined_all_wgs$"0") %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = nyc_bgs_joined_all_wgs$"0",
    title = "# type 0 complaints NYC all"
  )

# Right now we just need to adjust the scale.

pal_q <- leaflet::colorQuantile(
  palette ="magma",
  domain = nyc_bgs_joined_all_wgs$"0"
)
pal_bin <- leaflet::colorBin(
  palette = "magma",
  domain = nyc_bgs_joined_all_wgs$"0",
  n = 5,
  )

bins <- c(0,56,164,439,1559)
pal_bins <- colorBin("YlOrRd", domain = nyc_bgs_joined_all_wgs$"0", bins = bins)
)

0   56  164  439 1559

leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(data = nyc_bgs_joined_all_wgs,
              color = pal_q(nyc_bgs_joined_all_wgs$"0"),
              weight = 0.5,
              smoothFactor = 0.2,
              fillOpacity = 0.5,
              label = nyc_bgs_joined_all_wgs$"0") %>%
  addLegend(
    position = "bottomright",
    pal = pal_q,
    values = nyc_bgs_joined_all_wgs$"0",
    title = "# type 0 complaints NYC all"
  )


leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(data = nyc_bgs_joined_all_wgs,
              fillColor = pal_q(nyc_bgs_joined_all_wgs$"0"),
              color = "black",
              stroke = TRUE,
              weight = 0.3,
              smoothFactor = 0,
              fillOpacity = 0.9,
              label = nyc_bgs_joined_all_wgs$"0") %>%
  addLegend(
    position = "bottomright",
    colors = c('black', 'purple', 'red', 'yellow'),
    values = nyc_bgs_joined_all_wgs$"0",
    labels = c("Q1: 0-10", "Q2: 11-26", "Q3: 27-53", "Q4: 54-1559"),
    title = "# 2012-2014 type 0 complaints NYC"
  )

nyc_bgs_2012_quantiles <- quantile(nyc_bgs_joined_all_wgs$"0", na.rm = TRUE)
print(nyc_bgs_2012_quantiles)

#for fun doing the Jenks:
install.packages("BAMMtools")
nyc_bgs_2012_jenks <- BAMMtools::getJenksBreaks(nyc_bgs_joined_all_wgs$"0", 5)
print(nyc_bgs_2012_jenks)

# wait I could totally add a highlight and so many things once you click!
# Another thing to consider: I could totally do a spectrum & avoid the whole percentile thing..
# But that's also mildly ridiculous b/c we want to classify and have numbers/visible categories
# should I do quintiles though. I could do `colorBin`. momentarily not doing that.


#should i create another categorical variable that corresponds to whether or not a certain bg is
#experiencing a lot of complaints (for the sake of regression/categorization)
# or should we keep the numbers for the purposes of the regressions. idk how to run those regressions
# mass but here's an idea. 1. categorize it all. 2. write a regression code for that category
#3. loop it over and over

#Trying Jenks bins with highlight options and interactivity through labels:

#adding labels:

labels_jenks <- sprintf(
  "<strong>%s</strong><br/>%g calls",
  nyc_bgs_joined_all_wgs$GEOID, nyc_bgs_joined_all_wgs$"0"
) %>% lapply(htmltools::HTML)

#I could add, through str_detect, a series of labels that match county FIPS to county name^^

View(nyc_bgs_joined_all_wgs)

pal_bins(c(0,56,164,439,1559))


leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(data = nyc_bgs_joined_all_wgs,
              fillColor = pal_bins(nyc_bgs_joined_all_wgs$"0"),
              color = "black",
              stroke = TRUE,
              weight = 0.3,
              smoothFactor = 0,
              fillOpacity = 0.9,
              highlightOptions = highlightOptions(
                weight = 3,
                color = "#F8C",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labels_jenks,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) %>%
  addLegend(
    position = "bottomright",
    colors = c('#FFFFB2', '#FECC5C', '#FD8D3C', '#E31A1C'),
    values = nyc_bgs_joined_all_wgs$"0",
    labels = c("J1: 0-55", "J2: 56-163", "J3: 164-438", "J4: 439-1559"),
    title = "# 2012-2014 type 0 complaints NYC"
  )

library(magrittr)
library(leaflet)
write.csv2(nyc_bgs_joined_all_wgs, file = "/Users/benetge/Downloads/57/NYC311datafiles/leaflet/nyc_bg_b_leaflet_semicolon.csv", row.names = TRUE, quote = TRUE)

install.packages("here")
