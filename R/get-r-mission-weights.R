#' Get weights for regular mission distance 
#' 
#' @description 
#' At the moment, this is the same for all regular organizations 
#' This is currently a dummy weight set. 
#' This will need to be updated when we decide on the final weight set
#' 
#' @export 
get_r_mission_weights <- function(){
  
  #get geo weights 
  mission.weights <- data.frame(levels = c("l1", "l2", "l3", "l4"),
                            weights = c(5, 3, 1, 0.5))
  return(mission.weights)
  
}
