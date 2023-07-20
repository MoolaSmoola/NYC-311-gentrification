#archaic original failure:

NYC311b2bg <- read.csv(file = "/Users/benetge/Downloads/57/NYC311datafiles/pared block group data/paredbg_b.csv", head = FALSE)
View(NYC311b2bg)


colnames(NYC311b2bg) <- as.character(NYC311b2bg[1, ])
NYC311b2bg <- NYC311b2bg[-1,]  # to deal with horrible csv importing problems

#example of assigning labels:
library(dplyr)
library(stringr)

sample_df <- data.frame(
  stringsAsFactors = FALSE,
  Assigned = c("Name 1", "Name 1", "Name 3", "Name 4", "Name 2"),
  Assigned_Type = c("ISR", "ISR", "Sales Lead", "Sales Lead", "ISR")
)

sample_df %>% 
  mutate(new_column = if_else(str_detect(Assigned, "(1|2)$"), "ISR", "Sales Lead"))

sample_df %>% 
  mutate(new_column = case_when(str_detect(Assigned, "(1|2)$")~ "ISR",
                                str_detect(Assigned, "(3)$")~ "Sales Lead",
                                TRUE ~ "other"))

View(sample_df)

 |\__/,|   (`\
 |_ _  |.--.) )
 ( T   )     /
(((^_(((/(((_/



#test with semi-colon separated csv.. IT WORKED!
NYC311b2bg <- read.csv(file = "/Users/benetge/Downloads/57/NYC311datafiles/pared block group data/paredbg_b_test.csv", sep=";")
NYC311b2bg <- NYC311b2bg[,-1]
View(NYC311b2bg)

#tabulating NYC311 data so I don't have to switch between STATA & R constantly to assign labels:
tabulate <- table(NYCmutate$complainttype, NYCmutate$descriptor)
View(tabulate)

#labeling NYC311 data:


NYCmutate3 <- NYC311b2bg %>% mutate(complaintp = case_when(str_detect(complainttype, "Noise - Residential"~ "0"),
                                       str_detect(complainttype, "Blocked Driveway" ~ "3"),
                                       str_detect(complainttype, "Noise - Commercial" ~ "1"),
                                       str_detect(complainttype, "Building/Use" ~ "5"),
                                       str_detect(complainttype, "Graffiti" ~ "5"),
                                       str_detect(complainttype, "Noise - Street/Sidewalk" ~ "1"),
                                       str_detect(complainttype, "Derelict Vehicle" ~ "4"),
                                       str_detect(complainttype, "Illegal Parking" ~ "3"),
                                       str_detect(complainttype, "Noise - Vehicle" ~ "1"),
                                       str_detect(complainttype, "Non-Emergency Police Matter" ~ "5"),
                                       str_detect(complainttype, "Noise - Park" ~ "1"),
                                       str_detect(complainttype, "Smoking" ~ "5"),
                                       str_detect(complainttype, "Unsanitary Animal Pvt Property" ~ "5"),
                                       str_detect(complainttype, "Illegal Tree Damage" ~ "5"),
                                       str_detect(complainttype, "Derelict Bicycle" ~ "4"),
                                       str_detect(complainttype, "Drinking" ~ "5"),
                                       str_detect(complainttype, "Noise - House of Worship" ~ "1"),
                                       str_detect(complainttype, "Disorderly Youth" ~ "5"),
                                       str_detect(complainttype, "Bike/Roller/Skate Chronic" ~ "5"),
                                       str_detect(complainttype, "Urinating in Public" ~ "5"),
                                       str_detect(complainttype, "Illegal Fireworks" ~ "5"),
                                       str_detect(complainttype, "Homeless Person Assistance" ~ "5"),
                                       str_detect(complainttype, "Animal Abuse" ~ "5"),
                                       str_detect(complainttype, "Panhandling" ~ "5"),
                                       str_detect(complainttype, "Illegal Animal Kept as Pet" ~ "5"),
                                       str_detect(complainttype, "Harboring Bees/Wasps" ~ "5"),
                                       str_detect(complainttype, "Violation of Park Rules" ~ "5"),
                                       str_detect(complainttype, "Illegal Animal Sold" ~ "5"),
                                       str_detect(complainttype, "Squeegee" ~ "5")))
                                       
                                    



View(NYCmutate)

#Troubleshooting with a smaller set. IT WORKS!!!!!
NYCmutatebfinal <- NYC311b2bg %>% 
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

View(NYCmutatebfinal)
                                       
# Now we're going to add the complaint relevance categories by importing a csv.
tabulate_complainttype <- read.csv(file = "/Users/benetge/Downloads/57/NYC311datafiles/complainttype_tabulate.csv")
View(tabulate_complainttype)


#Now we're going to do the same mutate case_when str_detect sequence.. remember to add to the data.frame just created.
NYCmutatebsocialconflict <- NYCmutatebfinal %>% 
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
    
View(NYCmutatebsocialconflict)

#Now saving the result as a csv again. 
write.csv2(NYCmutatebsocialconflict, "/Users/benetge/Downloads/57/NYC311datafiles/pared block group data/categorized/paredbg_b_categorize.csv", row.names = TRUE, quote = TRUE)

         