#' Get weights for geographic distance 
#' 
#' @description 
#' At the moment, this is the same for all organizations 
#' This is currently a dummy weight set. 
#' This will need to be updated when we decide on the final weight set
#' 
#' @export 
get_geo_weights <- function(){
  
  #get geo weights 
  geo.weights <- data.frame(levels = c("l1", "l2", "l3"),
                            weights = c(5, 3, 0.5))
  return(geo.weights)
  
}
