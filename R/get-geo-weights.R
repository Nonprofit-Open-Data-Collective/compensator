#' Get weights for geographic distance 
#' 
#' @description 
#' Weights for geographic distance. See Appraisal Process Vignette for the interpretation
#' and usage of these values.  
#' 
#' This is primarily used as an internal function for `get_geo_dist`. `get_geo_weights`
#' is written as a separate function from `get_geo_dist` to allow the user to easily
#' change the weights to their own desired values. 
#' 
#' @return 
#' Data frame with 2 levels and 2 weights needed to calculated geographic distances.
#' 
#' @export 
get_geo_weights <- function(){
  
  #get geo weights 
  geo.weights <- data.frame(levels = c("l1", "l2"),
                            weights = c(1, 1))
  return(geo.weights)
  
}
