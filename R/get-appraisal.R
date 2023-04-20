#' Get compensation Appraisal
#' 
#' @description 
#' Wrapper function for generating entire compensation appraisal
#' 
#' @param org output from `get_org_values()`
#' @param search.criteria a list with the following items: 
#' * `type.org`: vector of the types of organization you want to include. Options are  RG, AA, MT, PA, RP, MS, MM, and/or NS. 
#' * `broad.category`: vector of broad categories you wish to include in returned data set Options are ART, EDU, ENV, HEL, HMS, IFA, PSB, REL, MMB, UNU, UNI, and/or HOS 
#' * `major.group vector`: of major groups you wish to include in returned data set. Options are A-Z.
#' * `division`: vector of divisions you wish to include. Divisions exist entirely inside major groups. We suggest you do not use this parameter if you have more than one item in `major.group`. Options are 0, 2, 3, ..., 9 (1 is not an option. 
#' * `subdivision`: vector of subdivision you wish to include. Subdivisions exist entirely inside divisions. We suggest you do not use this parameter if you have more than one item in `division`. Options are 0 - 9. 
#' * `univ`: TRUE of FALSE. Are universities to be included?
#' * `hosp`: TRUE of FALSE, Are hospitals to be included?
#' * `location.type`: vector of "metro", "suburban", "town", and/or "rural" for which city types to include
#' * `state`: vector of 2 letter state abbreviations to be included
#' * `total.expense`: vector of c(min,max) of range of total expenses to be included
#' 
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
#'          ntee = "P20")
# Step 2, Create list of search criteria 
#' search.criteria <-
#'   list(
#'     type.org = "RG",
#'     broad.category = "HMS",
#'     major.group = c("M", "N", "O", "P"),
#'     division = NA,
#'     subdivision = NA,
#'     univ = FALSE,
#'     hosp = FALSE,
#'     location.type = c("metro", "suburban"),
#'     state = c("FL", "PR", "GA", "SC", "MS", "TN", "AL"),
#'     total.expense = c(100000, 10000000)
#'   )
#'        
#' #Step 3: Get appraisal
#' appraisal <- get_appraisal(org, search.criteria) 
#' 
#' appraisal$suggested.salary
#' appraisal$suggested.range
#' reference.set <- appraisal$reference.set
#' View(reference.set)
#' }
get_appraisal <- function(org, 
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