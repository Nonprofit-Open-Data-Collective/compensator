#' Get Salary Appraisal
#' 
#' @description 
#' function to predict salary
#' 
#' @param samp output from `select_sample()`
#' 
#' @return A list with 
#' 1. `point.value`: the weighted average of CEO compensation using inverse distance as weights, 
#' 2. `salary.range`: vector of minimum and maximum suggested salary range
#' 3. `sample`: the input data frame `samp` with two new columns. `residual.percent` is the 
#' residual of that observation as a percent of the expected salary. `fitted.values` is 
#' `point.value`*(1+`residual.percent`). 
#' 
#'  See ... Vignette for detailed explanation on how these values are calculated
#' 
#' @export 
#' 
#' 
predict_salary <- function(samp ){
  
  ## Do checks to make sure things in sample are formatted correctly 
  
  ## standardize distance 
  samp$dist.std <-  (samp$total.dist - min(samp$total.dist)) / (max(samp$total.dist) - min(samp$total.dist))
  
  ## get weights
  samp$weight <- (1 - samp$dist.std) / sum(1 - samp$dist.std)
  
  ## Get point value - weighted average 
  weighted.avg <- sum(samp$weight * samp$ceo.compensation)
  
  ## Get Range
  range.predict <- get_salary_range(samp, weighted.avg)
  salary.range <- range.predict$suggested.range
  names(salary.range) <- c()
  
  ret <- list(
    point.value = weighted.avg,
    salary.range = salary.range,
    sample = range.predict$samp
  )
  
  return(ret)
  
  
}