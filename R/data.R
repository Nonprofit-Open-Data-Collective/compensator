#' Nonprofits
#'
#' @description 
#' All nonprofits that electronically filled with the IRS from 2009-2019. 
#' Each nonprofit is listed in this data set exactly once at their most recent 
#' file time. See vignette for detailed description on how this data set was 
#' created.  
#' 
#' This is all non profits available for use when generating an appraisal. 
#' 
#' Use `EIN` to match with `nonprofits.detailed` data set for more detailed 
#' information about each nonprofit.
#' 
#' 
#' @format ## `nonprofits`
#' A data frame with 12,847 rows and 18 columns. 
#' Each row is a unique nonprofit, and the columns are its respective attributes:
#' \describe{
#'   \item{EIN}{nonprofit IRS employer identification number}
#'   \item{form.year}{IRS Filing year}
#'   \item{name}{Name of nonprofit}
#'   \item{url}{URL of ProPublica.org with more detailed information about the nonprofit.}
#'   \item{ntee}{Original NTEE code of nonprofit. See references for details }
#'   \item{new.code}{New disaggregated NTEE code. See vignette for details.}
#'   \item{univ}{TRUE or FALSE, is the nonprofit a university?}
#'   \item{hosp}{TRUE or FALSE, is the nonprofit a hospital?}
#'   \item{total.expense, total.employee, gross.reciepts, total.assests}{respective items reported to the IRS for the filing year}
#'   \item{ceo.compensation}{Total CEO compensation}
#'   \item{gender}{Imputed gender of the CEO, see references for details.}
#'   \item{state}{State the nonprofit is located in }
#'   \item{zip5}{5 didget zip code the nonprofit is located in}
#'   \item{location.type}{"metro", "subruban", "town", or "rural", what type of city the nonprofit is located in}
#' }
#' 
"nonprofits"

#' Nonprofits - detailed information
#'
#' More detailed information about the nonprofit, mostly regarding the mission classification.
#' Use EIN to match with `nonprofits` data set. 
#' This data set is primarily used for calculating distance. 
#' 
#' 
#' @format ## `nonprofits.detailed`
#' A data frame with 12,847 rows and 14 columns:
#' \describe{
#'   \item{EIN}{Employer Identification Number}
#'   \item{ntee}{Orignal NTEE Code}
#'   \item{new.code}{New NTEE Code. See vignette for how this value is constructed.}
#'   \item{type.org}{Two letter value specifying the type of organization. First part of `new.code`. See vignette for detials.}
#'   \item{broad.category}{Three letter value specifying broad category of the organization. Second part of the `new.code`. See vignette for details.}
#'   \item{major.group}{A-Z Major Group (3rd to last character of `new.code`).}
#'   \item{division}{Division from `new.code` (2nd to last character of `new.code`)}
#'   \item{subdivision}{Subdivision from `new.code` (last character of `new.code`)}
#'   \item{univ}{TRUE if organization is a university. FALSE otherwise. }
#'   \item{hosp}{TRUE if organization is a hospital. FALSE otherwise. }
#'   \item{total.expense}{Total anual expenses of organization reported to the IRS.}
#'   \item{state}{2 letter state abbreviation of locaiton of organization.}
#'   \item{location.type}{"metro", "suburban", "town" or "rural" for location type of organization. }
#'   \item{RUCA}{Average RUCA code for the `ZIP5`. From USDA.}
#' }
"nonprofits.detailed"

#' Original NTEE Codes
#' 
#' Original NTEE codes and major groups listed at 
#' https://nccs.urban.org/publication/irs-activity-codes. 
#' 
#' @format ## `ntee.orig`
#' A data frame with 681 rows and 3 columns:
#' \describe{
#'   \item{ntee}{If `ntee` is one letter, the row describes a major group. If `ntee` is one letter + two digits, then the row describes an NTEE code.}
#'   \item{description}{Short description of `ntee`.}
#'   \item{definition}{Longer definition of `ntee`. }
#' }
"ntee.orig"


#' State abbreviations
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
#' Equivalently, this is the number of state boarders you need to cross to drive from state A to state B,
#' with the added boarders of Alaska/Washington, Hawaii/California, and Puerto Rico/Florida.
#'
#' @format ## `state.dist.mat`
#' - the (i, j) entry is the path length from state i to state j. 
#' - the diagonal is 0
#' - matrix is symmetric
#' 
#' 
"state.dist.mat"


#' NTEE Codes Crosswalk
#' 
#' Crosswalk between original NTEE codes and the disaggregated version for 
#' calculating distances between two mission codes. 
#' See NTEE Codes Vignette for details on how these values are generated.
#' 
#' Data from   https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies. 
#' 
#' @format ## `nonprofits.detailed`
#' \describe{
#'   \item{ntee}{Orignal NTEE Code}
#'   \item{new.code}{New NTEE Code. See vignette for how this value is constructed.}
#'   \item{type.org}{Two letter value specifying the type of organization. First part of `new.code`. See vignette for detials.}
#'   \item{broad.category}{Three letter value specifying broad category of the organization. Second part of the `new.code`. See vignette for details.}
#'   \item{major.group}{A-Z Major Group (3rd to last character of `new.code`).}
#'   \item{further.category}{4th and 5th charcaters of `old.code` if available, blank otherwise.}
#'   \item{division.subdivision}{Division and Subdivision. See vignette for how this value is determined.}
#'   \item{univ}{TRUE if organization is a university. FALSE otherwise. }
#'   \item{hosp}{TRUE if organization is a hospital. FALSE otherwise. }
#' }
"ntee.crosswalk"