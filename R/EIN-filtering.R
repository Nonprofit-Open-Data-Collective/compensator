#' EIN_filtering
#'
#' STILL NEED TO EDIT 
#'
#' data used for filtering in`dat-filtering`
#' 
#' @format ## `EIN_filtering`
#' \describe{
#'   \item{EIN}{Employer Identification Number}
#'   \item{BroadCategroy}{vector of braod categories you wish to include in returned data s}
#'   \item{MajorGroup}{vector of major categroies you wish to include in returned data set}
#'   \item{Decile}{vector of numbers from 2 to 10 of decile codes you want to include, exists within MajorGroup }
#'   \item{CommonCode}{TRUE of FALSE, do you want to include common code orgainzations?}
#'   \item{Hostipal}{TRUE of FALSE, do you want to include hospitals}
#'   \item{University}{TRUE of FALSE, do you want to include universities}
#'   \item{Location}{"metro" or "rural" or "both"}
#'   \item{State}{vector of 2 letter state abbreviations to be included}
#'   \item{TotalExpenses}{vector of c(min,max) of range of total expenses to be included}
#' }
"EIN_filtering"