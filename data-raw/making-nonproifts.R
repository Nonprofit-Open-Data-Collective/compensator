## This script creates both nonprofits.rda and EIN_filtering.rda
library(dplyr)
## Read in data --------------------------------------------------------
dat.clean<- readr::read_csv("data-raw/all-dat-cleaned.csv")


### Formatting data for package --------------------------------------------------------
temp <-
  dat.clean %>%
  #remove transition years
  dplyr::filter(!TransitionYr) %>%
  dplyr::select(-c(TransitionYr, TRANS.D))%>%
  #rename to dot case from camel case 
  dplyr::rename(
    form.year = FormYr, 
    form.type = FormType,
    name = Name,
    state = State, 
    broad.category = MajorGroup,
    major.group = NTEE,
    ntee = NTEE.CC,
    univ = UNIV,
    hosp = HOSP,    
    total.expense = TotalExpense,
    total.employee = TotalEmployee,
    gross.receipts = GrossReceipts, 
    total.assests = TotalAssests, 
    ceo.compensation = CEOCompensation,
    gender = Gender,
    zip5 = ZIP5,
    location.type = LocationType,
    fips = FIPS) %>%
  #standardize location type 
  dplyr::mutate(location.type = tolower(location.type)) %>%
  #adding more levels to location type 
  dplyr::mutate(location.type = dplyr::case_when(
    RUCA < 2 ~ "metro", 
    RUCA >=2 & RUCA < 4 ~ "suburban",
    RUCA >=4 & RUCA < 7 ~ "town",
    RUCA >= 7 ~ "rural"
  ))


# get rid of EIN's that show up twice for some reason
badEIN <-
  temp%>%
  dplyr::select(EIN) %>%
  dplyr::group_by(EIN) %>%
  dplyr::summarise(count = dplyr::n()) %>%
  dplyr::filter(count > 1) %>%
  dplyr::select(EIN)

temp <-
  temp %>%
  dplyr::filter(!(EIN %in% badEIN$EIN))

## Get levels for matching  --------------------------------------------------------
temp <-
  temp %>%
  #Major Group
  dplyr::mutate(major.group = substr(ntee, 1, 1)) %>%
  #Broad Category 
  dplyr::mutate(broad.category = case_when(major.group == "A" ~ "ART", 
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
  dplyr::mutate(two.digit = substr(ntee, 2, 3))%>%
  dplyr::mutate(type.org = 
                  case_when(
                    two.digit == "01" ~ "AA", 
                    two.digit == "02" ~ "MT",
                    two.digit == "03" ~ "PA",
                    two.digit == "05" ~ "RP",
                    two.digit == "11" ~ "MS", 
                    two.digit == "12" ~ "MM",
                    two.digit == "19" ~ "NS", 
                    TRUE ~ "RG")) %>%
  # dissect ntee to get division
  dplyr::mutate(further.category = substr(ntee, 4, 5)) %>%
  dplyr::mutate(division.subdivision = 
                  case_when(
                    type.org == "RG" ~ two.digit,
                    type.org != "RG" & nchar(further.category) == 0 ~ "00",
                    type.org != "RG" & nchar(further.category) == 2 ~ further.category)) %>%
  dplyr::mutate(division = substr(division.subdivision,1,1))%>%
  dplyr::mutate(subdivision = substr(division.subdivision,2,2)) %>%
  #New ntee code
  dplyr::mutate(new.code = paste0(type.org, "-", broad.category, "-", major.group, division.subdivision)) %>%
  #propublica link
  dplyr::mutate(url = paste0("https://projects.propublica.org/nonprofits/organizations/", EIN)) 





## Make user data  --------------------------------------------------------
nonprofits <-
  temp %>%
  dplyr::select(EIN, form.year, form.type, name,  url, 
                ntee, new.code, univ, hosp,
                total.expense, total.employee, gross.receipts, total.assests,
                ceo.compensation, gender,
                state, zip5, location.type)

save(nonprofits, file = "data/nonprofits.rda")
usethis::use_data(nonprofits, overwrite = T)

### Data for the back end -------------------------------------------------
nonprofits.detailed <-
  temp %>%
  dplyr::select(EIN, ntee, new.code, 
                type.org, broad.category, major.group, division, subdivision, 
                univ, hosp, total.expense, state, location.type, RUCA)

save(nonprofits.detailed, file = "data/EIN-filtering.rda")
usethis::use_data(nonprofits.detailed, overwrite = T, internal = T)
