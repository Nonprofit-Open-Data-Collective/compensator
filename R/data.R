#' nonprofits
#'
#' STILL NEED TO EDIT 
#'
#' All non profits available for comparison.
#' Each non profit who filed with the IRS is in here once, with their most recent filing 
#' Use `EIN` to match with `EIN_filtering` data set.
#' 
#' @format ## `nonprofits`
#' A data frame with 12,847 rows and 21 columns:
#' \describe{
#'   \item{EIN}{nonprofit IRS employer identification number}
#'   \item{FormYr}{IRS Filing year}
#'   \item{Name}{Name of nonprofit}
#'   \item{NTEE}{NTEE code of nonprofit. See references for details }
#'   \item{Univeristy}{TRUE or FALSE, is the nonprofit a university?}
#'   \item{Hosiptal}{TRUE or FALSE, is the nonprofit a hospital?}
#'   \item{TotalExpense, TotalEmployee, GrossReceipts, TotalAssests}{respective items reported to the IRS for the filing year}
#'   \item{CEOCompensation}{Total CEO compensation}
#'   \item{Gender}{Imputed gender of the CEO, see references details.}
#'   \item{State}{State the nonprofit is in }
#'   \item{ZIP5}{5 didget zip code of the nonprofit}
#'   \item{LocationType}{"Metropolatin" or "Rural", what type of city the nonprofit is located in}
#' }
#' 
"nonprofits"

#' EIN_filtering
#'
#' data used for filtering in`dat-filtering`.
#' Use EIN to match with `nonprofits` data set. 
#' 
#' 
#' @format ## `EIN_filtering`
#' \describe{
#'   \item{EIN}{Employer Identification Number}
#'   \item{NTEE}{Orignal NTEE Code}
#'   \item{BroadCategroy}{1-12 Broad Category}
#'   \item{MajorGroup}{A-Z Major Group}
#'   \item{type.org}{"R" for regular organization (two digit value of 20-99) of "S" for specality organization (two digit value of 01-19)}
#'   \item{two.digit}{Orignal decile and centile values of NTEE code}
#'   \item{two.digit.s}{For regular organizations, this is just the two.digit value. 
#'   For specialty organizations, if there is a further categorization available this is the 3rd and 4th digit of the NTEE code,
#'   if there is not a further categorization this is just the two digit value. }
#'   \item{tens}{Tens place of the two.digit.s value.}
#'   \item{ones}{Ones place of the two.digit.s value}
#'   \item{us.state}{TRUE if organization is in a U.S. state. FALSE if orgainization if a U.S. territory.}
#'   \item{University}{TRUE if organization is a university. FALSE otherwise. }
#'   \item{Hostipal}{TRUE if organization is a hospital. FALSE otherwise. }
#'   \item{TotalExpenses}{Total anual expenses of organization reported to the IRS.}
#'   \item{State}{2 letter state abbreviation of locaiton of organization.}
#'   \item{LocationType}{"Metropolitan" or "Rural" for location type of organization. }
#' }
"EIN_filtering"

#' state_abb
#' 
#' Two letter abbreviations of all states plus D.C. and Puerto Rico. 
#' 
#' @format ## `state_abb`
#' A vector with 52 elements
#' 
"state_abb"

#' State Distance Matrix
#'
#' A 52-by-52 matrix of distances between all US states (and D.C. and PR)
#' Distance is calculated by creating a network of U.S. states as follows:
#' 1. Turn all states into vertices and all boarders into edges. 
#' 2. Add edges between Alaska and Washington, Hawaii and California, Puerto Rico and Florida.
#' 3. Distance between two states is the path length between them. 
#' 
#' Equivalently, this is the number of states you need to go through to drive from state A to state B,
#' with the added boarders of Alaska/Washington, Hawaii/California, and Puerto Rico/Florida.
#'
#' @format ## `state_distance_matrix`
#' - the (i, j) entry is the path length from state i to state j. 
#' - the diagonal is 0
#' 
#' 
"state_distance_matrix"