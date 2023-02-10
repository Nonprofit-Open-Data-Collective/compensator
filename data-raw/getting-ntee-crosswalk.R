# Directly from mission-taxonomies repository at 
# https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies

library(readr)
ntee.crosswalk <- read_csv("https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/mission-taxonomies/main/NTEE-disaggregated/ntee-crosswalk.csv")

colnames(ntee.crosswalk)[1:3] <- c("ntee", "broad.category", "major.group")

save(ntee.crosswalk, file = "data/ntee-crosswalk.rda")
