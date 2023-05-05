#' @title
#' Print a number with U.S. dollar sign and commas
#'
#' @description
#' `dollarize(x)` inputs a numeric values and returns that number in U.S.
#' dollar format rounded to the nearest integer.
#'
#' @param x Numeric value
#' @return `x` printed in a character string in U.S. dollar format. 
#' @export
#'
#' @examples
#' dollarize(10)
#' dollarize(321.53)
#' dollarize(12000)
#'
dollarize <- function(x)
{ paste0("$", format( round( x, 0 ), big.mark="," ) ) }

