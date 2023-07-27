*compressing dta files so that they can be read into R, to generate block groups
capture log close 
log using NYC311paredcompress, replace
*part a 2010-2012
use "/Users/benetge/Downloads/57/NYC311datafiles/pared data/NYC311a2pared.dta", clear
compress
save NYC311a2paredcompress, replace

*part b 2012-2014
use "/Users/benetge/Downloads/57/NYC311datafiles/pared data/NYC311b2pared.dta", clear
compress
save NYC311b2paredcompress, replace

*part c 2014-2016
use "/Users/benetge/Downloads/57/NYC311datafiles/pared data/NYC311c2pared.dta", clear
compress
save NYC311c2paredcompress, replace

*part d 2016-2018
use "/Users/benetge/Downloads/57/NYC311datafiles/pared data/NYC311d2pared.dta", clear
compress
save NYC311d2paredcompress, replace

*part e 2018-2020
use "/Users/benetge/Downloads/57/NYC311datafiles/pared data/NYC311e2pared.dta", clear
compress
save NYC311e2paredcompress, replace

*part f 2020-November 30 2021
use "/Users/benetge/Downloads/57/NYC311datafiles/pared data/NYC311f2pared.dta", clear
compress
save NYC311f2paredcompress, replace

*part g December 1 2021–present
use "/Users/benetge/Downloads/57/NYC311datafiles/pared data/NYC311g2pared.dta", clear
compress
save NYC311g2paredcompress, replace

log close
