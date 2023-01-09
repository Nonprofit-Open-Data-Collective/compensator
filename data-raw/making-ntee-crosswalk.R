### Crosswalk 
library(tidyverse)
library(rvest)

ntee_list <- 
  "https://nccs.urban.org/publication/irs-activity-codes" %>%
  xml2::read_html() %>%
  rvest::html_nodes(css = "table") %>%
  rvest::html_table(fill = TRUE)

ntee_list <- ntee_list[[1]]

# write.csv( ntee_list, "ntee.csv", row.names=F )

#extract major groups (letters)
ntee_major_group <- ntee_list[ which(nchar(ntee_list$`NTEE Code`) < 3), ]

#extract ntee codes (letter + 2digits)
ntee_codes <- ntee_list[ which(nchar(ntee_list$`NTEE Code`) == 3), ]


## get broad categories 
ntee.crosswalk <- 
  ntee_codes %>%
  dplyr::rename(NTEE = `NTEE Code`) %>%
  dplyr::mutate(MajorGroup = substr(NTEE, 1, 1)) %>%
  #dissect NTEE to get mission levels
  dplyr::mutate(two.digit = substr(NTEE, 2, 3))%>%
  #Regular or specialty org
  dplyr::mutate(type.org = ifelse(two.digit < 20, "S", "R")) %>%
  # not needed for cross walk, only needed for actual organizations. 
  # explanation in RMD
  #get further two digit if available for specialty or just two.digit if not available 
  dplyr::mutate(two.digit.s = dplyr::case_when(type.org == "S" & nchar(NTEE) == 4 ~ paste(substr(NTEE, 4, 4), 0),
                                               type.org == "S" & nchar(NTEE) == 5 ~ paste(substr(NTEE, 4, 5)),
                                               TRUE ~ two.digit)) %>%
  #get decile values
  dplyr::mutate(tens = substr(two.digit.s, 1, 1)) %>%
  dplyr::mutate(tens = ifelse(tens < 2, 0, tens)) %>% #all specialty orgs get 0 in the tens place
  # get centile values
  dplyr::mutate(ones = substr(two.digit.s, 2, 2)) %>%
  #get Hosp
  dplyr::mutate(hosp = ifelse(MajorGroup == "E" & tens == 2, TRUE, FALSE)) %>%
  #get Univ 
  dplyr::mutate(univ = ifelse(MajorGroup == "B" & (tens == 4 | tens == 5), TRUE, FALSE))  %>%
  #Broad Category
  dplyr::mutate(BroadCategory = case_when(MajorGroup == "A" ~ 1, 
                                        MajorGroup == "B" & !univ ~ 2, 
                                        MajorGroup %in% c("C", "D") ~ 3,
                                        MajorGroup %in% c("E", "F", "G", "H") & !hosp ~ 4,
                                        MajorGroup %in% c("I", "J", "K", "L", "M", "N", "O", "P") ~ 5,
                                        MajorGroup == "Q" ~ 6, 
                                        MajorGroup %in% c("R", "S", "T", "U", "V", "W") ~ 7,
                                        MajorGroup == "X" ~ 8, 
                                        MajorGroup == "Y" ~ 9, 
                                        MajorGroup == "Z" ~ 10,
                                        MajorGroup == "B" & univ ~ 11, 
                                        MajorGroup == "E" & hosp ~ 12))%>%
  dplyr::relocate(BroadCategory, .before = MajorGroup)





## Save 
save(ntee.crosswalk, file = "data/ntee-crosswalk.rda")


