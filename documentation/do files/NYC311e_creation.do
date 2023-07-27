**creating NYC311e.dta
capture log close
log using NYC311e.log, replace
version 17
clear
import delimited "/Users/benetge/Downloads/311_Service_Requests_from_2010_to_Present (1).csv"
save NYC311e.dta
log close
