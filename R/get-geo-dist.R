#' get_geo_dist
#'
#' Calculate distances for regular organizations
#'
#'
#' @format ## `get_geo_dist`
#' @param org1 output of `get_org_values()` for first org
#' @param org2 output of `get_org_values()` for second org
#' @param geo.weights geo.weights from output of `get_weights()`
#' 
#' @return Geographic distance of two orgs
#' @export
#' 
#' @examples 
#' org1 <- get_org_values(
#'   state = "IL", 
#'   location.type = "metro",
#'   total.expense = 500000,
#'   ntee = "A20")
#'   
#' org2 <- get_org_values(
#'   state = "OH", 
#'   location.type = "suburban",
#'   total.expense = 300000,
#'   ntee = "A20")
#'   
#' geo.weights <- get_geo_weights()
#'   
#' get_geo_dist(org1, org2, geo.weights)
#'   
get_geo_dist <- function(org1, org2, geo.weights){
  
  #add fail safes 

  
  ## Geographic distance 
  
  # Level 1 - Making binary strings for values 
  l1 <- dplyr::case_when(
    org1$location.type == "metro" ~ c(1,1,1), 
    org1$location.type == "suburban" ~ c(1,1,0), 
    org1$location.type == "town" ~ c(1,0,0),
    org1$location.type == "rural" ~ c(0,0,0))
  l2 <- dplyr::case_when(
    org2$location.type == "metro" ~ c(1,1,1), 
    org2$location.type == "suburban" ~ c(1,1,0), 
    org2$location.type == "town" ~ c(1,0,0),
    org2$location.type == "rural" ~ c(0,0,0))

  g1 <- geo.weights$weights[1] * sum(l1 == l2)
 
  
  # Level 2 - State distance matrix 
  org1.col.num <- which(colnames(state.dist.mat) == org1$state)
  
  org2.col.num <- ifelse(is.na(org2$state), -1,
                          which(colnames(state.dist.mat) == org2$state))
  
  g2 <- geo.weights$weight[2] * 
    ifelse(org2.col.num < 0, 
           max(state.dist.mat), 
           state.dist.mat[org1.col.num, org2.col.num])
  
  # Final geo distance
  geo.dist <- log(g1 + g2  + 1, base=10)
  
  return(geo.dist)
}

  
