% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-org-values.R
\name{get_org_values}
\alias{get_org_values}
\title{Get organization values}
\format{
\code{get_org_values()}
}
\usage{
get_org_values(
  state = "CA",
  location.type = "rural",
  total.expense = 1e+06,
  ntee = "A20"
)
}
\arguments{
\item{state}{two letter abbreviation of which state your organization is located in. See \code{state.abb52} for options.}

\item{location.type}{either "rural", "town", "subruban" or "metro" for the type of city your organization is located in.}

\item{total.expense}{a number of the total annual expenses of your organization in U.S. dollars.}

\item{ntee}{a character string of the NTEE code your organization belongs to. A list of all available NTEE codes can be found in the \code{ntee.orig} data set and at https://nccs.urban.org/publication/irs-activity-codes.}
}
\value{
A list of characteristics about your organization
}
\description{
Input basic information about an organization and return a list of more
detailed information. This is Step 1 in the Appraisal Process Vignette.
}
\examples{
get_org_values(state = "NY", location.type = "rural", total.expense = 5000000, ntee = "K93")
get_org_values(state = "DC", location.type = "metro", total.expense = 210000, ntee = "A0161")

}
