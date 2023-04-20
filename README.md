# compensator

An R package for estimating compensation of nonprofit executives. 


## Installation 

```r
devtools::install_github( 'nonprofit-open-data-collective/compensator' )
```

## Usage

```r
library(compensator)


### Set up initial parameters  ---------------------------------
# Step 1, get org info 
org <- get_org_values(state = "CA",
                      location.type = "metro",
                      total.expense = 1000000,
                      ntee = "B32")

# Step 2, get comparison orgs and calculate distances
search.criteria <-
  list(
    type.org = base::ifelse(org$type.org == "RG", "RG", c("AA", "MT", "PA", "RP", "MS", "MM", "NS")),
    broad.category = base::ifelse(org$type.org == "RG", org$broad.category, NA),
    major.group = base::ifelse(org$type.org == "RG", org$major.group, NA),
    division = NA,
    subdivision = NA,
    univ = FALSE,
    hosp = FALSE,
    location.type = NA,
    state = state.abb52,
    total.expense = c(0.1*org$total.expense, 10*org$total.expense)
  )

### Method A: Using wrapper function -----------------------------------
### Step 3 : Get Apprasial
appraisal2 <- get_appraisal(org, search.criteria) 

appraisal2$suggested.salary
appraisal2$suggested.range
reference.set <- appraisal2$reference.set
View(reference.set)


### Method B - Selecting Comparison Set ------------------------
### Step 2.5 : Save comparison set and select organizations you want to use

#get sample with distance
samp <- select_sample(org = org, search.criteria = search.criteria)


### Step 3 : Get Apprasial
# get appraisal
appraisal <- predict_salary(samp)
appraisal

```
