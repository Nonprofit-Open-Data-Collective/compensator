library(compensator)

# step 1, get org info 
org <- get_org_values(state = "AL",
                      location.type = "rural",
                      total.expense = 100000,
                      ntee = "B20")

# step 2, get comparison orgs and calculate distances
search.criteria <-
  list(broad.category = 1:12, 
       major.group = base::LETTERS, 
       decile = 2:9, 
       type.org = "regular", 
       univ = FALSE,
       hosp = FALSE, 
       location.type = "both", 
       state = c(datasets::state.abb, "DC", "PR"), 
       total.expense = c(0, Inf) )
       
samp <- select_sample(org, search.criteria)
