#testing the FCC API on NYC311a2pared.dta before appending them
install.packages('haven')
library(haven)
NYC311a2pared <- read_dta('/Users/benetge/Downloads/57/NYC311datafiles/pared data/NYC311a2pared.dta')
View(NYC311a2pared)

if (!require("RJSONIO")) install.packages("RJSONIO")

#as a note this is only retrieving county for now.. I have to change that to block group
install.packages('jsonlite')

latlong2fips <- function(latitude, longitude) {
  url <- "https://geo.fcc.gov/api/census/block/find?format=json&latitude=%f&longitude=%f"
  url <- sprintf(url, latitude, longitude)
  json <- RJSONIO::fromJSON(url)
  as.character(json$County['FIPS'])
}




#test to see that it's working at minimum
latlong2fips(40.61216,-73.95504)
geo2fips(40.61216,-73.95504)

#trying this

install.packages('data.table')
library(data.table)
a = data.table(latitude=c(28.35975,28.36975,29.33), longitude=c(-81.421988,-81.431988,-81.55))
a[,fips:="0"]
for(i in 1:nrow(a)){
  lat = a[i, latitude]
  lon = a[i, longitude]
  a[i, fips := latlong2fips(latitude = lat, longitude = lon)]
}




#trying the stackoverflow
geo2fips <- function(latitude, longitude) { 
  url <- "https://geo.fcc.gov/api/census/area?lat=%f&lon=%f&format=json"
  res <- jsonlite::fromJSON(sprintf(url, latitude, longitude))[["results"]][["block_fips"]]
  unique(res)
}



#the crucial part

NYC311a2pared['fips'] <- NA # creating an empty column for FIPS to return to.

  
  

NYC311a2pared$fips <- mapply(latlong2fips, NYC311a2pared$latitude, NYC311a2pared$longitude)
NYC311a2pared$fips <- mapply(geo2fips, NYC311a2pared$latitude, NYC311a2pared$longitude)








