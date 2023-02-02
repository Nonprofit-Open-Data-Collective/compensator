#' get_new_ntee
#'
#' Input original NTEE code and return disaggregated NTEE code. 
#' 
#' Used to calculated distances between mission codes. 
#'
#' @format ## `get_new_ntee`
#' 
#' @return Table with new ntee codes
#' @export
get_new_ntee <- function(old.code = "B20"){
  
  #find row in ntee crosswalk file 
  #output new rows along with broad category and major group
  
  GOOD <- old.code %in% ntee.crosswalk$NTEE
  
  if(!GOOD){
    return("ERROR: Please enter a valid NTEE code.")
  }
  
  new.code <-
    ntee.crosswalk %>%
    dplyr::filter(NTEE == old.code)
  
  return(new.code)
}
