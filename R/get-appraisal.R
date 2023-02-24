#' Get compensation Appraisal
#' 
#' @description 
#' Wrapper function for generating entire compensation appraisal
#' 
#' @param org.characteristics output from `get_org_values()`
#' @param search criteria a list with ...... NEED TO UPDATE - see `select_sample`
#' 
#' @return
#' A list with 3 objects 
#' 1. `suggested.salary`: a numeric of the suggested CEO compensation for the input organization
#' 2. `suggested.range`: vector of minimum and maximum suggested salary range
#' 3. `reference.set`: a data frame of all nonprofits used to calculated the suggested
#' CEO compensation with the following variables: 
#' * `EIN`: IRS Employer Identification Number 
#' * `form.year`: IRS filing year from which this nonprofits information was obtained
#' * `name`: Name of the nonprofit
#' * `total.employee`: Total number of employees at the nonprofit
#' * `gross.receipts`: Gross receipts reported for the year
#' * `total.assests`: Total assets reported for the year
#' * `total.expense`: Total expenses reported for the year
#' * `ceo.compensation`: Total CEO compensation reported for the year
#' * `gender`: Imputed gender of the CEO
#' * `zip5`: 5 digit zip code of where the nonprofit is located
#' * `state`: Two letter abbreviation of the state where the nonprofit is located
#' * `location.type`: Either "metro" or "rural" for type of location the nonprofit is in
#' * `ntee`: Original ntee code 
#' * `broad.category`, `major.group`, `type.org`, `two.digit`, `two.digit.s`, `tens`, `ones`, `us.state`, `univ`, `hosp`: Parts of the dissagregated NTEE code. See ... for details.
#' * `log.expense.dist`: Total Expense distance between the nonprofit and the reference organization
#' * `mission.dist`: Mission distance between the nonprofit and the reference organization
#' * `geo.dist`: Geographic distance between the nonprofit and the reference organization
#' * `total.dist`: Total distance between the nonprofit and the reference organization
#' * `rank`: Ranking of all nonprofits that match the reference set from closest to farthest from the reference organization.
#' * `dist.std`: standardized total distance
#' * `weight`: weight used to calculated weighted average of `suggested.salary`
#' * `residual.percent`: the residual of that observation as a percent of the expected salary.
#' * `fitted.values`: is `suggested.salary`(1+`residual.percent`)
#' 
#' See ... Vignette for details on how these values are calculated. 
#' @export
#' @examples 
#' 
#' \dontrun{
#' # Step 1: Create list of organization characteristics 
#' org <- get_org_values(
#'          state = "FL",
#'          location.type = "metro",
#'          total.expense = 1000000,
#'          ntee = "B20")
# Step 2, Create list of search criteria 
#' search.criteria <-
#'   list(broad.category = 1:2, 
#'        major.group = base::LETTERS, 
#'        tens = 2:9, 
#'        type.org = "regular",
#'        univ = FALSE,
#'        hosp = FALSE, 
#'        location.type = "both", 
#'        state = c("DC", "KS", "CA", "DE", "MD", "FL"), 
#'        total.expense = c(0, Inf) )
#'        
#' #Step 3: Get appraisal
#' appraisal2 <- get_appraisal(org, search.criteria) 
#' 
#' appraisal2$suggested.salary
#' appraisal2$suggested.range
#' reference.set <- appraisal2$reference.set
#' View(reference.set)
#' }
get_appraisal <- function(org.characteristics, 
                          search.criteria){
  
  # get orgs that match search criteria + calculated distance
  samp <- select_sample(org = org, search.criteria = search.criteria)
  
  #get appraisal
  appraisal <- predict_salary(samp)
  
  ret <- list(suggested.salary = appraisal$point.value,
              suggested.range = appraisal$salary.range,
              reference.set = appraisal$sample)
  
  
  return(ret)
}