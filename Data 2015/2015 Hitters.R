#####
# FanGraphs Hitters Code
#####
library(tidyverse)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
options('mosaic:parallelMessage' = FALSE)

FGhitters_15 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2015/FGhitters - FGfifteenhitters.csv")
WARhitters_2015 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2015/Hitters WAR 2015 - FGfifteenhitters.csv",
                      row.names=1)

# Now look at PCA of the fangraphs stats.  
FG_15 = subset(FGhitters_15, select = -c(FRM, playerid, Team, BB., K., LD., GB., FB., IFFB., HR.FB,
                                   Soft., Med., Hard., pLI, phLI, PH, WPA.LI) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}

FG_15[['Swing.']] = pct_to_number(FG_15[['Swing.']])
FG_15[['O.Contact.']] = pct_to_number(FG_15[['O.Contact.']])
FG_15[['O.Swing.']] = pct_to_number(FG_15[['O.Swing.']])
FG_15[['Z.Swing.']] = pct_to_number(FG_15[['Z.Swing.']])
FG_15[['Z.Contact.']] = pct_to_number(FG_15[['Z.Contact.']])
FG_15[['Contact.']] = pct_to_number(FG_15[['Contact.']])
FG_15[['Zone.']] = pct_to_number(FG_15[['Zone.']])
FG_15[['F.Strike.']] = pct_to_number(FG_15[['F.Strike.']])
FG_15[['SwStr.']] = pct_to_number(FG_15[['SwStr.']])
FG_15[['O.Swing...pfx.']] = pct_to_number(FG_15[['O.Swing...pfx.']])
FG_15[['Z.Swing...pfx.']] = pct_to_number(FG_15[['Z.Swing...pfx.']])
FG_15[['Swing...pfx.']] = pct_to_number(FG_15[['Swing...pfx.']])
FG_15[['O.Contact...pfx.']] = pct_to_number(FG_15[['O.Contact...pfx.']])
FG_15[['Z.Contact...pfx.']] = pct_to_number(FG_15[['Z.Contact...pfx.']])
FG_15[['Contact...pfx.']] = pct_to_number(FG_15[['Contact...pfx.']])
FG_15[['Zone...pfx.']] = pct_to_number(FG_15[['Zone...pfx.']])
FG_15[['O.Swing...pi.']] = pct_to_number(FG_15[['O.Swing...pi.']])
FG_15[['Z.Swing...pi.']] = pct_to_number(FG_15[['Z.Swing...pi.']])
FG_15[['Swing...pi.']] = pct_to_number(FG_15[['Swing...pi.']])
FG_15[['Z.Contact...pi.']] = pct_to_number(FG_15[['Z.Contact...pi.']])
FG_15[['Contact...pi.']] = pct_to_number(FG_15[['Contact...pi.']])
FG_15[['Zone...pi.']] = pct_to_number(FG_15[['Zone...pi.']])
FG_15[['O.Contact...pi.']] = pct_to_number(FG_15[['O.Contact...pi.']])


FG_results_15 = FG_15 %>%
  group_by(Name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="Name")

PCAfghitters_15 = prcomp(~ . - WAR, data = FG_results_15, scale = TRUE)

## variance plot
plot(PCAfghitters_15)
summary(PCAfghitters_15)

# going with 8 PCs as that results in the lowest RMSE
round(PCAfghitters_15$rotation[,1:8],2) 

FGhittersWAR_15 = merge(WARhitters_2015, PCAfghitters_15$x[,1:8], by="row.names")
FGhittersWAR_15 = rename(FGhittersWAR_15, Player = Row.names)

ggplot(FGhittersWAR_15) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(FGhittersWAR_15)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_FGhittersWAR_15 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  FGhittersWAR_15_train = FGhittersWAR_15[train_cases,]
  FGhittersWAR_15_test = FGhittersWAR_15[test_cases,]
  forestFG_15 = randomForest(WAR ~ . - Player, data = FGhittersWAR_15_train)
  
  yhat_forestFG_15 = predict(forestFG_15, FGhittersWAR_15_test)
  rmse_forestFG_15 = mean((yhat_forestFG_15 - FGhittersWAR_15_test$WAR)^2) %>% sqrt
} 
mean(out_rf_FGhittersWAR_15$result)

#####
# BaseballSavant Hitters Code
#####

BShitters_15 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2015/BShitters - BSfifteenhitters.csv")

# Now look at PCA of the fangraphs stats.  
BS_15 = subset(BShitters_15, select = -c(last_name, first_name, year, pop_2b_sba_count, pop_2b_sba, pop_2b_sb, pop_2b_cs, 
                                   pop_3b_sba_count, pop_3b_sba, pop_3b_sb, pop_3b_cs,
                                   exchange_2b_3b_sba, maxeff_arm_2b_3b_sba, n_outs_above_average,
                                   rel_league_reaction_distance, rel_league_burst_distance,
                                   rel_league_routing_distance, rel_league_bootup_distance,
                                   f_bootup_distance, hp_to_1b) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}


BS_results_15 = BS_15 %>%
  group_by(name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="name")

PCAbshitters_15 = prcomp(~ . - WAR, data = BS_results_15, scale = TRUE)

## variance plot
plot(PCAbshitters_15)
summary(PCAbshitters_15)

# cutting it down to 13 PCs because its the lowest RMSE (1.821)
round(PCAbshitters_15$rotation[,1:13],2) 

BShittersWAR_15 = merge(WARhitters_2015, PCAbshitters_15$x[,1:13], by="row.names")
BShittersWAR_15 = rename(BShittersWAR_15, Player = Row.names)

ggplot(BShittersWAR_15) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(BShittersWAR_15)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_BShittersWAR_15 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  BShittersWAR_15_train = BShittersWAR_15[train_cases,]
  BShittersWAR_15_test = BShittersWAR_15[test_cases,]
  forestBS_15 = randomForest(WAR ~ . - Player, data = BShittersWAR_15_train)
  
  yhat_forestBS_15 = predict(forestBS_15, BShittersWAR_15_test)
  rmse_forestBS_15 = mean((yhat_forestBS_15 - BShittersWAR_15_test$WAR)^2) %>% sqrt
} 
mean(out_rf_BShittersWAR_15$result)

