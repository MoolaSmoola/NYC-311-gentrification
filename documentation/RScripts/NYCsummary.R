#Descriptive Statistics and generating some graphs, diagrams, maps

#start by reading & viewing
NYC311bcategorized <- read.csv(file = "/Users/benetge/Downloads/57/NYC311datafiles/pared block group data/categorized/paredbg_b_categorize.csv", sep=";")
NYC311bcategorized <- NYC311bcategorized[,-1]
View(NYC311bcategorized)

summarytest <- by(NYC311bcategorized, NYC311bcategorized$complaintcategory, summary)

#Just figuring out what some of these variables mean and if we should sort by them or omit or observe
table(NYC311bcategorized$agency)
table(NYC311bcategorized$locationtype)
table(NYC311bcategorized$incidentaddress)
table(NYC311bcategorized$addresstype)
table(NYC311bcategorized$landmark)
table(NYC311bcategorized$facilitytype)
table(NYC311bcategorized$status)
table(NYC311bcategorized$resolutiondescription)
table(NYC311bcategorized$communityboard)
table(NYC311bcategorized$bbl)
table(NYC311bcategorized$opendatachanneltype)
table(NYC311bcategorized$parkfacilityname)
table(NYC311bcategorized$borough)
table(NYC311bcategorized$parkborough)
table(NYC311bcategorized$vehiclename)
table(NYC311bcategorized$bridgehighwayname)
table(NYC311bcategorized$communitydistricts)
table(NYC311bcategorized$boroughboundaries)

testtable <- table(NYC311bcategorized$fips, NYC311bcategorized$complaintcategory)
View(testtable)
shit <- testtable[,-2]
View(shit)

#custom function that prevents the first column of data going into the row.names column:
dftbls <- function (x) {   
  f <- as.data.frame.matrix(x, stringsAsFactors = F)   
  f <- cbind(row.names(f), f)   
  row.names(f) <- NULL   
  names(f)[1] <- "Data"   
  return(f) 
}

#Applying the function and viewing it

test2 <- dftbls(testtable)
forlove <- test2 %>%
  mutate(sum = rowSums(across(where(is.numeric))))
forlove2 <- forlove[-c(2:6)]
forlove3 <- forlove2 %>%
  filter(grepl('36061',Data))
View(forlove3)
View(forlove2)
View(test2)
View(forlove)

write.csv2(forlove, file = "/Users/benetge/Downloads/57/NYC311datafiles/leaflet/forlove.csv", row.names = TRUE, quote = TRUE)

forloveallcategories <- forlove %>% 
  filter(grepl('36061',Data))

View(forloveallcategories)
#coming up with some summary statistics?
sum(test2$"0")

summary(test2)

#okay I'm actually just going to come up with my own summary package 
# because these values are not numerical but rather ordinal.
# I want: quartiles, mean, sd, sum & that's about it? In any case if I make my own I can +/-.
library(dplyr)

View(NYC311bcategorized)
var_summary <- function(data, var) {
  data %>% 
    summarise(min = ({{var}}), max = ({{var}}))
}

jesuss <- NYC311bcategorized %>%
  group_by(fips) %>%
  var_summary(complaintcategory)

View(jesuss)


bitch <- NYC311bcategorized %>% my_summarise(fips)
View(bitch)
