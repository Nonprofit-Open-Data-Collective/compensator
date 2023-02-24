#'  Disaggregate NTEE Code 
#'
#' @description 
#' Input original NTEE code and return disaggregated NTEE code. 
#' 
#' A list of all available NTEE codes can be found in the `ntee.crosswalk` 
#' data set and at https://nccs.urban.org/publication/irs-activity-codes. 
#' 
#' Used to calculated distances between mission codes. 
#'
#' @format ## `get_new_ntee`
#' 
#' @param old.code character string of original NTEE code 
#' 
#' @return A list with new disaggregated code values.
#' See ... Vignette on how these values are calculated. 
#' All known NTEE codes and their respective disaggregated codes are stored 
#' in `ntee-crosswalk` data set. 
#' @export
#' 
#' @examples 
#' get_new_ntee("H96")
#' get_new_ntee("R02")
#' get_new_ntee("R0226")
get_new_ntee <- function(old.code = "B20"){
  
  #find row in ntee crosswalk file 
  #output new rows along with broad category and major group
  
  GOOD <- old.code %in% ntee.crosswalk$ntee
  
  if(!GOOD){
    stop("Input parameter is not a vaild NTEE code.")
  }
  
  new.code <-
    ntee.crosswalk %>%
    dplyr::filter(ntee == old.code)
  
  new.code <- as.list(new.code)
  
  return(new.code)
}
