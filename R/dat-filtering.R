#' dat_filtering
#'
#' STILL NEED TO ADD EXAMPLE
#'
#' STILL NEED TO EDIT DESCRIPtion
#' Filtering `nonprofits.detailed` with given search criteria.
#' EIN's that make it through this filtering, will be used to filter `nonprofits` for final comparison sets. 
#' Check https://nccs.urban.org/project/national-taxonomy-exempt-entities-ntee-codes for NTEE code explanations. 
#' 
#' @format ## `dat_filtering`
#' 
#' @param type.org vector of the types of organization you want to include. Options are  RG, AA, MT, PA, RP, MS, MM, and/or NS. 
#' @param broad.category vector of broad categories you wish to include in returned data set Options are ART, EDU, ENV, HEL, HMS, IFA, PSB, REL, MMB, UNU, UNI, and/or HOS 
#' @param major.group vector of major groups you wish to include in returned data set. Options are A-Z.
#' @param division vector of divisions you wish to include. Divisions exist entirely inside major groups. We suggest you do not use this parameter if you have more than one item in `major.group`. Options are 0, 2, 3, ..., 9 (1 is not an option. 
#' @param subdivision vector of subdivision you wish to include. Subdivisions exist entirely inside divisions. We suggest you do not use this parameter if you have more than one item in `division`. Options are 0 - 9. 
#' @param univ TRUE of FALSE. Are universities to be included?
#' @param hosp TRUE of FALSE, Are hospitals to be included?
#' @param location.type vector of "metro", "suburban", "town", and/or "rural" for which city types to include
#' @param state vector of 2 letter state abbreviations to be included
#' @param total.expense vector of c(min,max) of range of total expenses to be included
#' 
#' Any parameter you want to include all values for, you can either list all possible values, or assign that parameter to NA. 
#' Default parameters are set to include all regular organizations and exclude all specality organizations.
#' 
#' @return All entries in `nonprofits.detailed` data set that match the filtering criteria
#' @export
#' 
#' @examples 
#' # all non-university educational nonprofits in Kansas, Nebraska, Iowa, and Missouri.
#' dat_filtering(
#'   type.org = "RG",
#'   broad.category = "EDU", 
#'   major.group = "B", 
#'   univ = FALSE,
#'   hosp = FALSE, 
#'   location.type = c("urban", "suburban", "town", "rural"), 
#'   state = c("KS", "NE", "IA", "MO") ,
#'   total.expense = c(0, Inf))
#' 
dat_filtering <- function(
    type.org = "RG", 
    broad.category = c("ART", "EDU", "ENV", "HEL", "HMS", "IFA", "PSB", "REL", "MMB", "UNU", "UNI", "HOS" ), 
    major.group = base::LETTERS, 
    division = NA, 
    subdivision = NA,
    univ = FALSE,
    hosp = FALSE, 
    location.type = c("urban", "suburban", "town", "rural"), 
    state = state.abb52, 
    total.expense = c(0, Inf)){
  
  #Fail safes for parameter inputs---------------------------------------------------
  
  #type.org
  if(!any(is.na(type.org)) &
     !all(type.org %in% c("RG", "AA", "MT", "PA", "RP", "MS", "MM", "NS"))){
    index = which(!(type.org %in% c("RG", "AA", "MT", "PA", "RP", "MS", "MM", "NS")))
    stop(paste(paste(type.org[index],collapse=', '), 
               "in the `type.org` parameter are not valid organization types. "))
  }
  #broad category
  if(!any(is.na(broad.category)) &
     !all(broad.category %in% c("ART", "EDU", "ENV", "HEL", "HMS", "IFA", "PSB", "REL", "MMB", "UNU", "UNI", "HOS" ))){
    index = which(!(broad.category %in% c("ART", "EDU", "ENV", "HEL", "HMS", "IFA", "PSB", "REL", "MMB", "UNU", "UNI", "HOS" )))
    stop(paste(paste(broad.category[index],collapse=', '), 
               "in the `broad.category` parameter are not valid broad categories."))
  }
  #major group
  if(!any(is.na(major.group)) & !all(major.group %in% LETTERS)){
    index = which(!(major.group %in% LETTERS))
    stop(paste(paste(major.group[index],collapse=', '), 
               "in the `major.group` parameter are not valid major groups."))
  }
  #division
  if(!any(is.na(division)) &!all(division %in% c(0, 2:9))){
    index = which(!(division %in% c(0, 2:9)))
    stop(paste(paste(division[index],collapse=', '), 
               "in the `division` parameter are not valid divisions."))
  }
  #subdivision
  if(!any(is.na(subdivision)) &!all(subdivision %in% 0:9)){
    index = which(!(subdivision %in% 0:9))
    stop(paste(paste(subdivision[index],collapse=', '),
               "in the `subdivision` parameter are not valid subdivisions."))
  }
  #univ
  if(!is.na(univ) & !is.logical(univ)){
    stop("`univ` parameter must be TRUE or FALSE.")
  }
  #hosp
  if(!is.na(hosp) & !is.logical(hosp)){
    stop("`hosp` parameter must be TRUE or FALSE.")
  }
  #location type
  if(!any(is.na(location.type)) & !any(location.type %in% c("urban", "suburban", "town", "rural"))){
    index = which(!(location.type %in% LETTERS))
    stop(paste(paste(location.type[index],collapse=', '), 
               "in the `location.type` parameter are not valid location types."))
  }
  #state
  if(!any(is.na(state)) & !all(state %in% state.abb52)){
    index = which(!(state %in% state.abb52))
    stop(paste(paste(state[index],collapse=', '),
               "in the `state` parameter are not valid state abbreviations."))
  }
  #total expense
  if(!any(is.na(total.expense)) &
     (!all(is.numeric(total.expense)) | 
     total.expense[1] > total.expense[2] | 
     total.expense[1] == Inf)){
    stop(paste("`total.expense` parameter is invalid."))
  }
  if( !any(is.na(total.expense)) & total.expense[1] < 0){
    total.expense[1] <- 0
    message("The smallest total expense possible is $0. Your `total.expense` parameter is being replaced with `c(0, ", total.expense[2], ")`.")
  }
  
  # Filtering Process ------------------------------------------
  # attributes ordered by what will usually get rid of the most to what usually will get rid of the least
  
  #load data 
  dat.filtered <- nonprofits.detailed
  
  
  # Filter by regular or specialty
  if(!any(is.na(type.org)) ){
    dat.filtered <- dat.filtered[ dat.filtered$type.org == type.org , ]
  }
  
  # Filter by univ if FALSE, if TRUE do nothing
  if(!any(is.na(univ)) & univ == FALSE){
    dat.filtered <- dat.filtered[dat.filtered$univ == univ , ]
  }
  
  # Filter by hosp if FALSE, if TRUE do nothing
  if(!any(is.na(hosp)) & hosp == FALSE){
    dat.filtered <- dat.filtered[dat.filtered$hosp == hosp , ]
  }
  
  # Filter By state
  if(!any(is.na(state)) ){
    dat.filtered <- dat.filtered[dat.filtered$state %in% state, ]
  }
  
  # Filter By location
  if(!any(is.na(location.type)) ){
      dat.filtered <- dat.filtered[dat.filtered$location.type %in% location.type, ]
  }
  
  # Filter By Broad Category
  if(!any(is.na(broad.category))){
    dat.filtered <- dat.filtered[dat.filtered$broad.category %in% broad.category, ]
  }
  
  # Filter By Major Group
  if(!any(is.na(major.group))){
    dat.filtered <- dat.filtered[dat.filtered$major.group %in% major.group, ]
  }
  
  # Filter By division
  if(!any(is.na(division))){
    division <- as.character(division)
    dat.filtered <- dat.filtered[as.character(dat.filtered$division) %in% division, ]
  }
  
  # Filter By subdivision
  if(!any(is.na(subdivision))){
    subdivision <- as.character(subdivision)
    dat.filtered <- dat.filtered[as.character(dat.filtered$subdivision) %in% subdivision, ]
  }
  
  # Filter By Total Expenses
  if(!any(is.na(total.expense))){
    mi = min(total.expense)
    ma = max(total.expense)
    dat.filtered <- dat.filtered[dat.filtered$total.expense >= mi , ]
    dat.filtered <- dat.filtered[dat.filtered$total.expense <= ma , ]
  }

  return(dat.filtered)

}

