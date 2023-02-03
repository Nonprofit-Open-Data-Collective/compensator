#' dat_filtering
#'
#' STILL NEED TO ADD EXAMPLE
#'
#' STILL NEED TO EDIT DESCRIPtion
#' Filtering `EIN_filtering` with given search criteria.
#' EIN's that make it through this filtering, will be used to filter `nonprofits` for final comparison sets. 
#' Check https://nccs.urban.org/project/national-taxonomy-exempt-entities-ntee-codes for NTEE code explanations. 
#' 
#' @format ## `dat_filtering`
#' 
#' @param broad.category vector of broad categories you wish to include in returned data set
#' @param major.group vector of major categories you wish to include in returned data set
#' @param decile vector of numbers from 2 to 10 of decile codes you want to include, exists within major.group 
#' @param type.org "specialty" or "regular" or "both". 
#'        "specialty" to only include specialty (common code) organization. 
#'        "regular" to only include regular organizations.
#'        "both" to include both.
#' @param univ TRUE of FALSE. Are universities to be included?
#' @param hosp TRUE of FALSE, Are hospitals to be included?
#' @param location.type "metro" or "rural" or "both" or "all".
#'        "metro" only includes organizations with metropolitan locations type. 
#'        "rural" only includes organizations with rural locations type.
#'        "both" includes both metropolitan and rural organizations but excludes organizations with NA values in the location type.
#'        "all" includes organizations with metropolitan, rural, and missing location types. 
#' @param state vector of 2 letter state abbreviations to be included
#' @param total.expense vector of c(min,max) of range of total expenses to be included
#' 
#' @return A table of nonprofits that match the filtering criteria
#' @export
#' 
#' @examples 
#' # all non-univ educational nonprofits in Kansas, Nebraska, Iowa, and Missouri  
#' dat_filtering(broad.category = 2, 
#' major.group = "B", 
#' decile = 2:9, 
#' type.org = "regular", 
#' univ = FALSE,
#' hosp = FALSE, 
#' location.type = "both", 
#' state = c("KS", "NE", "IA", "MO") ,
#' total.expense = c(0, Inf))
#' 
dat_filtering <- function(broad.category = 1:12, 
                          major.group = base::LETTERS, 
                          decile = 2:9, 
                          type.org = "regular", 
                          univ = FALSE,
                          hosp = FALSE, 
                          location.type = "both", 
                          state = c(datasets::state.abb, "DC", "PR"), 
                          total.expense = c(0, Inf)){
  
  #load data 
  dat.filtered <- EIN.filtering
  
  
  # Filter by regular or specialty
  if(!any(is.na(type.org))){
    if(type.org == "speciality"){
      dat.filtered <- dat.filtered[dat.filtered$type.org == "S", ]
    }else if(type.org == "regular"){
      dat.filtered <- dat.filtered[dat.filtered$type.org == "R", ]
    }
  }
  
  # Filter by univ 
  if(!any(is.na(univ)) & is.logical(univ)){
    dat.filtered <- dat.filtered[dat.filtered$University == univ , ]
  }
  
  # Filter by Hospital 
  if(!any(is.na(hosp)) & is.logical(hosp)){
    dat.filtered <- dat.filtered[dat.filtered$Hospital == hosp , ]
  }
  
  # Filter By state
  if(!any(is.na(state)) ){
    dat.filtered <- dat.filtered[dat.filtered$State %in% state, ]
  }
  
  # Filter By location
  if(!any(is.na(location.type)) ){
    if(location.type == "metro"){
      dat.filtered <- dat.filtered[dat.filtered$LocationType == "Metropolitan", ]
    }else if(location.type == "rural"){
      dat.filtered <- dat.filtered[dat.filtered$LocationType == "Rural", ]
    }else if(location.type == "both"){
      dat.filtered <- dat.filtered[!is.na(dat.filtered$LocationType), ]
    }
    
    
  }
  
  # Filter By Broad Category
  if(!any(is.na(broad.category))){
    dat.filtered <- dat.filtered[dat.filtered$BroadCategory %in% broad.category, ]
  }
  
  # Filter By Major Group
  if(!any(is.na(major.group))){
    dat.filtered <- dat.filtered[dat.filtered$MajorGroup %in% major.group, ]
  }
  
  # Filter By decile
  if(!any(is.na(decile))){
    dat.filtered <- dat.filtered[dat.filtered$tens %in% decile, ]
  }
  
  # Filter By Total Expenses 
  if(!any(is.na(total.expense))){
    min = total.expense[1]
    max = total.expense[2]
    dat.filtered <- dat.filtered[dat.filtered$TotalExpense >= min , ]
    dat.filtered <- dat.filtered[dat.filtered$TotalExpense <= max , ]
  }
  
  return(dat.filtered)

}
