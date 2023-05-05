#' Get weights for mission distance 
#' 
#' @description 
#' Weights for mission distance. See Appraisal Process Vignette for the interpretation
#' and usage of these values. 
#' 
#' This is primarily used as an internal function for `get_mission_dist`. `get_mission_weights` 
#' is written as a separate function from `get_mission_dist` to allow the user to easily
#' change the weights to their own desired values. 
#' 
#' @return 
#' Data frame with 5 levels and 5 weights needed to calculated mission distances.
#' 
#' @export 
get_mission_weights <- function(){
  
  #specify weights 
  mission.weights <- data.frame(levels = c("org.type", 
                                           "broad.category", 
                                           "major.group", 
                                           "division",
                                           "subdivision"),
                                weights = c(4, 4, 3, 2, 1))
  return(mission.weights)
  
}
