library(compensator)
load_all()
# step 1, get org info 
org <- get_org_values(state = "FL",
                      location.type = "rural",
                      total.expense = 100000,
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
       
samp <- select_sample(org = org, search.criteria = search.criteria)

# Step 4 get appraisal

appraisal <- predict_salary(samp)
appraisal



### All steps 
org <- get_org_values(state = "FL",
                      location.type = "rural",
                      total.expense = 100000,
                      ntee = "B20")
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

get_appraisal(org, search.criteria) 
