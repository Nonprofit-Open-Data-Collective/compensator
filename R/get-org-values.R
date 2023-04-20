#' Get Organization Values 
#' 
#' Input basic information about an organization and 
#' return a list of more detailed information. 
#' 
#' @format `get_org_values()`
#' 
#' @param state two letter abbreviation of which state your organization is located in. See `state.abb52` for options.
#' @param location.type either "rural", "town", "subruban" or "metro" for the type of city your organization is located in. 
#' @param total.expense a number of the total annual expenses of your organization in U.S. dollars. 
#' @param ntee a character string of the NTEE code your organization belongs to. A list of all available NTEE codes can be found in the `ntee.orig` data set and at https://nccs.urban.org/publication/irs-activity-codes. 
#' 
#' @return A list of characteristics about your organization 
#' @export 
#' 
#' @examples 
#' get_org_values(state = "NY", location.type = "rural", total.expense = 5000000, ntee = "K93")
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
  if(!(location.type %in% c("rural", "suburban", "town", "metro") )){
    stop("Enter either 'rural', 'town', 'suburban', or 'metro' for `location.type` parameter.")
  }
  # total.expense
  if(!is.numeric(total.expense) | (total.expense < 0)){
    stop("Enter a number 0 or larger for the `total.expense` parameter. ")
  }
  #NTEE Code 
  if(!(substr(ntee,1, 1) %in% LETTERS) ){
    stop("Please enter a vaild NTEE code for the `ntee` parameter.")
  }
  
  ## Generate correct values to return 
  #Total Expense, State, Location Type, disaggregated ntee code
  new.code <- get_new_ntee(ntee)
  
  ret <- list(total.expense = total.expense, 
              state = state,
              location.type = location.type) %>%
    append(new.code)
  
  return(ret)
  
}
