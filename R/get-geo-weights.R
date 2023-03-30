#' Get weights for geographic distance 
#' 
#' @description 
#' At the moment, this is the same for all organizations 
#' 
#' See vignette for how these values are determined. 
#' 
#' Level one represents 
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
