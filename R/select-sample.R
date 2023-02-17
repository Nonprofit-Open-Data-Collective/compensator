#' Select Sample 
#' 
#' @description
#' STILL NEED TO EDIT
#' `select_sample` is used to select all other nonprofits that match a specified criteria, 
#' as well as calculate their respective distances from a reference organization. 
#' 
#' See ... Vignette for detailed explanation on how distance between nonprofits is calculated.
#' 
#' @param org List output from `get_org_values()`
#' @param search.criteria List with the following elements: `broad.category`, `major.group`, `tens`, `type.org`, `univ`, `hosp`, `location.type`, `state`, `total.expense`. See example for formatting
#' 
#' @return A data frame with all nonprofits that match the search criteria. 
#' Each nonprofit has the following variables:
#' 
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
#' 
#' @export
#' @examples
#' 
#' input.org <- 
#'   get_org_values(state = "FL",#
#'                  location.type = "rural",
#'                  total.expense = 1.2e6,
#'                  ntee = "B20")
#' 
#' search.criteria <-
#'  list(broad.category = 1:2, 
#'       major.group = base::LETTERS, 
#'       tens = 2:9, 
#'       type.org = "regular", 
#'       univ = FALSE,
#'       hosp = FALSE, 
#'       location.type = "both", 
#'       state = c("DC", "KS", "CA", "DE", "MD", "FL"), 
#'       total.expense = c(1e5, 9.5e6) )
#'       
#' samp <- select_sample(input.org, search.criteria)
select_sample <- function(org = get_org_values(state = "AL",
                                               location.type = "rural",
                                               total.expense = 100000,
                                               ntee = "B20"), 
                          search.criteria = list(broad.category = 1:12, 
                                                 major.group = base::LETTERS, 
                                                 tens = 2:9, 
                                                 type.org = "regular", 
                                                 univ = FALSE,
                                                 hosp = FALSE, 
                                                 location.type = "both", 
                                                 state = c(datasets::state.abb, "DC", "PR"), 
                                                 total.expense = c(0, Inf) )){
  
  ## Tests checks to stop 
  # org input 
  org.good <- all(
    sort(names(org)) == sort(c("total.expense", "state", "location.type", "ntee",
                             "broad.category", "major.group", "two.digit", "type.org",
                             "two.digit.s", "tens", "ones","hosp", "univ")))
  
  if(!org.good){
    stop("The org parameter is not formatted correctly. Please check the documentation of `select_sample`.")
  }
  
  # search.criteria
  search.good <- all(
    sort(names(search.criteria)) == sort(c("broad.category", "major.group", "tens", 
                                      "type.org", "univ", "hosp", "location.type",
                                      "state", "total.expense")))
  if(!search.good){
    stop("The search.critera parameter is not formatted correctly. Please check the documentation of `select_sample`.")
  }
  
  #Should probably check if elements of org and search.criteria are correct. 
  
  ## Step 1: Find all orgs that match search criteria 
  comparison.orgs <- 
    dat_filtering(broad.category = search.criteria$broad.category, 
                  major.group = search.criteria$major.group, 
                  tens = search.criteria$tens, 
                  type.org = search.criteria$type.org, 
                  univ = search.criteria$univ,
                  hosp = search.criteria$hosp, 
                  location.type = search.criteria$location.type, 
                  state = search.criteria$state, 
                  total.expense = search.criteria$total.expense)
  
  ## Step 2: Get Appropriate weights set
  weights <- get_weights(org)
  
  ## Step 3: Calculate distances 
  comparison.orgs.with.dist <- calc_distace(org, comparison.orgs, weights)
  
  ## Step 4 Thresholding - for now just take the 1,000 closest organizations
  # This will eventually need to be updated to have a more dynamic threshold 
  
  comparison.orgs.threshold <- comparison.orgs.with.dist[comparison.orgs.with.dist$rank <= 1000, ]
  
  
  ## Step 5 Match EIN's of comparison.orgs to those in nonprofits to return useful information to the user
  #remove columns from nonprofits that are also in comparison.orgs to aviod repeat information in the merge

  # Need to make a decision about what information we show them at this stage.
  ret <-  dplyr::inner_join(
    nonprofits %>% dplyr::select(-c(univ, hosp, total.expense, state, location.type, ntee)), 
    comparison.orgs.threshold, 
    by = "EIN")  %>%
    dplyr::arrange(rank)
  
  return(ret)
}

