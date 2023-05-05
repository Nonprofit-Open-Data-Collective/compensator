#' Obtain appropriate weight set
#' 
#' @description 
#' Obtain weight set needed to calculate distances between nonprofits. This is 
#' a wrapper function for `get_geo_weights` and `get_mission_weights`. This is 
#' function is used in `calc_dist`. `get_weights` is written as a separate function
#' from `calc_dist` to allow the user to easily change the weights to their own 
#' desired values.
#' 
#' See Appraisal Process Vignette for detailed information about these values. 
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
