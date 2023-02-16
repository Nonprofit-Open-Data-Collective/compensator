#' Get Salary Appraisal
#' 
#' @description 
#' function to predict salary
#' 
#' @param samp output from `select_sample()`
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
  salary.range <- get_salary_range(samp, weighted.avg)
  names(salary.range) <- c()
  
  ret <- list(
    point.value = weighted.avg,
    salary.range = salary.range
  )
  
  
}