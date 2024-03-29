% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-salary-range.R
\name{get_salary_range}
\alias{get_salary_range}
\title{Get salary range}
\usage{
get_salary_range(samp, point.value)
}
\arguments{
\item{samp}{output from \code{select_sample()}}

\item{point.value}{weighted average salary range from \code{samp} using 1 - \code{total.dist} as weights}
}
\value{
A list with
\enumerate{
\item \code{suggested.range}: vector of minimum and maximum suggested salary range
\item \code{samp}: the input data frame \code{samp} with two new columns. \code{residual.percent} is the
residual of that observation as a percent of the expected salary. \code{fitted.values} weighted
average of all CEO compensation multiplied by (1+\code{residual.percent})
}
}
\description{
Calculate the salary range to be reported in the final appraisal. This is
used as an internal function in \code{predict_salary} but can be used on it's own.
See Appraisal Process Vignette for detailed information on how this range
is calculated.
}
