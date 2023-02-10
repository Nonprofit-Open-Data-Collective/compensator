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
get_geo_dist <- function(org1, org2, geo.weights){
  
  #org1 <- org
  #org2 <- dat.filtered[1, ]
  
  ## Geographic distance 
  
  # Level 1 - States 
  g1 <- geo.weights$weights[1] * (org1$state != org2$state)
  
  # Level 2 - Location types 
  g2 <- geo.weights$weight[2] * 
    ifelse( is.na(org2$location.type), 1, 
           org1$location.type != org2$location.type)
  
  # Level 3 - State distance matrix 
  org1.col.num <- which(colnames(state.dist.mat) == org1$state)
  
  org2.col.num <- ifelse(is.na(org2$state), -1,
                          which(colnames(state.dist.mat) == org2$state))
  
  g3 <- geo.weights$weight[3] * 
    ifelse(org2.col.num < 0, 
           max(state.dist.mat), 
           state.dist.mat[org1.col.num, org2.col.num])
  
  # Final geo distance
  geo.dist <- g1 + g2 + g3
  
  return(geo.dist)
}
