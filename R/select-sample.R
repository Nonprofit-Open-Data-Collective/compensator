#' Select Sample 
#' 
#' @description
#' user inputs org characteristics and search criteria and we return top N closest organizations 
#' 
#' @param org List output from `get_org_values()`
#' @param search.criteria List with the following elements: broad.category, major.group, decile, type.org, univ, hosp, location.type, state, total.expense
#' 
#' @export
#' @examples 
select_sample <- function(org = get_org_values(state = "AL",
                                               location.type = "rural",
                                               total.expense = 100000,
                                               ntee = "B20"), 
                          search.criteria = list(broad.category = 1:12, 
                                                 major.group = base::LETTERS, 
                                                 decile = 2:9, 
                                                 type.org = "regular", 
                                                 univ = FALSE,
                                                 hosp = FALSE, 
                                                 location.type = "both", 
                                                 state = c(datasets::state.abb, "DC", "PR"), 
                                                 total.expense = c(0, Inf) )){
  
  ## Tests checks to stop 
  # org input 
  org.good <- all(
    sort(names(org)) == sort(c("total.expense", "state", "location.type", "NTEE",
                             "BroadCategory", "MajorGroup", "two.digit", "type.org",
                             "two.digit.s",   "tens", "ones","hosp", "univ")))
  
  if(!org.good){
    stop("The org parameter is not formatted correctly. Please check the documentation of `select_sample`.")
  }
  
  # search.criteria
  search.good <- all(
    sort(names(search.criteria)) == sort(c("broad.category", "major.group", "decile", 
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
                  decile = search.criteria$decile, 
                  type.org = search.criteria$type.org, 
                  univ = search.criteria$univ,
                  hosp = search.criteria$hosp, 
                  location.type = search.criteria$location.type, 
                  state = search.criteria$state, 
                  total.expense = search.criteria$total.expense)
  
  ## Step 2: Get Appropriate weights set
  weights <- get_weights(org)
  
  
  return(comparison.orgs)
}

