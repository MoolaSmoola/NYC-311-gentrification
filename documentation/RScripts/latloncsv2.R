#Reading and categorizing all the data, aka getting everything up to date.

library(sf)
library(dplyr)
library(haven)
library(readr)
library(data.table)
library(here)

#### READING DATA & CONVERTING LAT/LON TO FIPS ####
NYC3112pared <- read_dta(here("NYC311datafiles", "pared data stata compress", "NYC311g2paredcompress.dta"))
block_groups <- st_read(here("NYCshapefiles", "cb_2018_36_bg_500k", "cb_2018_36_bg_500k.shp"),
                        quiet = TRUE)
latlong_sf <- NYC3112pared %>%
  filter(!is.na(latitude), !is.na(longitude)) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = st_crs(block_groups))

system.time({
  intersected <- st_intersects(latlong_sf, block_groups)
})
latlong_final <- latlong_sf %>% 
  mutate(intersection = as.integer(intersected),
         fips = if_else(is.na(intersection), "",
                        block_groups$GEOID[intersection]))
latlong_relevant <- latlong_final[,c(1,46,47)]
head(latlong_relevant, n=10)
write.csv2(latlong_final, here("NYC311datafiles", "pared block group data", "paredbg_g_test.csv"))

#### ASSIGNING CATEGORIES ####
library(stringr)
NYC3112bg <- read.csv(
  here("NYC311datafiles", "pared block group data", "paredbg_g_test.csv"),
  sep=";")
NYC3112bg <- NYC3112bg[,-1]
View(NYC3112bg)
NYCmutatefinal <- NYC3112bg %>% 
  mutate(complaintcategory = case_when(str_detect(complainttype, "Noise - Residential")~ "0",
                                       str_detect(complainttype, "Blocked Driveway") ~ "3",
                                       str_detect(complainttype, "Noise - Commercial") ~ "1",
                                       str_detect(complainttype, "Building/Use") ~ "5",
                                       str_detect(complainttype, "Graffiti") ~ "5",
                                       str_detect(complainttype, "Noise - Street/Sidewalk") ~ "1",
                                       str_detect(complainttype, "Derelict Vehicle") ~ "4",
                                       str_detect(complainttype, "Illegal Parking") ~ "3",
                                       str_detect(complainttype, "Noise - Vehicle") ~ "1",
                                       str_detect(complainttype, "Non-Emergency Police Matter") ~ "5",
                                       str_detect(complainttype, "Noise - Park") ~ "1",
                                       str_detect(complainttype, "Smoking") ~ "5",
                                       str_detect(complainttype, "Unsanitary Animal Pvt Property") ~ "5",
                                       str_detect(complainttype, "Illegal Tree Damage") ~ "5",
                                       str_detect(complainttype, "Derelict Bicycle") ~ "4",
                                       str_detect(complainttype, "Drinking") ~ "5",
                                       str_detect(complainttype, "Noise - House of Worship") ~ "1",
                                       str_detect(complainttype, "Disorderly Youth") ~ "5",
                                       str_detect(complainttype, "Bike/Roller/Skate Chronic") ~ "5",
                                       str_detect(complainttype, "Urinating in Public") ~ "5",
                                       str_detect(complainttype, "Illegal Fireworks") ~ "5",
                                       str_detect(complainttype, "Homeless Person Assistance") ~ "5",
                                       str_detect(complainttype, "Animal Abuse") ~ "5",
                                       str_detect(complainttype, "Panhandling") ~ "5",
                                       str_detect(complainttype, "Illegal Animal Kept as Pet") ~ "5",
                                       str_detect(complainttype, "Harboring Bees/Wasps") ~ "5",
                                       str_detect(complainttype, "Violation of Park Rules") ~ "5",
                                       str_detect(complainttype, "Illegal Animal Sold") ~ "5",
                                       str_detect(complainttype, "Squeegee") ~ "5"))
View(NYCmutatefinal)
NYCmutatesocialconflict <- NYCmutatefinal %>% 
  mutate(complaintsocialconflict = case_when(str_detect(complainttype, "Noise - Residential")~ "2",
                                             str_detect(complainttype, "Blocked Driveway") ~ "1",
                                             str_detect(complainttype, "Noise - Commercial") ~ "1",
                                             str_detect(complainttype, "Building/Use") ~ "1",
                                             str_detect(complainttype, "Graffiti") ~ "1",
                                             str_detect(complainttype, "Noise - Street/Sidewalk") ~ "2",
                                             str_detect(complainttype, "Derelict Vehicle") ~ "1",
                                             str_detect(complainttype, "Illegal Parking") ~ "1",
                                             str_detect(complainttype, "Noise - Vehicle") ~ "1",
                                             str_detect(complainttype, "Non-Emergency Police Matter") ~ "1",
                                             str_detect(complainttype, "Noise - Park") ~ "2",
                                             str_detect(complainttype, "Smoking") ~ "1",
                                             str_detect(complainttype, "Unsanitary Animal Pvt Property") ~ "1",
                                             str_detect(complainttype, "Illegal Tree Damage") ~ "1",
                                             str_detect(complainttype, "Derelict Bicycle") ~ "1",
                                             str_detect(complainttype, "Drinking") ~ "1",
                                             str_detect(complainttype, "Noise - House of Worship") ~ "1",
                                             str_detect(complainttype, "Disorderly Youth") ~ "2",
                                             str_detect(complainttype, "Bike/Roller/Skate Chronic") ~ "1",
                                             str_detect(complainttype, "Urinating in Public") ~ "1",
                                             str_detect(complainttype, "Illegal Fireworks") ~ "1",
                                             str_detect(complainttype, "Homeless Person Assistance") ~ "1",
                                             str_detect(complainttype, "Animal Abuse") ~ "1",
                                             str_detect(complainttype, "Panhandling") ~ "1",
                                             str_detect(complainttype, "Illegal Animal Kept as Pet") ~ "1",
                                             str_detect(complainttype, "Harboring Bees/Wasps") ~ "1",
                                             str_detect(complainttype, "Violation of Park Rules") ~ "1",
                                             str_detect(complainttype, "Illegal Animal Sold") ~ "1",
                                             str_detect(complainttype, "Squeegee") ~ "1"))
View(NYCmutatesocialconflict)
write.csv2(NYCmutatesocialconflict, here("NYC311datafiles", "pared block group data", "categorized", "paredbg_g_categorize.csv"))


#### EXTRACTING COMPLAINT CATEGORY SECTIONS OF THE FILES ####
NYC311categorized <- read.csv(
  here("NYC311datafiles", "pared block group data", "categorized", "paredbg_g_categorize.csv"), 
       sep=";")
NYC311categorized <- NYC311categorized[,-1]
View(NYC311categorized)
testtable <- table(NYC311categorized$fips, NYC311categorized$complaintcategory)
View(testtable)

dftbls <- function (x) {   
  f <- as.data.frame.matrix(x, stringsAsFactors = F)   
  f <- cbind(row.names(f), f)   
  row.names(f) <- NULL   
  names(f)[1] <- "Data"   
  return(f) 
}

test <- dftbls(testtable)
forlove <- test %>%
  mutate(sum = rowSums(across(where(is.numeric))))
View(forlove)
write.csv2(forlove, here("NYC311datafiles", "leaflet", "forloveg.csv"), 
           row.names = TRUE, 
           quote = TRUE)




           
           
           


