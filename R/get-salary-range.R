#' Get Salary Range 
#' 
#' @description 
#' function to get the salary range 
#' 
#' @param samp output from `select_sample()`
#' @param point.value weighted average salary range from samp
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
    mutate(across(c(broad.category, state, location.type, gender), as.factor))
    
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
  per <- resids / dat.model$ceo.compensation / 100
  quants <- quantile(per, c(0.05, 0.95)) #get rid of the bonus years
  
  
  suggested.range <- point.value + point.value * quants
  
  return(suggested.range)
}

