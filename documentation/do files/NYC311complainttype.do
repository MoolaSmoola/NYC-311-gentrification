*keeping relevant complaint types
capture log close
log using NYC311complaintkeep, replace
*part a 2010-2012
use "/Users/benetge/Downloads/57/NYC311datafiles/NYC311a2.dta", clear
keep if inlist(complainttype, "Noise - Residential", "Noise - Street/Sidewalk", "Noise - Park", "Drug Activity", "Disorderly Youth", "Illegal Parking", "Blocked Driveway", "Noise - Commercial", "Derelict Vehicle") | inlist(complainttype, "Noise - Vehicle", "Building/Use", "Homeless Person Assistance", "Graffiti", "Animal Abuse", "Non-Emergency Police Matter", "Homeless Encampment," "Vending", "Illegal Tree Damage") | inlist(complainttype, "Unsanitary Animal Pvt Property", "Smoking", "Derelict Bicycle", "Derelict Vehicles", "Drinking", "Noise - House of Worship", "Violation of Park Rules", "Urinating in Public", "Panhandling") | inlist(complainttype, "Bike/Roller/Skate Chronic", "Illegal Animal Kept as Pet", "Illegal Fireworks", "Harboring Bees/Wasps", "Elder Abuse", "Illegal Animal Sold", "Squeegee") // No more than 10 string variables per inlist so it's segmented by |, total 34 complainttypes listed descending in order of social conflict level, then frequency within each category 
save NYC311a2pared.dta, replace

*part b 2012-2014
use "/Users/benetge/Downloads/57/NYC311datafiles/NYC311b2.dta", clear
keep if inlist(complainttype, "Noise - Residential", "Noise - Street/Sidewalk", "Noise - Park", "Drug Activity", "Disorderly Youth", "Illegal Parking", "Blocked Driveway", "Noise - Commercial", "Derelict Vehicle") | inlist(complainttype, "Noise - Vehicle", "Building/Use", "Homeless Person Assistance", "Graffiti", "Animal Abuse", "Non-Emergency Police Matter", "Homeless Encampment," "Vending", "Illegal Tree Damage") | inlist(complainttype, "Unsanitary Animal Pvt Property", "Smoking", "Derelict Bicycle", "Derelict Vehicles", "Drinking", "Noise - House of Worship", "Violation of Park Rules", "Urinating in Public", "Panhandling") | inlist(complainttype, "Bike/Roller/Skate Chronic", "Illegal Animal Kept as Pet", "Illegal Fireworks", "Harboring Bees/Wasps", "Elder Abuse", "Illegal Animal Sold", "Squeegee")
save NYC311b2pared.dta, replace

*part c 2014-2016

use "/Users/benetge/Downloads/57/NYC311datafiles/NYC311c2.dta", clear
keep if inlist(complainttype, "Noise - Residential", "Noise - Street/Sidewalk", "Noise - Park", "Drug Activity", "Disorderly Youth", "Illegal Parking", "Blocked Driveway", "Noise - Commercial", "Derelict Vehicle") | inlist(complainttype, "Noise - Vehicle", "Building/Use", "Homeless Person Assistance", "Graffiti", "Animal Abuse", "Non-Emergency Police Matter", "Homeless Encampment," "Vending", "Illegal Tree Damage") | inlist(complainttype, "Unsanitary Animal Pvt Property", "Smoking", "Derelict Bicycle", "Derelict Vehicles", "Drinking", "Noise - House of Worship", "Violation of Park Rules", "Urinating in Public", "Panhandling") | inlist(complainttype, "Bike/Roller/Skate Chronic", "Illegal Animal Kept as Pet", "Illegal Fireworks", "Harboring Bees/Wasps", "Elder Abuse", "Illegal Animal Sold", "Squeegee")
save NYC311c2pared.dta, replace

*part d 2016-2018

