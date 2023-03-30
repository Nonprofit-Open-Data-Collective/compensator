#'  Disaggregate NTEE Code 
#'
#' @description 
#' Input original NTEE code and return disaggregated NTEE code. 
#' 
#' A list of all available NTEE codes can be found in the `ntee.crosswalk` 
#' data set and at https://nccs.urban.org/publication/irs-activity-codes. 
#' 
#' Used to calculated distances between mission codes. 
#'
#' @format ## `get_new_ntee`
#' 
#' @param old.code character string of original NTEE code 
#' 
#' @return A list with `new.code`, thenew disaggregated code, and other related values.
#' See ... Vignette on how these values are calculated. 
#' All known NTEE codes and their respective disaggregated codes are stored 
#' in `ntee-crosswalk` data set. 
#' @export
#' 
#' @examples 
#' get_new_ntee("H96")
#' get_new_ntee("R02")
#' get_new_ntee("R0226")
get_new_ntee <- function(old.code = "B20"){
  
  #find row in ntee crosswalk file 
  #output new rows along with broad category and major group
  input.code <- old.code
  
  c1 <- toupper(base::substr(input.code, 1, 1))
  c2 <- as.numeric(base::substr(input.code, 2, 2))
  c3 <- as.numeric(base::substr(input.code, 3, 3))
  
  
  GOOD <- c1 %in% base::LETTERS & !is.na(c2) & !is.na(c3)
  
  if(!GOOD){
    stop("Input parameter is not a vaild NTEE code.")
  }
  
  #If we already have the code, then just pull the already calculated info
  new.code <-
    ntee.crosswalk %>%
    dplyr::filter(old.code == input.code)
  
  #If we do not have the code, then use the formula to generate the new code
  if(nrow(new.code) != 1){
    new.code <- 
      data.frame(ntee = input.code) %>% 
      ## Get Hospital and Univ indicators
      dplyr::mutate(hosp = ntee %in% c("E20", "E21", "E22", "E24")) %>%
      dplyr::mutate(univ = ntee %in% c("B40", "B41", "B42", "B43", "B50")) %>%
      #Major Group
      dplyr::mutate(major.group = base::substr(ntee, 1, 1)) %>%
      #Broad Category 
      dplyr::mutate(broad.category = dplyr::case_when(major.group == "A" ~ "ART", 
                                               major.group == "B" & !univ ~ "EDU", 
                                               major.group %in% c("C", "D") ~ "ENV",
                                               major.group %in% c("E", "F", "G", "H") & !hosp ~ "HEL",
                                               major.group %in% c("I", "J", "K", "L", "M", "N", "O", "P") ~ "HMS",
                                               major.group == "Q" ~ "IFA", 
                                               major.group %in% c("R", "S", "T", "U", "V", "W") ~ "PSB",
                                               major.group == "X" ~ "REL", 
                                               major.group == "Y" ~ "MMB", 
                                               major.group == "Z" ~ "UNU",
                                               major.group == "B" & univ ~ "UNI", 
                                               major.group == "E" & hosp ~ "HOS"))%>%
      #dissect ntee to get organization type
      dplyr::mutate(two.digit = base::substr(ntee, 2, 3))%>%
      dplyr::mutate(type.org = 
                      dplyr::case_when(
                        two.digit == "01" ~ "AA", 
                        two.digit == "02" ~ "MT",
                        two.digit == "03" ~ "PA",
                        two.digit == "05" ~ "RP",
                        two.digit == "11" ~ "MS", 
                        two.digit == "12" ~ "MM",
                        two.digit == "19" ~ "NS", 
                        TRUE ~ "RG")) %>%
      # dissect ntee to get division
      dplyr::mutate(further.category = base::substr(ntee, 4, 5)) %>%
      dplyr::mutate(division.subdivision = 
                      dplyr::case_when(
                        type.org == "RG" ~ two.digit,
                        type.org != "RG" & nchar(further.category) == 0 ~ "00",
                        type.org != "RG" & nchar(further.category) == 2 ~ further.category)) %>%
      dplyr::mutate(division = base::substr(division.subdivision,1,1))%>%
      dplyr::mutate(subdivision = base::substr(division.subdivision,2,2)) %>%
      #New ntee code
      dplyr::mutate(new.code = paste0(type.org, "-", broad.category, "-", major.group, division.subdivision)) %>% 
      dplyr::select(-division.subdivision)
      
  }
  
  #make as list and remove unnecessary info
  new.code <- as.list(new.code)
  attr(new.code, "spec") <- NULL
  attr(new.code, "problems") <- NULL
  
  
  return(new.code)
}
