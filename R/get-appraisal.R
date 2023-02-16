#' Get compensation Appraisal
#' 
#' @description 
#' Wrapper function for generating entire compensation appraisal
#' 
#' @param org.characteristics output from `get_org_values()`
#' @param search criteria a list with ...... NEED TO UPDATE
#' 
#' @export
get_appraisal <- function(org.characteristics, 
                          search.criteria){
  
  # get orgs that match search criteria + calculated distance
  samp <- select_sample(org = org, search.criteria = search.criteria)
  
  #get appraisal
  appraisal <- predict_salary(samp)
  
  return(appraisal)
}