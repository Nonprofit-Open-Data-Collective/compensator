#' dat_filtering
#'
#' STILL NEED TO EDIT 
#' STILL NEED TO ADD EXAMPLE
#'
#' Filtering `nonprofits` with given search criteria
#' 
#' @format ## `dat_filtering`
#' 
#' @param BroadCategroy vector of broad categories you wish to include in returned data set
#' @param MajorGroup vector of major categories you wish to include in returned data set
#' @param Decile vector of numbers from 2 to 10 of decile codes you want to include, exists within MajorGroup 
#' @param CommonCode "speciality" or "regular" , do you want to include common code orgainzations?
#' @param University TRUE of FALSE, do you want to include universities
#' @param Hostipal TRUE of FALSE, do you want to include hospitals
#' @param Location "metro" or "rural" or "both"
#' @param State vector of 2 letter state abbreviations to be included
#' @param TotalExpenses vector of c(min,max) of range of total expenses to be included
#' 
#' }
dat_filtering <- function(BroadCategroy = NA, 
                          MajorGroup = NA, 
                          Decile = NA, 
                          CommonCode = NA, 
                          University = NA,
                          Hostipal = NA, 
                          Location = NA, 
                          State = NA, 
                          TotalExpenses = c(0, Inf)){
  
  #load data 
  load("data/EIN_filtering.rda")
  
  dat.filtered <- EIN_filtering
  
  
  # Filter by regular or specialty
  if(!any(is.na(CommonCode))){
    if(CommonCode == "speciality"){
      dat.filtered <- dat.filtered[dat.filtered$type.org == "S", ]
    }else if(CommonCode == "regular"){
      dat.filtered <- dat.filtered[dat.filtered$type.org == "R", ]
    }
  }
  
  # Filter by university 
  if(!any(is.na(University)) ){
    dat.filtered <- dat.filtered[dat.filtered$University == TRUE , ]
  }
  
  # Filter by Hospital 
  if(!any(is.na(Hostipal)) ){
    dat.filtered <- dat.filtered[dat.filtered$Hostipal == TRUE , ]
  }
  
  # Filter By state
  if(!any(is.na(State)) ){
    dat.filtered <- dat.filtered[dat.filtered$State %in% State, ]
  }
  
  # Filter By Location
  if(!any(is.na(Location)) ){
    dat.filtered <- dat.filtered[dat.filtered$Location %in% Location, ]
  }
  
  # Filter By Broad Category
  if(!any(is.na(BroadCategroy))){
    dat.filtered <- dat.filtered[dat.filtered$BroadCategroy %in% BroadCategroy, ]
  }
  
  # Filter By Major Group
  if(!any(is.na(MajorGroup))){
    dat.filtered <- dat.filtered[dat.filtered$MajorGroup %in% MajorGroup, ]
  }
  
  # Filter By Decile
  if(!any(is.na(Decile))){
    dat.filtered <- dat.filtered[dat.filtered$Decile %in% Decile, ]
  }
  
  # Filter By Total Expenses 
  if(!any(is.na(TotalExpenses))){
    min = TotalExpenses[1]
    max = TotalExpenses[2]
    dat.filtered <- dat.filtered[dat.filtered$TotalExpense >= min , ]
    dat.filtered <- dat.filtered[dat.filtered$TotalExpense <= max , ]
  }
  
  return(dat.filtered)

}