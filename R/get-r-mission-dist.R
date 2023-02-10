#' get_r_mission_dist
#'
#' Calculate mission distances for regular organizations
#'
#'
#' @format ## `get_r_mission_dist`
#' @param org1 output of `get_org_values()` for first org
#' @param org2 output of `get_org_values()` for second org
#' @param r.mission.weights mission.weights from output of `get_weights()`
#' 
#' @return mission distance of two orgs
#' @export
get_r_mission_dist <- function(org1, org2, r.mission.weights){
  
  
  if(org2$type.org == "speciality"){
    return(1)
  }else{
  ## Regular Mission distance 
  # Level 1: Broad Category
  m1 <- r.mission.weights$weight[1] *
    (org1$broad.category != org2$broad.category)
  
  # Level 2: Major Group (letter)
  m2 <- r.mission.weights$weight[2] *
    (org1$major.group != org2$major.group)
  
  # Level 3: match on both (letter + tens)
  m3 <- r.mission.weights$weight[2] *
    ((org1$major.group != org2$major.group) | #cant compare tens if letter doesnt match
    (org1$tens != org2$tens))
  
  # Level 4: match on all (letter + tens + ones)
  m4 <- r.mission.weights$weight[2] *
    ((org1$major.group != org2$major.group) | #cant compare ones if tens and letter doesnt match
       (org1$tens != org2$tens) | 
       (org1$ones != org2$ones))
  
  # Final mission distance 
  r.mission.dist <- m1 + m2 + m3 + m4
  
  return(r.mission.dist)
  }
}
