#' Get salary range 
#' 
#' @description 
#' Calculate the salary range to be reported in the final appraisal. This is 
#' used as an internal function in `predict_salary` but can be used on it's own.
#' See Appraisal Process Vignette for detailed information on how this range 
#' is calculated.
#' 
#' @param samp output from `select_sample()`
#' @param point.value weighted average salary range from `samp` using 1 - `total.dist` as weights
#' 
#' @return A list with 
#' 1. `suggested.range`: vector of minimum and maximum suggested salary range
#' 2. `samp`: the input data frame `samp` with two new columns. `residual.percent` is the 
#' residual of that observation as a percent of the expected salary. `fitted.values` weighted 
#' average of all CEO compensation multiplied by (1+`residual.percent`)
#' 
#' 
#' @export
#' 
get_salary_range <- function(samp, point.value){
  
  ## format the data to be used for modeling --------------------------------
  dat.model <- 
    samp %>%
    dplyr::select(form.year, ceo.compensation, gender, 
                  total.assests, gross.receipts, total.employee, total.expense,
                  broad.category, state, location.type) %>%
    #change categorical variables to factors
    dplyr::mutate(across(c(broad.category, state, location.type, gender), as.factor))
    
  ## Making the formula -----------------------------------------------------
  ##  - cant add line breaks in formulas (this is turned into a formula later)
  form <- "ceo.compensation ~ form.year + log(total.assests+1, 10) + log(gross.receipts + 1, 10) + log(total.expense+1, 10) + log(total.employee+1, 10)"
  
  #add other variables to factors only if they have more than one level
  if(length(unique(dat.model$broad.category)) > 1){
    form <- paste(form, " + broad.category")
  }
  
  if(length(unique(dat.model$state)) > 1){
    form <- paste(form, " + state")
  }
  
  if(length(unique(dat.model$location.type)) > 1){
    form <- paste(form, " + location.type")
  }
  
  if(all( c("F", "M") %in% unique(dat.model$gender))){
    #update form
    form <- paste(form, " + gender")
  }
  
  form <- stats::formula(form)
  
  ## Get Range -----------------------------------
  #model
  mod <- lm(form , data = dat.model )
  
  #get residuals as a percentage of their original value
  resids <- mod$residuals
  per <- resids / mod$fitted.values  
  p <-  point.value * (1+per)
  
  suggested.range <- quantile(p, c(0.05, 0.95), na.rm = TRUE) #get rid of the bonus years
  
  
  # Store values for return 
  samp$fitted.values <- p
  samp$residual.percent <- per
  
  ret <- list(suggested.range = suggested.range,
              samp = samp)
  
  return(ret)
}

