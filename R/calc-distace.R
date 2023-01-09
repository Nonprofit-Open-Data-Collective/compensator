#' calc_distance_r
#'
#' Calculate distances for regular organizations
#'
#'
#' @format ## `calc_distance_r`
#' 
#' @return dat.filtered with appended distances 
#' @export
calc_distace_r <- function(org, dat.filtered, weights){
  
  ### Checks that need to be added: ----------------------------------
  # vaild org.ntee code 
  
  
  
  ## Set up data table for calculations --------------------------------
  dat.filtered <- 
    dat.filtered %>%
    dplyr::mutate( log.expense = log( TotalExpense+1, base=10 ))

  
  #needed values
  A <- 3 #number of attributes to compare 
  n <- nrow(dat.filtered) #number of points in the filtered data set
  log.expense.range <- max(dat.filtered$log.expense) -  min(dat.filtered$log.expense) #range
  
  #initialize storage
  D <- as.data.frame(matrix(0, nrow = n, ncol = A) )
  colnames(D) <- c("logTotalExpense", "Geography", "Mission")
  
  ## Get information from Org --------------------------------
  org$us.state <- org$State != "PR"
  org <- cbind(org, get_new_ntee(org$NTEE))
  
  ## Getting weights -----------------------------------------
  geo.weights <- weights$geo
  r.mission.weights <- weights$r.mission

  # ensure it's normalize 
  geo.weights$weight <- geo.weights$weight / sum(geo.weights$weight )
  r.mission.weights$weight <- r.mission.weights$weight / sum(r.mission.weights$weight )

  
  ## Get distances -----------------------------------------------
  
  for(i in 1:n){
    
    compare.org <- dat.filtered[i, ]
    
    ## log.expense Distance
    if(is.na(compare.org$TotalExpense[i])){
      D[i, "logTotalExpense"] <- 1
    }else{
      D[i, "logTotalExpense"] <- abs(compare.org$log.expense[i] - log(org$TotalExpense, 10)) / log.expense.range
    }
    
    ## Geo Distance 
    D[i, "Geography"] <- get_geo_dist(org, compare.org, geo.weights)
    
    ## R Mission Distance 
    if(compare.org$type.org == "S"){ # if comparison org is a specialty org, assign maximum distance (could change this later if wanted)
      D[i, "Mission"] <- 1
    }else{
      D[i, "Mission"] <- get_r_mission_dist(org, compare.org, r.mission.weights)
    }
    
  }
  
  ## Add distances to dat.filtered table 
  dat.filtered <- 
    dat.filtered %>%
    dplyr::select( -c(log.expense)  ) %>%
    dplyr::mutate(  TotalDist = rowSums(D) / A  ) %>%
    dplyr::mutate(  LogExpenseDist = D[, 1]  ) %>%
    dplyr::mutate(  GeoDist = D[, 2]  ) %>%
    dplyr::mutate(  RMissionDist = D[, 3]  ) %>%
    dplyr::arrange(  TotalDist  ) %>%
    dplyr::mutate(  Rank = dplyr::row_number()  ) %>%
    dplyr::relocate(  Rank  )
  
  #here is where we will threshold eventually 

  
  return(dat.filtered)
  
}
