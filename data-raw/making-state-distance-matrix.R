library(tidyverse)
library(igraph)

### Get data  -----------------------------------
load("data-raw/state-borders.rda")

### Make graph distances  ---------------------------------------------

state_list <- state.borders

AdjMat <- matrix(0, ncol = 52, nrow = 52)
for(i in 1:52){
  border <- strsplit(state_list$border[i], split = ", ")[[1]]
  AdjMat[i, ] <- as.numeric(state_list$state %in% border)
}

g <- graph_from_adjacency_matrix(AdjMat, mode = "undirected" )

state_dist <- as.data.frame(distances(g)) / max(distances(g)) # divide by 12 to standardize between 0 and 1
colnames(state_dist) <- rownames(state_dist) <- state_list$abb

### Save Matrix -----------------------------------
state.dist.mat <- state_dist
save(state.dist.mat, file = "data/state-dist-matrix.rda")
#usethis::use_data(state.dist.mat, overwrite = T)
