#' get_r_mission_dist
#'
#' Calculate mission distances for regular organizations
#'
#'
#' @format ## `get_r_mission_dist`
#' 
#' @return Geographic distance of two orgs
#' @export
get_r_mission_dist <- function(org1, org2, r.mission.weights){
  
  #org1 <- org
  #org2 <- dat.filtered[1, ]
  
  ## Regular Mission distance 
  # Level 1: Broad Category
  m1 <- r.mission.weights$weight[1] *
    (org1$BroadCategory != org2$BroadCategory)
  
  # Level 2: Major Group (letter)
  m2 <- r.mission.weights$weight[2] *
    (org1$MajorGroup != org2$MajorGroup)
  
  # Level 3: match on both (letter + tens)
  m3 <- r.mission.weights$weight[2] *
    ((org1$MajorGroup != org2$MajorGroup) |
    (org1$tens != org2$tens))
  
  # Level 4: match on all (letter + tens + ones)
  m4 <- r.mission.weights$weight[2] *
    ((org1$MajorGroup != org2$MajorGroup) |
       (org1$tens != org2$tens) | 
       (org1$ones != org2$ones))
  
  # Final mission distance 
  r.mission.dist <- m1 + m2 + m3 + m4
  
  return(r.mission.dist)
}
