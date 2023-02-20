devtools::build()
library(compensator)

### Set up initial parameters  ---------------------------------
# step 1, get org info 
org <- get_org_values(state = "FL",
                      location.type = "metro",
                      total.expense = 1000000,
                      ntee = "B20")

# step 2, get comparison orgs and calculate distances
search.criteria <-
  list(broad.category = 1:2, 
       major.group = base::LETTERS, 
       tens = 2:9, 
       type.org = "regular", 
       univ = FALSE,
       hosp = FALSE, 
       location.type = "both", 
       state = c("DC", "KS", "CA", "DE", "MD", "FL"), 
       total.expense = c(0, Inf) )
       

### Attempt 1: Using wrapper function -----------------------------------
appraisal2 <- get_appraisal(org, search.criteria) 

appraisal2$suggested.salary
appraisal2$suggested.range
reference.set <- appraisal2$reference.set
View(reference.set)


### Attempt 2 - doing each step individually ------------------------
### (For diagnostic purposes)

#get sample with distance
samp <- select_sample(org = org, search.criteria = search.criteria)

# get appraisal
appraisal <- predict_salary(samp)
appraisal



