## This script creates both nonprofits.rda and EIN_filtering.rda

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
  dplyr::mutate(location.type = ifelse(location.type == "metropolitan", "metro", location.type))


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
  #hosp and univ change levels
  dplyr::mutate(broad.category = ifelse(hosp, 12, broad.category),
         broad.category = ifelse(univ, 11, broad.category)) %>%
  #dissect ntee to get mission levels
  dplyr::mutate(two.digit = substr(ntee, 2, 3))%>%
  #Regular or specality org
  dplyr::mutate(type.org = ifelse(two.digit < 20, "speciality", "regular")) %>%
  #get actual two digit if specality or
  dplyr::mutate(two.digit.s = dplyr::case_when(type.org == "speciality" & nchar(ntee) == 4 ~ paste(substr(ntee, 4, 4), 0),
                                             type.org == "speciality" & nchar(ntee) == 5 ~ paste(substr(ntee, 4, 5)),
                                             TRUE ~ two.digit)) %>%
  #get decile and centile values
  dplyr::mutate(tens = substr(two.digit.s, 1, 1)) %>%
  dplyr::mutate(ones = substr(two.digit.s, 2, 2)) %>%
  #us state or not
  dplyr::mutate(us.state = state != "PR" )






## Make user data  --------------------------------------------------------
nonprofits <-
  temp %>%
  dplyr::select(EIN, form.year, name,  ntee, univ, hosp,
                total.expense, total.employee, gross.receipts, total.assests,
                ceo.compensation, gender,
                state, zip5, location.type)

save(nonprofits, file = "data/nonprofits.rda")
#usethis::use_data(nonprofits, overwrite = T)

### Data for the back end -------------------------------------------------
EIN.filtering <-
  temp %>%
  dplyr::select(EIN, ntee, broad.category, major.group, type.org,
                two.digit, two.digit.s, tens, ones, us.state,
                univ, hosp,
                total.expense,
                state, location.type)

save(EIN.filtering, file = "data/EIN-filtering.rda")
#usethis::use_data(EIN.filtering, overwrite = T, internal = T)
