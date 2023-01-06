## Needed Libraries 
library(xml2)
library(rvest)

### Original Get data and standardize -----------------------------------
state_list <- 
  "https://thefactfile.org/u-s-states-and-their-border-states/" %>%
  xml2::read_html() %>%
  rvest::html_nodes(css = "table") %>%
  rvest::html_table(fill = TRUE)

state_list <- state_list[[1]]
state_list$`Serial number` <- as.character(state_list$`Serial number`)


#change Alaska
state_list[2, 3:4] <- matrix(c("Washington", "1"), nrow = 1)
#change Hawaii
state_list[11, 3:4] <- matrix(c("California", "1"), nrow = 1)
#Add PR
state_list[51, ] <- matrix(c("51", "Puerto Rico", "Florida", "1"), nrow = 1)
#Add DC
state_list[52, ] <- matrix(c("52", "District of Columbia", "Virginia, Maryland", "2"), nrow = 1)

#Standardize State Name
state_list$`State name`[19] <- "Maine"
state_list$`State name`[25] <- "Missouri"
state_list$`State name`[42] <- "Tennessee"


### Standardize table
state_list <- 
  state_list %>%
  dplyr::arrange(`State name`) %>%
  dplyr::mutate(order = row_number()) %>%
  dplyr::rename(state = `State name`,
                border = `Bordering State`, 
                num.border = `Number of bordering states`) %>%
  #add census regions if we want them later
  dplyr::mutate(region  = c(6, 9, 8, 7, 9, 8, 1, 1, 5, 5, 
                            5, 9, 8, 3, 3, 5, 4, 6, 7, 1,  #start with Georgia ends with Maine
                            1, 1, 6, 4, 6, 4, 8, 4, 8, 1,   #starts with Maryland ends with New Hampshire
                            1, 8, 1, 5, 4, 3, 7, 9, 1, 5,  #starts with New Jersey
                            1, 5, 4, 6, 7, 8, 1, 5, 8, 5, 
                            3, 8  )) %>%
  dplyr::mutate(abb = c(state.abb[1:8], "DC", state.abb[9:38], "PR", state.abb[39:50])) %>%
  dplyr::select(-1) 

### Save to not need to scrape anymore 
state.borders <- state_list
save(state.borders, file = "data-raw/state-borders.rda")