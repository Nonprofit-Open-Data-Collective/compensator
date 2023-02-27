#' nonprofits
#'
#' @description 
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
#'   \item{form.year}{IRS Filing year}
#'   \item{name}{Name of nonprofit}
#'   \itel{url}{URL of ProPublica.org with more detailed information about the nonprofit.}
#'   \item{ntee}{NTEE code of nonprofit. See references for details }
#'   \item{univ}{TRUE or FALSE, is the nonprofit a university?}
#'   \item{hosp}{TRUE or FALSE, is the nonprofit a hospital?}
#'   \item{total.expense, TotalEmployee, GrossReceipts, TotalAssests}{respective items reported to the IRS for the filing year}
#'   \item{ceo.compensation}{Total CEO compensation}
#'   \item{gender}{Imputed gender of the CEO, see references details.}
#'   \item{state}{State the nonprofit is in }
#'   \item{zip5}{5 didget zip code of the nonprofit}
#'   \item{location.type}{"metro" or "rural", what type of city the nonprofit is located in}
#' }
#' 
"nonprofits"

#' EIN.filtering
#'
#' data used for filtering in`dat-filtering`.
#' Use EIN to match with `nonprofits` data set. 
#' 
#' 
#' @format ## `EIN_filtering`
#' A data frame with 12,847 rows and 21 columns:
#' \describe{
#'   \item{EIN}{Employer Identification Number}
#'   \item{ntee}{Orignal NTEE Code}
#'   \item{broad.category}{1-12 Broad Category}
#'   \item{major.group}{A-Z Major Group}
#'   \item{type.org}{"R" for regular organization (two digit value of 20-99) of "S" for specality organization (two digit value of 01-19)}
#'   \item{two.digit}{Orignal decile and centile values of NTEE code}
#'   \item{two.digit.s}{For regular organizations, this is just the two.digit value. 
#'   For specialty organizations, if there is a further categorization available this is the 3rd and 4th digit of the NTEE code,
#'   if there is not a further categorization this is just the two digit value. }
#'   \item{tens}{Tens place of the two.digit.s value.}
#'   \item{ones}{Ones place of the two.digit.s value}
#'   \item{us.state}{TRUE if organization is in a U.S. state. FALSE if orgainization if a U.S. territory.}
#'   \item{univ}{TRUE if organization is a university. FALSE otherwise. }
#'   \item{hosp}{TRUE if organization is a hospital. FALSE otherwise. }
#'   \item{total.expense"}{Total anual expenses of organization reported to the IRS.}
#'   \item{state}{2 letter state abbreviation of locaiton of organization.}
#'   \item{location.type}{"metro" or "rural" for location type of organization. }
#' }
"EIN.filtering"

#' state.abb52
#' 
#' Two letter abbreviations of all states plus Washington D.C. and Puerto Rico. 
#' 
#' @format ## `state_abb`
#' A vector with 52 elements
#' 
"state.abb52"

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
#' @format ## `state.dist.mat`
#' - the (i, j) entry is the path length from state i to state j. 
#' - the diagonal is 0
#' 
#' 
"state.dist.mat"


#' NTEE Codes Crosswalk
#' 
#' Crosswalk between original NTEE codes and the disaggregated version for calculating distances between two mission codes. 
#' See ... Vignette for details on how these values are calculated
#' 
#' Data from   https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies. 
"ntee.crosswalk"