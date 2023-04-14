### Getting Original NTEE codes from 
#https://nccs.urban.org/publication/irs-activity-codes


library(dplyr)
library(readr)


ntee_list <-
  "https://nccs.urban.org/publication/irs-activity-codes" %>%
  xml2::read_html() %>%
  rvest::html_nodes(css = "table") %>%
  rvest::html_table(fill = TRUE)

ntee.orig <- ntee_list[[1]]
names( ntee.orig ) <- c("ntee","description","definition")



### Save data set in package 
save(ntee.orig, file = "data/ntee-orig.rda")
usethis::use_data(ntee.orig, overwrite = T)




# write_csv( ntee.list, "NTEE/all-ntee-original.csv", row.names=F )

# Import data 
ntee.list <- read_csv("NTEE/all-ntee-original.csv")