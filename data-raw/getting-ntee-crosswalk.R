# Directly from mission-taxonomies repository at 
# https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies

library(readr)
ntee.crosswalk <- read_csv("https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/mission-taxonomies/main/NTEE-disaggregated/ntee-crosswalk.csv")

save(ntee.crosswalk, file = "data/ntee-crosswalk.rda")
