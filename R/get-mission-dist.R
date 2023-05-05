#' Calculate mission distance between two nonprofits
#'
#' @description 
#' Calculate mission distance between two nonprofits. Primarily as an internal 
#' function in `calc_distance`, but can be used on its own. See Appraisal Process
#' Vignette for detailed information on how this value is calculated.
#'
#'
#' @format ## `get_mission_dist`
#' @param org1 output of `get_org_values()` for first org
#' @param org2 output of `get_org_values()` for second org
#' @param mission.weights mission.weights from output of `get_weights()`
#' 
#' @return Numeric value of the geographic distance of two nonprofits.
#' @export
#' 
#' @examples
#' org1 <- get_org_values(
#'   state = "IL", 
#'   location.type = "metro",
#'   total.expense = 500000,
#'   ntee = "Q1120")
#'   
#' org2 <- get_org_values(
#'   state = "OH", 
#'   location.type = "suburban",
#'   total.expense = 300000,
#'   ntee = "A35")
#'   
#' mission.weights <- get_mission_weights()
#'   
#' get_mission_dist(org1, org2, mission.weights)
#'
get_mission_dist <- function(org1, org2, mission.weights){
  
  ## Regular Mission distance
  # Level 1: Org Type
  m1 <- mission.weights$weights[1] * 
    (org1$type.org != org2$type.org)
  
  # Level 2: Broad Category
  m2 <- mission.weights$weights[2] * 
    (org1$broad.category != org2$broad.category)
  
  # Level 3: Major Group (letter)
  m3 <- mission.weights$weights[3] *
    (org1$major.group != org2$major.group)
  
  # Level 4: Division 
  m4 <- mission.weights$weights[4] * 
    ifelse(m3 == 0, #if they have the same major group
           org1$division != org2$division, #then compare divisions
           1) #otherwise is not a match in this category 
  
  # Level 5: SubDivision 
  m5 <- mission.weights$weights[5] *
    ifelse(m4 == 0, #if they have the same division
           org1$subdivision != org2$subdivision, #then compare subdivisions
           1)  #otherwise is not a match in this category 
      
  #final mission distance
  mission.dist <- log(m1 + m2 + m3 + m4 + m5 + 1, base = 10)
  
  return(mission.dist)
}
