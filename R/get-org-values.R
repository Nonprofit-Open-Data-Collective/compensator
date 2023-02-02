#' Get Organization Values 
#' 
#' input basic information about an organization and 
#' return a list of more detailed information. 
#' 
#' @format `get_org_values()`
#' 
#' @param state Two letter abbreviation of which state your organization is located in. See `state.abb52` for options.
#' @param location.type either "rural" or "metro" for the type of city your organization is located in. 
#' @param total.expense a number of the annual total expenses of your organization in U.S. dollars. 
#' @param ntee a character string of the NTEE code your organization belongs to. See https://nccs.urban.org/publication/irs-activity-codes for a list of all possible codes.
#' 
#' @return a list of characteristics about your organization 
#' @export 
#' 
#' @examples 
#' get_org_values(state = "NY", location.type = "rural", total.expense = 50000, ntee = "K93")
#' get_org_values(state = "DC", location.type = "metro", total.expense = 210000, ntee = "A0161")

#'
get_org_values <- function(state = "CA",
                           location.type = "rural", 
                           total.expense = 1000000, 
                           ntee = "A20"){

  ## Checks to Stop 
  #state 
  state <- toupper(state)
  if(!(state %in% state.abb52)){
    stop(paste(state, "is not a valid state abbreviation."))
  }
  #location type 
  location.type <- tolower(location.type)
  if(!(location.type %in% c("rural", "metro") )){
    stop("Enter either 'rural' or 'metro' for `location.type` parameter.")
  }
  # total.expense
  if(!is.numeric(total.expense) | (total.expense < 0)){
    stop("Enter a number 0 or larger for the `total.expense` parameter. ")
  }
  #NTEE Code 
  if(!(ntee %in% ntee.crosswalk$NTEE)){
    stop("Please enter a vaild NTEE code for the `ntee` parameter.")
  }
  
  ## Generate correct values to return 
  #Total Expense, State, Location Type, Original NTEE code, univ, hosp, specialty or regular, disaggregated ntee code
  new.code <- as.list(get_new_ntee(ntee))
  
  ret <- list(total.expense = total.expense, 
              state = state,
              location.type = location.type) %>%
    append(new.code)
  
  return(ret)
  
}
