# compensator

An R package for automating the compensation appraisal process for nonprofit executives. 


## Installation 

```r
devtools::install_github( 'nonprofit-open-data-collective/compensator' )
```

## Usage

```r
library( compensator )
library( knitr )

### Set up initial parameters  ---------------------------------

# Step 1, organization that is hiring the executive:

org <-
  get_org_values(
   state = "CA",
   location.type = "metro",
   total.expense = 1000000,
   ntee = "B32" )

# Step 2, get comparison orgs and calculate distances

search.criteria <-
  list(
    type.org = "RG",        # regular, advocacy, fundraising, etc.
    broad.category = "B",   # reference NTEE subsector 
    major.group = "EDU",    # reference NTEE subsector
    division = NA,
    subdivision = NA,
    univ = FALSE,
    hosp = FALSE,
    location.type = NA,
    state = state.abb52,
    total.expense = c(100000, 10000000)  # range of allowable org sizes 
  )

### METHOD A: default search function -----------------------------------

### Step 3 : Get Apprasial

appraisal2 <- get_appraisal( org, search.criteria ) 

appraisal2$suggested.salary    # predicted salary
appraisal2$suggested.range     # adjusted range based on comparison orgs 

appraisal2$reference.set %>%   # show comparison orgs 
  head() %>%
  knitr::kable()


### METHOD B - Selecting Comparison Set ------------------------

### Step 2.5 : Save comparison set and select organizations you want to use

samp <-
  select_sample(
    org = org,
    search.criteria = search.criteria )

View(samp)  # remove orgs that are not a good match

### Step 3 : Get Apprasial

appraisal <- predict_salary( samp )

appraisal2$suggested.salary    
appraisal2$suggested.range     
```
