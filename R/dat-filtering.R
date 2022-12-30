#' dat_filtering
#'
#' STILL NEED TO ADD EXAMPLE
#'
#' STILL NEED TO EDIT DESCRIPTION
#' Filtering `EIN_filtering` with given search criteria.
#' EIN's that make it through this filtering, will be used to filter `nonprofits` for final comparison sets. 
#' Check https://nccs.urban.org/project/national-taxonomy-exempt-entities-ntee-codes for NTEE code explanations. 
#' 
#' @format ## `dat_filtering`
#' 
#' @param broad.category vector of broad categories you wish to include in returned data set
#' @param major.group vector of major categories you wish to include in returned data set
#' @param decile vector of numbers from 2 to 10 of decile codes you want to include, exists within major.group 
#' @param common.code "specialty" or "regular" or "both". 
#'        "specialty" to only include specialty (common code) organization. 
#'        "regular" to only include regular organizations.
#'        "both" to include both.
#' @param university TRUE of FALSE. Are universities to be included?
#' @param hospital TRUE of FALSE, Are hospitals to be included?
#' @param location "metro" or "rural" or "both" or "all".
#'        "metro" only includes organizations with metropolitan locations type. 
#'        "rural" only includes organizations with rural locations type.
#'        "both" includes both metropolitan and rural organizations but excludes organizations with NA values in the location type.
#'        "all" includes organizations with metropolitan, rural, and NA location types. 
#' @param state vector of 2 letter state abbreviations to be included
#' @param total.expenses vector of c(min,max) of range of total expenses to be included
#' 
#' }
dat_filtering <- function(broad.category = 1:12, 
                          major.group = base::LETTERS, 
                          decile = 2:9, 
                          common.code = "regular", 
                          university = FALSE,
                          hospital = FALSE, 
                          location = "both", 
                          state = state_abb, 
                          total.expenses = c(0, Inf)){
  
  #load data 
  dat.filtered <- EIN_filtering
  
  
  # Filter by regular or specialty
  if(!any(is.na(common.code))){
    if(common.code == "speciality"){
      dat.filtered <- dat.filtered[dat.filtered$type.org == "S", ]
    }else if(common.code == "regular"){
      dat.filtered <- dat.filtered[dat.filtered$type.org == "R", ]
    }
  }
  
  # Filter by university 
  if(!any(is.na(university)) & is.logical(university)){
    dat.filtered <- dat.filtered[dat.filtered$University == university , ]
  }
  
  # Filter by Hospital 
  if(!any(is.na(hospital)) & is.logical(hospital)){
    dat.filtered <- dat.filtered[dat.filtered$Hospital == hospital , ]
  }
  
  # Filter By state
  if(!any(is.na(state)) ){
    dat.filtered <- dat.filtered[dat.filtered$State %in% state, ]
  }
  
  # Filter By location
  if(!any(is.na(location)) ){
    if(location == "metro"){
      dat.filtered <- dat.filtered[dat.filtered$LocationType == "Metropolitan", ]
    }else if(location == "rural"){
      dat.filtered <- dat.filtered[dat.filtered$LocationType == "Rural", ]
    }else if(location == "Both"){
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
  if(!any(is.na(total.expenses))){
    min = total.expenses[1]
    max = total.expenses[2]
    dat.filtered <- dat.filtered[dat.filtered$TotalExpense >= min , ]
    dat.filtered <- dat.filtered[dat.filtered$TotalExpense <= max , ]
  }
  
  return(dat.filtered)

}