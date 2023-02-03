#' Obtain appropriate weight set
#' 
#' Input user org characteristics, output correct weight set to be used for distance 
#' 
#' @param org list output from `get_org_values()`
#' 
#' @export
#' 
#' @examples 
get_weights <- function(org = get_org_values()){
  
  #Get geography weights 
  geo.weights <- get_geo_weights()
  
  #Get mission weights 
  if(org$location.type == "regular"){
    mission.weights <- get_r_mission_weights()
  }else if(org$location.type == "speciality" ){
    mission.weights <- get_s_mission_weights()
  }
  
  weights <- list(geo.weights, mission.weights)
}
