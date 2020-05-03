#####
# FanGraphs Hitters Code
#####

library(tidyverse)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
options('mosaic:parallelMessage' = FALSE)

FGhitters_18 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2018/FGhitters - FGeighteenhitters.csv")
WARhitters_2018 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2018/Hitters WAR 2018 - FGeighteenhitters.csv",
                      row.names=1)

# Now look at PCA of the fangraphs stats.  
FG_18 = subset(FGhitters_18, select = -c(FRM, playerid, Team, BB., K., LD., GB., FB., IFFB., HR.FB,
                                   Soft., Med., Hard., pLI, phLI, PH, WPA.LI) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}

FG_18[['Swing.']] = pct_to_number(FG_18[['Swing.']])
FG_18[['O.Contact.']] = pct_to_number(FG_18[['O.Contact.']])
FG_18[['O.Swing.']] = pct_to_number(FG_18[['O.Swing.']])
FG_18[['Z.Swing.']] = pct_to_number(FG_18[['Z.Swing.']])
FG_18[['Z.Contact.']] = pct_to_number(FG_18[['Z.Contact.']])
FG_18[['Contact.']] = pct_to_number(FG_18[['Contact.']])
FG_18[['Zone.']] = pct_to_number(FG_18[['Zone.']])
FG_18[['F.Strike.']] = pct_to_number(FG_18[['F.Strike.']])
FG_18[['SwStr.']] = pct_to_number(FG_18[['SwStr.']])
FG_18[['O.Swing...pfx.']] = pct_to_number(FG_18[['O.Swing...pfx.']])
FG_18[['Z.Swing...pfx.']] = pct_to_number(FG_18[['Z.Swing...pfx.']])
FG_18[['Swing...pfx.']] = pct_to_number(FG_18[['Swing...pfx.']])
FG_18[['O.Contact...pfx.']] = pct_to_number(FG_18[['O.Contact...pfx.']])
FG_18[['Z.Contact...pfx.']] = pct_to_number(FG_18[['Z.Contact...pfx.']])
FG_18[['Contact...pfx.']] = pct_to_number(FG_18[['Contact...pfx.']])
FG_18[['Zone...pfx.']] = pct_to_number(FG_18[['Zone...pfx.']])
FG_18[['O.Swing...pi.']] = pct_to_number(FG_18[['O.Swing...pi.']])
FG_18[['Z.Swing...pi.']] = pct_to_number(FG_18[['Z.Swing...pi.']])
FG_18[['Swing...pi.']] = pct_to_number(FG_18[['Swing...pi.']])
FG_18[['Z.Contact...pi.']] = pct_to_number(FG_18[['Z.Contact...pi.']])
FG_18[['Contact...pi.']] = pct_to_number(FG_18[['Contact...pi.']])
FG_18[['Zone...pi.']] = pct_to_number(FG_18[['Zone...pi.']])
FG_18[['O.Contact...pi.']] = pct_to_number(FG_18[['O.Contact...pi.']])


FG_results_18 = FG_18 %>%
  group_by(Name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="Name")

PCAfghitters_18 = prcomp(~ . - WAR, data = FG_results_18, scale = TRUE)

## variance plot
plot(PCAfghitters_18)
summary(PCAfghitters_18)

# 23 PCs used for the lowest RMSE (1.728532)
round(PCAfghitters$rotation[,1:23],2) 

FGhittersWAR_2018 = merge(WARhitters_2018, PCAfghitters_18$x[,1:23], by="row.names")
FGhittersWAR_2018 = rename(FGhittersWAR_2018, Player = Row.names)

ggplot(FGhittersWAR_2018) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(FGhittersWAR_2018)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_FGhittersWAR_2018 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  FGhittersWAR_2018_train = FGhittersWAR_2018[train_cases,]
  FGhittersWAR_2018_test = FGhittersWAR_2018[test_cases,]
  forestFG_18 = randomForest(WAR ~ . - Player, data = FGhittersWAR_2018_train)
  
  yhat_forestFG_18 = predict(forestFG_18, FGhittersWAR_2018_test)
  rmse_forestFG_18 = mean((yhat_forestFG_18 - FGhittersWAR_2018_test$WAR)^2) %>% sqrt
} 
mean(out_rf_FGhittersWAR_2018$result)

#####
# BaseballSavant Hitters Code
#####
BShitters_18 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2018/BShitters - BSeighteenhitters.csv")

# Now look at PCA of the fangraphs stats.  
BS_18 = subset(BShitters_18, select = -c(last_name, first_name, year, pop_2b_sba_count, pop_2b_sba, pop_2b_sb, pop_2b_cs, 
                                      pop_3b_sba_count, pop_3b_sba, pop_3b_sb, pop_3b_cs,
                                      exchange_2b_3b_sba, maxeff_arm_2b_3b_sba, n_outs_above_average,
                                      rel_league_reaction_distance, rel_league_burst_distance,
                                      rel_league_routing_distance, rel_league_bootup_distance,
                                      f_bootup_distance))


BS_results_18 = BS_18 %>%
  group_by(name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="name")

PCAbshitters_18 = prcomp(~ . - WAR, data = BS_results_18, scale = TRUE)

## variance plot
plot(PCAbshitters_18)
summary(PCAbshitters_18)

# 10 PCs used for the lowest RMSE (1.788214)
round(PCAbshitters_18$rotation[,1:10],2) 

BShittersWAR_2018 = merge(WARhitters_2018, PCAbshitters_18$x[,1:10], by="row.names")
BShittersWAR_2018 = rename(BShittersWAR_2018, Player = Row.names)

ggplot(BShittersWAR_2018) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(BShittersWAR_2018)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_BShittersWAR_2018 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  BShittersWAR_2018_train = BShittersWAR_2018[train_cases,]
  BShittersWAR_2018_test = BShittersWAR_2018[test_cases,]
  forestBS_18 = randomForest(WAR ~ . - Player, data = BShittersWAR_2018_train)
  
  yhat_forestBS_18 = predict(forestBS_18, BShittersWAR_2018_test)
  rmse_forestBS_18 = mean((yhat_forestBS_18 - BShittersWAR_2018_test$WAR)^2) %>% sqrt
} 
mean(out_rf_BShittersWAR_2018$result)
