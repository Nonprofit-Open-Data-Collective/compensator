% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{nonprofits.detailed}
\alias{nonprofits.detailed}
\title{Nonprofits - detailed information}
\format{
\subsection{\code{nonprofits.detailed}}{

A data frame with 12,847 rows and 14 columns:
\describe{
\item{EIN}{Employer Identification Number}
\item{ntee}{Orignal NTEE Code}
\item{new.code}{New NTEE Code. See vignette for how this value is constructed.}
\item{type.org}{Two letter value specifying the type of organization. First part of \code{new.code}. See vignette for detials.}
\item{broad.category}{Three letter value specifying broad category of the organization. Second part of the \code{new.code}. See vignette for details.}
\item{major.group}{A-Z Major Group (3rd to last character of \code{new.code}).}
\item{division}{Division from \code{new.code} (2nd to last character of \code{new.code})}
\item{subdivision}{Subdivision from \code{new.code} (last character of \code{new.code})}
\item{univ}{TRUE if organization is a university. FALSE otherwise. }
\item{hosp}{TRUE if organization is a hospital. FALSE otherwise. }
\item{total.expense}{Total anual expenses of organization reported to the IRS.}
\item{state}{2 letter state abbreviation of locaiton of organization.}
\item{location.type}{"metro", "suburban", "town" or "rural" for location type of organization. }
\item{RUCA}{Average RUCA code for the \code{ZIP5}. From USDA.}
}
}
}
\usage{
nonprofits.detailed
}
\description{
More detailed information about the nonprofit, mostly regarding the mission classification.
Use EIN to match with \code{nonprofits} data set.
This data set is primarily used for calculating distance.
}
\keyword{datasets}
