#' Select comparison set for appraisal
#' 
#' @description
#' `select_sample` is used to select all other nonprofits that match a specified
#' criteria, as well as calculate their respective distances from a reference 
#' organization using `calc_dist`. Generally, the reference organization is the
#' nonprofit for which the user is obtaining an appraisal. This is Step 2 in 
#' the Appraisal Process Vignette. 
#' 
#' See Appraisal Process Vignette for detailed explanation on how distance 
#' between nonprofits is calculated.
#' 
#' @param org List output from `get_org_values()`
#' @param search.criteria A list with the following elements: 
#' * `type.org`: vector of the types of organization you want to include. Options are  RG, AA, MT, PA, RP, MS, MM, and/or NS. 
#' * `broad.category`: vector of broad categories you wish to include in returned data set Options are ART, EDU, ENV, HEL, HMS, IFA, PSB, REL, MMB, UNU, UNI, and/or HOS 
#' * `major.group`: vector of major groups you wish to include in returned data set. Options are A-Z.
#' * `division`: vector of divisions you wish to include. Divisions exist entirely inside major groups. We suggest you do not use this parameter if you have more than one item in `major.group`. Options are 0, 2, 3, ..., 9 (1 is not an option. 
#' * `subdivision`: vector of subdivision you wish to include. Subdivisions exist entirely inside divisions. We suggest you do not use this parameter if you have more than one item in `division`. Options are 0 - 9. 
#' * `univ`: TRUE of FALSE. Are universities to be included?
#' * `hosp`: TRUE of FALSE, Are hospitals to be included?
#' * `location.type`: vector of "metro", "suburban", "town", and/or "rural" for which city types to include
#' * `state`: vector of 2 letter state abbreviations to be included
#' * `total.expense`: vector of `c(min,max)` of range of total expenses to be included
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
#' * `ntee`: Original NTEE code 
#' * `new.code`: New NTEE code
#' * `org.type, `broad.category`, `major.group`, `division`, `subdivision`, `univ`, `hosp`: Parts of the dissagregated NTEE code. See ... for details.
#' * `expense.dist`: Total Expense distance between the nonprofit and the reference organization
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
#'   list(
#'     type.org = "RG",
#'     broad.category = "EDU",
#'     major.group = "B",
#'     division = 2:9,
#'     subdivision = NA,
#'     univ = FALSE,
#'     hosp = FALSE,
#'     location.type = NA,
#'     state = c("FL", "GA", "SC", "MS", "AL", "PR"),
#'     total.expense = c(1.2e5, 1.2e7)
#'   )
#'       
#' samp <- select_sample(input.org, search.criteria)
select_sample <- function(org = get_org_values(state = "AL",
                                               location.type = "rural",
                                               total.expense = 100000,
                                               ntee = "P20"), 
                          search.criteria = list(
                                              type.org = "RG",
                                              broad.category = NA,
                                              major.group = LETTERS,
                                              division = NA,
                                              subdivision = NA,
                                              univ = FALSE,
                                              hosp = FALSE,
                                              location.type = c("rural", "town"),
                                              state = state.abb52,
                                              total.expense = c(1000000, 10000000)
                                            )){
  
 
  
  #Should probably check if elements of org and search.criteria are correct. 
  
  ## Step 1: Find all orgs that match search criteria 
  comparison.orgs <- 
    dat_filtering(
      type.org = search.criteria$type.org,
      broad.category = search.criteria$broad.category,
      major.group = search.criteria$major.group, 
      division = search.criteria$division,
      subdivision = search.criteria$subdivision,
      univ = search.criteria$univ,
      hosp = search.criteria$hosp, 
      location.type = search.criteria$location.type, 
      state = search.criteria$state, 
      total.expense = search.criteria$total.expense)
  
  ## Step 2: Get Appropriate weights set
  weights <- get_weights()
  
  ## Step 3: Calculate distances 
  comparison.orgs.with.dist <- calc_distance(org, comparison.orgs, weights)
  
  ## Step 4 Thresholding - for now just take the 1,000 closest organizations
  # This will eventually need to be updated to have a more dynamic threshold 
  
  comparison.orgs.threshold <- comparison.orgs.with.dist[comparison.orgs.with.dist$rank <= 1000, ]
  
  
  ## Step 5 Match EIN's of comparison.orgs to those in nonprofits to return useful information to the user
  #remove columns from nonprofits that are also in comparison.orgs to aviod repeat information in the merge

  # Need to make a decision about what information we show them at this stage.
  ret <-  dplyr::inner_join(
    nonprofits %>% dplyr::select(-c(univ, hosp, total.expense, state, location.type, ntee, new.code)), 
    comparison.orgs.threshold, 
    by = "EIN")  %>%
    dplyr::arrange(rank)
  
  return(ret)
}

