library(compensator)

## Get all regular nonprofits (no specality orgs)
# see help file for defaults
dat.filtered <- dat_filtering()

### Calculate distances 
# create a random org
org <- data.frame(State = "AL", 
                  LocationType = "rural",
                  NTEE = "B20",
                  UNIV = FALSE,
                  HOSP = FALSE,
                  TotalExpense = 1000000
                  )

# Assign random weights
weights = list(geo = data.frame(level = c(1,2,3),
                                weight = c(1,1,1)),
               r.mission = data.frame(level = c(1,2,3,4),
                                      weight = c(1,1,1,1)))

#get results
results <- calc_distace_r(org, dat.filtered, weights)
               