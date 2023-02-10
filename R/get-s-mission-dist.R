#' get_s_mission_dist
#'
#' Calculate mission distances for specialty organizations
#'
#'
#' @format ## `get_s_mission_dist`
#' @param org1 output of `get_org_values()` for first org
#' @param org2 output of `get_org_values()` for second org
#' @param s.mission.weights mission.weights from output of `get_weights()`
#' 
#' @return mission distance distance of two orgs
#' @export
get_s_mission_dist <- function(org1, org2, s.mission.weights){
  
  
  if(org2$type.org == "regular"){
    return(1)
  }else{
    ## Regular Mission distance 
    # Level 1: Two Digit (0, 2-9)
    m1 <- s.mission.weights$weight[1] *
      (org1$two.digit != org2$two.digit)
    
    # Level 2: broad.category (1-12)
    m2 <- s.mission.weights$weight[2] *
      (org1$broad.category != org2$broad.category)
    
    # Level 3: Major Group (Letters)
    m3 <- s.mission.weights$weight[2] *
      ((org1$broad.category != org2$broad.category) | #cant compare broad category if major group doesnt match
         (org1$major.group != org2$major.group))
    
    # Level 4: tens
    m4 <- s.mission.weights$weight[2] *
      ((org1$broad.category != org2$broad.category) | #cant compare broad category if major group doesnt match
         (org1$major.group != org2$major.group)  | #cant compare tens if major group isnt the same
         (org1$tens != org2$tens) )
    
    # Level 5 two.digit.s
    m5 <- s.mission.weights$weight[2] *
      ((org1$broad.category != org2$broad.category) | #cant compare broad category if major group doesnt match
         (org1$major.group != org2$major.group)  | #cant compare tens if major group isnt the same
         (org1$tens != org2$tens) | #cant compare ones place if tens place is the same
         (org1$two.digit.s != org2$two.digit.s))
    
    # Final mission distance 
    s.mission.dist <- m1 + m2 + m3 + m4 + m5
    
    return(s.mission.dist)
  }
}