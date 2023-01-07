#' get_new_ntee
#'
#' Input old ntee codes, get new ntee codes 
#' right now this only works for orgs with the 1 letter + 2 digit format, 
#' eventually, want this to work with orgs that have 1 letter + 4 digits
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
    return("ERROR: Please entre a valid NTEE code.")
  }
  
  new.code <-
    ntee.crosswalk %>%
    dplyr::filter(NTEE == old.code) %>%
    dplyr::select(-Description, -Definition)
  
  return(new.code)
}