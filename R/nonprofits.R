#' nonprofits
#'
#' STILL NEED TO EDIT 
#'
#' All non profits available for comparison.
#' Each non profit who filed with the IRS is in here once, with their most recent filing 
#' 
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