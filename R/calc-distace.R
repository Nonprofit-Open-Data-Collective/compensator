#' calc_distance_r
#'
#' @description 
#' Calculate distances between one organization and all other organizations
#' Threshold still needs to be added
#'
#'
#' @param org output from `get_org_values()`
#' @param comparison.orgs output from `dat_filtering()`
#' @param weights output from `get_weights()`
#' 
#' @return comparison.orgs with appended distances 
#' @export
calc_distace <- function(org, comparison.orgs, weights){
  
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
  colnames(D) <- c("log.total.expense", "geography", "mission")
  

  
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
    
    ## log.expense Distance
    if(is.na(compare.org$total.expense)){
      D[i, "log.total.expense"] <- NA #will replace with max once all calculations have been done
    }else{
      D[i, "log.total.expense"] <- log(abs(compare.org$total.expense - org$total.expense), base = 10)  
    }
    
    ## Geo Distance 
    D[i, "geography"] <- get_geo_dist(org, compare.org, geo.weights)
    
    ## Mission Distance 
    if(org$type.org == "regular"){
      D[i, "mission"] <- get_r_mission_dist(org, compare.org, mission.weights)
    }else if(org$type.org == "speciality"){
      D[i, "mission"] <- get_s_mission_dist(org, compare.org, mission.weights)
    }
    
  }
  
  
  
  #get max of log.total.expense.dist
  max.expense.dist <- max(D[, "log.total.expense"])
  
  ## Add distances to comparison.orgs table 
  #add distances
  colnames(D) <- c("log.expense.dist", "geo.dist", "mission.dist")
  comparison.orgs <- cbind(comparison.orgs, D)
  
  #wrangle return table to look nice
  ret <- comparison.orgs %>% 
    #replace NA in log.expense.dist with max.expense.dist
    dplyr::mutate(log.expense.dist = ifelse(is.na(log.expense.dist), max.expense.dist, log.expense.dist)) %>% 
    #get total distance
    dplyr::rowwise() %>%
    dplyr::mutate( total.dist = mean(c(log.expense.dist, geo.dist, mission.dist ))) %>%
    #get rank for threshold
    dplyr::ungroup() %>%
    dplyr::arrange(  total.dist  ) %>%
    dplyr::mutate(  rank = dplyr::row_number()  ) 
  
  
  return(ret)
  
}
