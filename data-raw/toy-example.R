##############################
### Fabricated Toy example for white pages
##############################

## Input org values

NonprofitX <- get_org_values(
  state = "NV", 
  location.type = "rural",
  total.expense = 1575000,
  ntee = "D30")

org1 <- get_org_values(
  state = "CA", 
  location.type = "suburban",
  total.expense = 2400000,
  ntee = "C34")

org2 <- get_org_values(
  state = "UT", 
  location.type = "town",
  total.expense = 1600000,
  ntee = "D32")

org3 <- get_org_values(
  state = "NV", 
  location.type = "town",
  total.expense = 1800000,
  ntee = "D20")

org4 <- get_org_values(
  state = "NV", 
  location.type = "suburban",
  total.expense = 1400000,
  ntee = "C36")
  
org5 <- get_org_values(
  state = "ID", 
  location.type = "rural",
  total.expense = 4300000,
  ntee = "D50")

#bind orgs to make for loops easier later 

all.orgs <- list(org1 = org1, 
                 org2 = org2, 
                 org3 = org3, 
                 org4 = org4,
                 org5 = org5)
  
# Make it a table 

dat <-rbind( as.data.frame(org1), 
             as.data.frame(org2), 
             as.data.frame(org3), 
             as.data.frame(org4),
             as.data.frame(org5))

# add fabricated ceo compensatoins 

dat$ceo.compensation <- c(189000, 202000, 96000, 119000, 421000)

# Get Distances
mission.weights <- get_mission_weights()
geo.weights <- get_geo_weights()

dat$m.dist <- dat$g.dist <- dat$s.dist <- dat$total.dist <- 0

for(i in 1:5){
  dat$m.dist[i] <- get_mission_dist(NonprofitX, all.orgs[[i]], mission.weights)
  dat$g.dist[i] <- get_geo_dist(NonprofitX, all.orgs[[i]], geo.weights)
  dat$s.dist[i] <- log(abs(NonprofitX$total.expense - all.orgs[[i]]$total.expense), base = 10)
}

min.miss <- min(dat$m.dist)
min.geo <-  min(dat$g.dist)
min.size <-  min(dat$s.dist)

dat$total.dist <- 100/3*(dat$m.dist - min.miss + dat$g.dist - min.geo + dat$s.dist - min.size)

dat

# Get weights 

min.dist <- min(dat$total.dist)
max.dist <- max(dat$total.dist)

dat$d <- (dat$total.dist - min.dist) / (max.dist - min.dist)

dat$weight <- (1 - dat$d) / sum(1 - dat$d)

# Get point value estimate 

suggested.salary <-sum(dat$weight * dat$ceo.compensation)
suggested.salary

# Add fabricated predicted ceo compensation from regression modeling step

dat$ceo.hat <- c(170000, 209000, 140000, 132000, 376000)

#get residuals 

dat$e <- dat$ceo.compensation - dat$ceo.hat

sum(dat$e) #residulas sum to 0

# get residuals as percent

dat$p <- dat$e / dat$ceo.compensation

# get percent of suggested salary 

dat$v <- suggested.salary * (1 + dat$p)

#Get quantiles 
quantile(dat$v, probs = c(0.05, 0.95))

