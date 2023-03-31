#' Obtain appropriate weight set
#' 
#' Input user org characteristics, output correct weight set to be used for distance 
#' 
#' @return A list with 2 data frames. `geo` is the geographic distance weights, 
#' and `mission` is for the mission distance weights.
#' 
#' @export
#' 
get_weights <- function(){
  
  weights <- list(geo = get_geo_weights(), 
                  mission = get_mission_weights())
  
  return(weights)
}
