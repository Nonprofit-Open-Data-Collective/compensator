#' calc_distance
#'
#' @description 
#' Calculate distances between one organization, `org` and all other organizations in
#' `comparison.org`. See vignette for detailed information on calculating distances. 
#' 
#' Mainly used as internal function in `select_sample`, but can be used on its own
#' Threshold still needs to be added
#'
#'
#' @param org output from `get_org_values()`
#' @param comparison.orgs output from `dat_filtering()`
#' @param weights output from `get_weights()`
#' 
#' @return input of `comparison.orgs` with new columns with the distance from each organization to the input `org`.
#' 
#' @keywords calc_distance
#' @export
#' @examples 
#' 
#' #Specify Organization Characteristics
#' org <- get_org_values(state = "CA",
#' location.type = "metro",
#' total.expense = 1000000,
#' ntee = "B32")
#' 
#' # Specify Search Criteria 
#' search.criteria <-
#'   list(
#'     type.org = base::ifelse(org$type.org == "RG", "RG", c("AA", "MT", "PA", "RP", "MS", "MM", "NS")),
#'     broad.category = base::ifelse(org$type.org == "RG", org$broad.category, NA),
#'     major.group = base::ifelse(org$type.org == "RG", org$major.group, NA),
#'     division = NA,
#'     subdivision = NA,
#'     univ = FALSE,
#'     hosp = FALSE,
#'     location.type = NA,
#'     state = state.abb52,
#'     total.expense = c(0.1*org$total.expense, 10*org$total.expense)
#'   )
#' 
#' # Obtain the comparison set 
#' comparison.orgs <- 
#'   dat_filtering(
#'     type.org = search.criteria$type.org,
#'     broad.category = search.criteria$broad.category,
#'     major.group = search.criteria$major.group, 
#'     division = search.criteria$division,
#'     subdivision = search.criteria$subdivision,
#'     univ = search.criteria$univ,
#'     hosp = search.criteria$hosp, 
#'     location.type = search.criteria$location.type, 
#'     state = search.criteria$state, 
#'     total.expense = search.criteria$total.expense)
#' 
#' # Obtain the weights 
#' weights <- get_weights()
#' 
#' # Calculate distances 
#' comparison.orgs.with.dist <- calc_distance(org, comparison.orgs, weights)
calc_distance <- function(org, comparison.orgs, weights){
  
  ### Checks that need to be added: ----------------------------------
  # org is get_org_values output
  # comparison.orgs is select_samples
  # weight set is get_weights
  
  ## Set up data table for calculations --------------------------------
  #nothing needed at the moment

  
  #needed values
  A <- 3 #number of attributes to compare 
  n <- nrow(comparison.orgs) #number of points in the filtered data set

  #initialize storage
  D <- as.data.frame(matrix(0, nrow = n, ncol = A) )
  colnames(D) <- c("total.expense", "geography", "mission")
  

  
  ## Getting weights -----------------------------------------
  geo.weights <- weights$geo
  mission.weights <- weights$mission

  # ensure it's standardizing - we currently are not standardizing the weights, 
  # but I left this in here incase we want to go back to standardizing in the future
  # geo.weights$weights <- geo.weights$weights / sum(geo.weights$weights )
  # mission.weights$weights <- mission.weights$weights / sum(mission.weights$weights )

  
  ## Get distances -----------------------------------------------
  
  for(i in 1:n){
    
    compare.org <- comparison.orgs[i, ]
    
    ## expense distance
    if(is.na(compare.org$total.expense)){
      D[i, "total.expense"] <- NA #will replace with max once all calculations have been done
    }else{
      D[i, "total.expense"] <- log(abs(compare.org$total.expense - org$total.expense), base = 10)  
    }
    
    ## Geo distance 
    D[i, "geography"] <- get_geo_dist(org, compare.org, geo.weights)
    
    ## Mission distance 
    D[i, "mission"] <- get_mission_dist(org, compare.org, mission.weights)
    
  }
  
  
  
  #get max of total.expense.dist
  max.expense.dist <- max(D[, "total.expense"], na.rm = TRUE)
  
  ## Add distances to comparison.orgs table 
  #add distances
  colnames(D) <- c("expense.dist", "geo.dist", "mission.dist")
  comparison.orgs <- cbind(comparison.orgs, D)
  
  #wrangle return table to look nice
  ret <- comparison.orgs %>% 
    #replace NA in expense.dist with max.expense.dist
    dplyr::mutate(expense.dist = ifelse(is.na(expense.dist), max.expense.dist, expense.dist)) %>% 
    # scale
    dplyr::mutate(across(c(expense.dist, geo.dist, mission.dist),  ~ 1/3*100*scale(., center = FALSE)[,1]))  %>%
    #get total distance
    dplyr::rowwise() %>%
    dplyr::mutate( total.dist = sum(c(expense.dist, geo.dist, mission.dist ))) %>%
    #get rank for threshold
    dplyr::ungroup() %>%
    dplyr::arrange(  total.dist  ) %>%
    dplyr::mutate(  rank = dplyr::row_number()  ) 
  
  
  return(ret)
  
}
