## This script crease both nonprofits.rda and EIN_filtering.rda

## Read in data --------------------------------------------------------
dat.clean<- read_csv("data-raw/all-dat-cleaned.csv")


### Formatting data for package --------------------------------------------------------
temp <-
  dat.clean %>%
  dplyr::filter(!TransitionYr) %>%
  dplyr::rename(BroadCategory = MajorGroup,
                MajorGroup = NTEE,
                NTEE = NTEE.CC,
                University = UNIV,
                Hospital = HOSP) %>%
  dplyr::mutate(LocationType = tolower(LocationType))
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
  dplyr::mutate(BroadCategory = ifelse(Hospital, 12, BroadCategory),
         BroadCategory = ifelse(University, 11, BroadCategory)) %>%
  #dissect NTEE to get mission levels
  dplyr::mutate(two.digit = substr(NTEE, 2, 3))%>%
  #Regular or specality org
  dplyr::mutate(type.org = ifelse(two.digit < 20, "S", "R")) %>%
  #get actual two digit if specality or
  dplyr::mutate(two.digit.s = dplyr::case_when(type.org == "S" & nchar(NTEE) == 4 ~ paste(substr(NTEE, 4, 4), 0),
                                             type.org == "S" & nchar(NTEE) == 5 ~ paste(substr(NTEE, 4, 5)),
                                             TRUE ~ two.digit)) %>%
  #get decile and centile values
  dplyr::mutate(tens = substr(two.digit.s, 1, 1)) %>%
  dplyr::mutate(ones = substr(two.digit.s, 2, 2)) %>%
  #us state or not
  dplyr::mutate(us.state = State != "PR" )



## Make user data  --------------------------------------------------------
nonprofits <-
  temp %>%
  dplyr::select(EIN, FormYr, Name,  NTEE, University, Hospital,
         TotalExpense, TotalEmployee, GrossReceipts, TotalAssests,
         CEOCompensation, Gender,
         State, ZIP5, LocationType)

save(nonprofits, file = "data/nonprofits.rda")
#usethis::use_data(nonprofits, overwrite = T)

### Data for the back end -------------------------------------------------
EIN.filtering <-
  temp %>%
  dplyr::select(EIN, NTEE, BroadCategory, MajorGroup, type.org,
                two.digit, two.digit.s, tens, ones, us.state,
                University, Hospital,
                TotalExpense,
                State, LocationType)

save(EIN.filtering, file = "data/EIN-filtering.rda")
#usethis::use_data(EIN.filtering, overwrite = T, internal = T)
