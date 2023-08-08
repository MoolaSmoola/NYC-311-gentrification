# Personal reminders

## to do
* For infinity values in the complaint categories, change the pre time wave 2 observations to (1) & just see what happens
* As an alternative I should simply apply multiple metrics of gentrification to the same file.
* verify that the time1and2_mutateddifferences file pre and post- `as.numeric` aligns.

## Notes from today
* ethnic composition
* controls
* looking at subsets of complaints (maybe to get rid of the infinity problem momentarily by assigning 1s or filtering)
* histograms & summary statistics for variables & clean them up to look nice
* try different kinds of gentrification metrics.
* session/save workspace
* is gentrification necessarily an income change or is it an ethnic composition change? people's complaints are about ethnic

## Shiny map
* separate between 0 & NA calls
* add markers for parks/houses of worship/etc.
* map the different markers of gentrification


## Forming measures of gentrification
* Certain changes should have multiple measures e.g. Discrete difference in median years of education, combined with percent difference
* Changing strings to numerals results in a transition to 7 total digits
* Infinity increases in complaints (as expected from the jump from 0 to any amount).

## ACS data
* ~~Comparison Profile a viable option~~
* population estimates should not be taken from ACS 5-year but rather the Census Population Estimates Program (PEP)
* 2020 nonresponse bias was [adjusted](https://www.census.gov/programs-surveys/acs/technical-documentation/user-notes/2022-03.html) in caclulating ACS 5-years that include 2020
* ACS 5-year includes estimates for [all population sizes](https://www.census.gov/programs-surveys/acs/guidance/estimates.html)
* Multi-year estimates [smooth out 1-year impacts like COVID](https://www.census.gov/newsroom/blogs/random-samplings/2022/03/period-estimates-american-community-survey.html), included in time I of our data. Further reading needed.
* [Difference in number of block groups](https://www.census.gov/programs-surveys/acs/geography-acs/reference-materials.2021.html#list-tab-2123892609) between pre-2020: (220333) & post: (242335) is 22002.
* [Relationship file of 2010 - 2020 changes in block groups](https://www2.census.gov/geo/docs/maps-data/data/rel2020/blkgrp/tab20_blkgrp20_blkgrp10_st36.txt)
* What ACS 5-year variable to use for percent moved within 5 years: 2010-2014, 2000-2009, 2015 and after?
* When calculating medians for years of education, certain variables were excluded (GED/somecollegenodegree) & normative judgements were made about how many years certain stages take (bachelor's/associate's/master's degree/professional school degree/doctorate degree). These can be excluded, or alternatively assigned numeric values corresponding to *levels*.
* Strangely, in the ACS 2017-2021 there are a number of NA values for median. There are none in the 2012-2016.
* Funnily, there are some block groups with complaints and no land mass. Figure out how that happened.

## log 
* created repo clone on local git, ~/57/NYC311datafiles/leaflet
* created folder for app in main branch, leafletapp; app saved as app.R
* In order to run app: `runGitHub("NYC-311-gentrification", "MoolaSmoola", subdir = "leafletapp/")`
