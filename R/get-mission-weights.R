#' Get weights for regular mission distance 
#' 
#' @description 
#' Weights for mission distance 
#' 
#' @return 
#' Data frame with 5 levels and 5 weights needed to calculated mission distances.
#' 
#' @export 
get_mission_weights <- function(){
  
  #get geo weights 
  mission.weights <- data.frame(levels = c("org.type", 
                                           "broad.category", 
                                           "major.group", 
                                           "division",
                                           "subdivision"),
                                weights = c(4, 4, 3, 2, 1))
  return(mission.weights)
  
}
