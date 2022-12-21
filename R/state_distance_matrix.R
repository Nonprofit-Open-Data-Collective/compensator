#' State Distance Matrix
#'
#' A 52-by-52 matrix of distances between all US states (and D.C. and PR)
#' Distance is calculated by creating a network of U.S. states as follows:
#' 1. Turn all states into vertices and all boarders into edges. 
#' 2. Add edges between Alaska and Washington, Hawaii and California, Puerto Rico and Florida.
#' 3. Distance between two states is the path length between them. 
#' 
#' Equivalently, this is the number of states you need to go through to drive from state A to state B,
#' with the added boarders of Alaska/Washington, Hawaii/California, and Puerto Rico/Florida.
#'
#' @format ## `state_distance_matrix`
#' - the (i, j) entry is the path length from state i to state j. 
#' - the diagonal is 0
#' 
#' 
"state_distance_matrix"