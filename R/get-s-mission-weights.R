#' Get weights for specality mission distance 
#' 
#' @description 
#' At the moment, this is the same for all specality organizations 
#' This is currently a dummy weight set. 
#' This will need to be updated when we decide on the final weight set
#' 
#' @return 
#' Data frame with 3 levels and 3 weights needed to calculated geographic distances.
#' 
#' @export 
get_s_mission_weights <- function(){
  
  #get geo weights 
  mission.weights <- data.frame(levels = c("l1", "l2", "l3", "l4", "l5"),
                                weights = c(5, 3, 1, 0.5, 0.25))
  return(mission.weights)
  
}