use "/Users/benetge/Downloads/57/NYC311datafiles/NYC311d2.dta", clear
keep if inlist(complainttype, "Noise - Residential", "Noise - Street/Sidewalk", "Noise - Park", "Drug Activity", "Disorderly Youth", "Illegal Parking", "Blocked Driveway", "Noise - Commercial", "Derelict Vehicle") | inlist(complainttype, "Noise - Vehicle", "Building/Use", "Homeless Person Assistance", "Graffiti", "Animal Abuse", "Non-Emergency Police Matter", "Homeless Encampment," "Vending", "Illegal Tree Damage") | inlist(complainttype, "Unsanitary Animal Pvt Property", "Smoking", "Derelict Bicycle", "Derelict Vehicles", "Drinking", "Noise - House of Worship", "Violation of Park Rules", "Urinating in Public", "Panhandling") | inlist(complainttype, "Bike/Roller/Skate Chronic", "Illegal Animal Kept as Pet", "Illegal Fireworks", "Harboring Bees/Wasps", "Elder Abuse", "Illegal Animal Sold", "Squeegee")
save NYC311d2pared.dta, replace

*part e 2018-2020

use "/Users/benetge/Downloads/57/NYC311datafiles/NYC311e2.dta", clear
keep if inlist(complainttype, "Noise - Residential", "Noise - Street/Sidewalk", "Noise - Park", "Drug Activity", "Disorderly Youth", "Illegal Parking", "Blocked Driveway", "Noise - Commercial", "Derelict Vehicle") | inlist(complainttype, "Noise - Vehicle", "Building/Use", "Homeless Person Assistance", "Graffiti", "Animal Abuse", "Non-Emergency Police Matter", "Homeless Encampment," "Vending", "Illegal Tree Damage") | inlist(complainttype, "Unsanitary Animal Pvt Property", "Smoking", "Derelict Bicycle", "Derelict Vehicles", "Drinking", "Noise - House of Worship", "Violation of Park Rules", "Urinating in Public", "Panhandling") | inlist(complainttype, "Bike/Roller/Skate Chronic", "Illegal Animal Kept as Pet", "Illegal Fireworks", "Harboring Bees/Wasps", "Elder Abuse", "Illegal Animal Sold", "Squeegee")
save NYC311e2pared.dta, replace

*part f 2020-November 30 2021

use "/Users/benetge/Downloads/57/NYC311datafiles/NYC311f2.dta", clear
keep if inlist(complainttype, "Noise - Residential", "Noise - Street/Sidewalk", "Noise - Park", "Drug Activity", "Disorderly Youth", "Illegal Parking", "Blocked Driveway", "Noise - Commercial", "Derelict Vehicle") | inlist(complainttype, "Noise - Vehicle", "Building/Use", "Homeless Person Assistance", "Graffiti", "Animal Abuse", "Non-Emergency Police Matter", "Homeless Encampment," "Vending", "Illegal Tree Damage") | inlist(complainttype, "Unsanitary Animal Pvt Property", "Smoking", "Derelict Bicycle", "Derelict Vehicles", "Drinking", "Noise - House of Worship", "Violation of Park Rules", "Urinating in Public", "Panhandling") | inlist(complainttype, "Bike/Roller/Skate Chronic", "Illegal Animal Kept as Pet", "Illegal Fireworks", "Harboring Bees/Wasps", "Elder Abuse", "Illegal Animal Sold", "Squeegee")
save NYC311f2pared.dta, replace


*part g December 31 2021 - present

use "/Users/benetge/Downloads/57/NYC311datafiles/NYC311g2.dta", clear
keep if inlist(complainttype, "Noise - Residential", "Noise - Street/Sidewalk", "Noise - Park", "Drug Activity", "Disorderly Youth", "Illegal Parking", "Blocked Driveway", "Noise - Commercial", "Derelict Vehicle") | inlist(complainttype, "Noise - Vehicle", "Building/Use", "Homeless Person Assistance", "Graffiti", "Animal Abuse", "Non-Emergency Police Matter", "Homeless Encampment," "Vending", "Illegal Tree Damage") | inlist(complainttype, "Unsanitary Animal Pvt Property", "Smoking", "Derelict Bicycle", "Derelict Vehicles", "Drinking", "Noise - House of Worship", "Violation of Park Rules", "Urinating in Public", "Panhandling") | inlist(complainttype, "Bike/Roller/Skate Chronic", "Illegal Animal Kept as Pet", "Illegal Fireworks", "Harboring Bees/Wasps", "Elder Abuse", "Illegal Animal Sold", "Squeegee")
save NYC311g2pared.dta, replace

log close
