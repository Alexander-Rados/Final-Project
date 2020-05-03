#####
# FanGraphs Hitters Code
#####

library(tidyverse)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
options('mosaic:parallelMessage' = FALSE)

FGhitters_16 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2016/FGhitters - FGsixteenhitters.csv")
WARhitters_2016 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2016/Hitters WAR 2016 - FGsixteenhitters.csv",
                      row.names=1)

# Now look at PCA of the fangraphs stats.  
FG_16 = subset(FGhitters_16, select = -c(FRM, playerid, Team, BB., K., LD., GB., FB., IFFB., HR.FB,
                                   Soft., Med., Hard., pLI, phLI, PH, WPA.LI) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}

FG_16[['Swing.']] = pct_to_number(FG_16[['Swing.']])
FG_16[['O.Contact.']] = pct_to_number(FG_16[['O.Contact.']])
FG_16[['O.Swing.']] = pct_to_number(FG_16[['O.Swing.']])
FG_16[['Z.Swing.']] = pct_to_number(FG_16[['Z.Swing.']])
FG_16[['Z.Contact.']] = pct_to_number(FG_16[['Z.Contact.']])
FG_16[['Contact.']] = pct_to_number(FG_16[['Contact.']])
FG_16[['Zone.']] = pct_to_number(FG_16[['Zone.']])
FG_16[['F.Strike.']] = pct_to_number(FG_16[['F.Strike.']])
FG_16[['SwStr.']] = pct_to_number(FG_16[['SwStr.']])
FG_16[['O.Swing...pfx.']] = pct_to_number(FG_16[['O.Swing...pfx.']])
FG_16[['Z.Swing...pfx.']] = pct_to_number(FG_16[['Z.Swing...pfx.']])
FG_16[['Swing...pfx.']] = pct_to_number(FG_16[['Swing...pfx.']])
FG_16[['O.Contact...pfx.']] = pct_to_number(FG_16[['O.Contact...pfx.']])
FG_16[['Z.Contact...pfx.']] = pct_to_number(FG_16[['Z.Contact...pfx.']])
FG_16[['Contact...pfx.']] = pct_to_number(FG_16[['Contact...pfx.']])
FG_16[['Zone...pfx.']] = pct_to_number(FG_16[['Zone...pfx.']])
FG_16[['O.Swing...pi.']] = pct_to_number(FG_16[['O.Swing...pi.']])
FG_16[['Z.Swing...pi.']] = pct_to_number(FG_16[['Z.Swing...pi.']])
FG_16[['Swing...pi.']] = pct_to_number(FG_16[['Swing...pi.']])
FG_16[['Z.Contact...pi.']] = pct_to_number(FG_16[['Z.Contact...pi.']])
FG_16[['Contact...pi.']] = pct_to_number(FG_16[['Contact...pi.']])
FG_16[['Zone...pi.']] = pct_to_number(FG_16[['Zone...pi.']])
FG_16[['O.Contact...pi.']] = pct_to_number(FG_16[['O.Contact...pi.']])


FG_results_16 = FG_16 %>%
  group_by(Name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="Name")

PCAfghitters_16 = prcomp(~ . - WAR, data = FG_results_16, scale = TRUE)

## variance plot
plot(PCAfghitters_16)
summary(PCAfghitters_16)

# 9 PCs used for the lowest RMSE (1.659325)
round(PCAfghitters_16$rotation[,1:9],2) 

FGhittersWAR_16 = merge(WARhitters_2016, PCAfghitters_16$x[,1:9], by="row.names")
FGhittersWAR_16 = rename(FGhittersWAR_16, Player = Row.names)

ggplot(FGhittersWAR_16) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(FGhittersWAR_16)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_FGhittersWAR_16 = do(100)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  FGhittersWAR_16_train = FGhittersWAR_16[train_cases,]
  FGhittersWAR_16_test = FGhittersWAR_16[test_cases,]
  forestFG_16 = randomForest(WAR ~ . - Player, data = FGhittersWAR_16_train)
  
  yhat_forestFG_16 = predict(forestFG_16, FGhittersWAR_16_test)
  rmse_forestFG_16 = mean((yhat_forestFG_16 - FGhittersWAR_16_test$WAR)^2) %>% sqrt
} 
mean(out_rf_FGhittersWAR_16$result)

#####
# BaseballSavant Hitters Code
#####

BShitters_16 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2016/BShitters - BSsixteenhitters.csv")

# Now look at PCA of the fangraphs stats.  
BS_16 = subset(BShitters_16, select = -c(last_name, first_name, year, pop_2b_sba_count, pop_2b_sba, pop_2b_sb, pop_2b_cs, 
                                      pop_3b_sba_count, pop_3b_sba, pop_3b_sb, pop_3b_cs,
                                      exchange_2b_3b_sba, maxeff_arm_2b_3b_sba, n_outs_above_average,
                                      rel_league_reaction_distance, rel_league_burst_distance,
                                      rel_league_routing_distance, rel_league_bootup_distance,
                                      f_bootup_distance, hp_to_1b) )

BS_results_16 = BS_16 %>%
  group_by(name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="name")

PCAbshitters_16 = prcomp(~ . - WAR, data = BS_results_16, scale = TRUE)

## variance plot
plot(PCAbshitters_16)
summary(PCAbshitters_16)

# 25 PCs used for the lowest RMSE (1.807622)
round(PCAbshitters_16$rotation[,1:25],2) 

BShittersWAR_16 = merge(WARhitters_2016, PCAbshitters_16$x[,1:25], by="row.names")
BShittersWAR_16 = rename(BShittersWAR_16, Player = Row.names)

ggplot(BShittersWAR_16) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(BShittersWAR_16)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_BShittersWAR_16 = do(100)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  BShittersWAR_16_train = BShittersWAR_16[train_cases,]
  BShittersWAR_16_test = BShittersWAR_16[test_cases,]
  forestBS_16 = randomForest(WAR ~ . - Player, data = BShittersWAR_16_train)
  
  yhat_forestBS_16 = predict(forestBS_16, BShittersWAR_16_test)
  rmse_forestBS_16 = mean((yhat_forestBS_16 - BShittersWAR_16_test$WAR)^2) %>% sqrt
} 
mean(out_rf_BShittersWAR_16$result)
