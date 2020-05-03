#####
# FanGraphs Hitters Code
#####

library(tidyverse)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
options('mosaic:parallelMessage' = FALSE)

FGhitters_17 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2017/FGhitters - FGseventeenhitters.csv")
WARhitters_2017 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2017/Hitters WAR 2017 - FGseventeenhitters.csv",
                      row.names=1)

# Now look at PCA of the fangraphs stats.  
FG_17 = subset(FGhitters_17, select = -c(FRM, playerid, Team, BB., K., LD., GB., FB., IFFB., HR.FB,
                                   Soft., Med., Hard., pLI, phLI, PH, WPA.LI) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}

FG_17[['Swing.']] = pct_to_number(FG_17[['Swing.']])
FG_17[['O.Contact.']] = pct_to_number(FG_17[['O.Contact.']])
FG_17[['O.Swing.']] = pct_to_number(FG_17[['O.Swing.']])
FG_17[['Z.Swing.']] = pct_to_number(FG_17[['Z.Swing.']])
FG_17[['Z.Contact.']] = pct_to_number(FG_17[['Z.Contact.']])
FG_17[['Contact.']] = pct_to_number(FG_17[['Contact.']])
FG_17[['Zone.']] = pct_to_number(FG_17[['Zone.']])
FG_17[['F.Strike.']] = pct_to_number(FG_17[['F.Strike.']])
FG_17[['SwStr.']] = pct_to_number(FG_17[['SwStr.']])
FG_17[['O.Swing...pfx.']] = pct_to_number(FG_17[['O.Swing...pfx.']])
FG_17[['Z.Swing...pfx.']] = pct_to_number(FG_17[['Z.Swing...pfx.']])
FG_17[['Swing...pfx.']] = pct_to_number(FG_17[['Swing...pfx.']])
FG_17[['O.Contact...pfx.']] = pct_to_number(FG_17[['O.Contact...pfx.']])
FG_17[['Z.Contact...pfx.']] = pct_to_number(FG_17[['Z.Contact...pfx.']])
FG_17[['Contact...pfx.']] = pct_to_number(FG_17[['Contact...pfx.']])
FG_17[['Zone...pfx.']] = pct_to_number(FG_17[['Zone...pfx.']])
FG_17[['O.Swing...pi.']] = pct_to_number(FG_17[['O.Swing...pi.']])
FG_17[['Z.Swing...pi.']] = pct_to_number(FG_17[['Z.Swing...pi.']])
FG_17[['Swing...pi.']] = pct_to_number(FG_17[['Swing...pi.']])
FG_17[['Z.Contact...pi.']] = pct_to_number(FG_17[['Z.Contact...pi.']])
FG_17[['Contact...pi.']] = pct_to_number(FG_17[['Contact...pi.']])
FG_17[['Zone...pi.']] = pct_to_number(FG_17[['Zone...pi.']])
FG_17[['O.Contact...pi.']] = pct_to_number(FG_17[['O.Contact...pi.']])


FG_results_17 = FG_17 %>%
  group_by(Name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="Name")

PCAfghitters_17 = prcomp(~ . - WAR, data = FG_results_17, scale = TRUE)

## variance plot
plot(PCAfghitters_17)
summary(PCAfghitters_17)

# 5 PCs used for the lowest RMSE (1.72032)
round(PCAfghitters_17$rotation[,1:5],2) 

FGhittersWAR_17 = merge(WARhitters_2017, PCAfghitters_17$x[,1:5], by="row.names")
FGhittersWAR_17 = rename(FGhittersWAR_17, Player = Row.names)

ggplot(FGhittersWAR_17) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(FGhittersWAR_17)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_FGhittersWAR_17 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  FGhittersWAR_17_train = FGhittersWAR_17[train_cases,]
  FGhittersWAR_17_test = FGhittersWAR_17[test_cases,]
  forestFG_17 = randomForest(WAR ~ . - Player, data = FGhittersWAR_17_train)
  
  yhat_forestFG_17 = predict(forestFG_17, FGhittersWAR_17_test)
  rmse_forestFG_17 = mean((yhat_forestFG_17 - FGhittersWAR_17_test$WAR)^2) %>% sqrt
} 
mean(out_rf_FGhittersWAR_17$result)

#####
# BaseballSavant Hitters Code
#####

BShitters_17 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2017/BShitters - BSseventeenhitters.csv")

# Now look at PCA of the fangraphs stats.  
BS_17 = subset(BShitters_17, select = -c(last_name, first_name, year, pop_2b_sba_count, pop_2b_sba, pop_2b_sb, pop_2b_cs, 
                                      pop_3b_sba_count, pop_3b_sba, pop_3b_sb, pop_3b_cs,
                                      exchange_2b_3b_sba, maxeff_arm_2b_3b_sba, n_outs_above_average,
                                      rel_league_reaction_distance, rel_league_burst_distance,
                                      rel_league_routing_distance, rel_league_bootup_distance,
                                      f_bootup_distance))


BS_results_17 = BS_17 %>%
  group_by(name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="name")

PCAbshitters_17 = prcomp(~ . - WAR, data = BS_results_17, scale = TRUE)

## variance plot
plot(PCAbshitters_17)
summary(PCAbshitters_17)

# 11 PCs used for the lowest RMSE (1.795651)
round(PCAbshitters_17$rotation[,1:11],2) 

BShittersWAR_17 = merge(WARhitters_2017, PCAbshitters_17$x[,1:11], by="row.names")
BShittersWAR_17 = rename(BShittersWAR_17, Player = Row.names)

ggplot(BShittersWAR_17) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(BShittersWAR_17)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_BShittersWAR_17 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  BShittersWAR_17_train = BShittersWAR_17[train_cases,]
  BShittersWAR_17_test = BShittersWAR_17[test_cases,]
  forestBS_17 = randomForest(WAR ~ . - Player, data = BShittersWAR_17_train)
  
  yhat_forestBS_17 = predict(forestBS_17, BShittersWAR_17_test)
  rmse_forestBS_17 = mean((yhat_forestBS_17 - BShittersWAR_17_test$WAR)^2) %>% sqrt
} 
mean(out_rf_BShittersWAR_17$result)
