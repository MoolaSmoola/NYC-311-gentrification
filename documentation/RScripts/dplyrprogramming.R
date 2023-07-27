#learning programming functions in dplyr

library(dplyr)



#data-variables in function argument, must be embraced.
var_summary <- function(data, var) {
  data %>%
    summarise(n = n(), min = min({{ var }}), max = max({{ var }}))
}
mtcars %>% 
  group_by(cyl) %>% 
  var_summary(mpg)


View(mtcars)

#env-variables is a character vector, must prefix with .data & square.

for (var in names(mtcars)) {
  mtcars %>% count(.data[[var]]) %>% print()
}

#name injection

#first performed with env-v, glued in:
name <- "susan"
tibble("{name}" := 2)

#now performed with data-v, called with embracing:

my_df <- function(x) {
  tibble("{{x}}_2" := x * 2)
}
my_var <- 10
my_df(my_var)



#now we're doing tidy select

summarise_mean <- function(data, vars) {
  data %>% summarise(n = n(), across({{ vars }}, mean))
}
mtcars %>% 
  group_by(cyl) %>% 
  summarise_mean(where(is.numeric))


vars <- c("mpg", "vs")
mtcars %>% select(all_of(vars))
mtcars %>% select(!all_of(vars))


#how-tos:

#user-supplied data:
mutate_y <- function(data) {
  mutate(data, y = a + x)
}
mutate_y(mtcars)



#multiple user-supplied expressions. It works & I want it down across() our category variables 0-5

my_summarise4 <- function(data, expr) {
  data %>% summarise(
    "mean_{{expr}}" := mean({{ expr }}),
    "sum_{{expr}}" := sum({{ expr }}),
    "n_{{expr}}" := n()
  )
}

curious_summarise4 <- NYC311bcategorized %>%
  group_by(fips) %>%
  my_summarise4(complaintcategory)

View(curious_summarise4)

letsbehonestidk <- function(data, expr) {
  tibble(
    val = sum({{ expr }})
  )
}

bitch <- tibble(NYC311bcategorized)

bitch

bruh <- bitch %>%
  group_by(fips) %>%
  summarise(NYC311bcategorized, ~letsbehonestidk(complaintcategory), .unpack = TRUE)
  
View(bruh)

mf_summarise <- function(data, expr) {
  data %>% summarise(
    "sum_{{expr}}" := sum({{ expr }})
    "n_{{expr}}" := sum({{ expr }}),
    
  )
}





my_summarise3 <- function(data, mean_var, sd_var) {
  data %>% 
    summarise(mean = mean({{ mean_var }}), sd = sd({{ sd_var }}))
}

curious_summarise3 <- NYC311bcategorized %>%
  group_by(fips) %>%
  my_summarise3(complaintcategory, complaintsocialconflict)
View(curious_summarise3)






#curious about the results of my summarise3. SD COLUMN COMES FROM THE SECOND EXP., SOCIAL CONFLICT!
weirdo <- NYC311bcategorized %>%
  filter(NYC311bcategorized$fips == "360050002001")
  
View(weirdo)
sd(weirdo$complaintsocialconflict)

my_summarise2 <- function(data, expr) {
  data %>% summarise(
    mean = mean({{ expr }}),
    sum = sum({{ expr }}),
    n = n()
  )
}

curious_summarise2 <- NYC311bcategorized %>%
  group_by(fips) %>%
  my_summarise2(complaintcategory)
View(curious_summarise2)


#Any number of user-supplied expressions.

quantile_df <- function(x, probs = c(0.25, 0.5, 0.75)) {
  tibble(
    val = quantile(x, probs),
    quant = probs
  )
}

x <- 1:5
quantile_df(x)

quantile(1,0.25)
quantile(2,0.5)

#transforming user-supplied variables
my_summarise <- function(data, group_var, summarise_var) {
  data %>%
    group_by(pick({{ group_var }})) %>% 
    summarise(across({{ summarise_var }}, mean))
}

actuallywtf <- NYC311bcategorized %>%
  my_summarise(fips, complaintcategory)
View(actuallywtf)



for (var in names(mtcars)) {
  mtcars %>% count(.data[[var]]) %>% print()
}



mtcars %>% 
  names() %>% 
  purrr::map(~ count(mtcars, .data[[.x]]))



#learning briefly map so that I can learn how to iterate a summary across diff. obs. values.

library(purrr)

imap_chr(sample(10), paste)


imap_chr(sample(10), \(x, idx) paste0(idx, ": ", x))

