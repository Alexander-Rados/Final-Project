#####
# FanGraphs Pitchers Code
#####

library(tidyverse)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
options('mosaic:parallelMessage' = FALSE)

FGpitchers_16 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2016/FGpitchers - FGsixteenpitchers.csv")
WARpitchers_2016 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2016/Pitchers WAR 2016 - FGsixteenpitchers.csv",
                       row.names=1)

FGP_16 = subset(FGpitchers_16, select = -c(Team, playerid, LOB., LD., GB., FB., IFFB., HR.FB, K., BB.,
                                    Soft., Med., Hard.) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}

FGP_16[['Swing.']] = pct_to_number(FGP_16[['Swing.']])
FGP_16[['O.Contact.']] = pct_to_number(FGP_16[['O.Contact.']])
FGP_16[['O.Swing.']] = pct_to_number(FGP_16[['O.Swing.']])
FGP_16[['Z.Swing.']] = pct_to_number(FGP_16[['Z.Swing.']])
FGP_16[['Z.Contact.']] = pct_to_number(FGP_16[['Z.Contact.']])
FGP_16[['Contact.']] = pct_to_number(FGP_16[['Contact.']])
FGP_16[['Zone.']] = pct_to_number(FGP_16[['Zone.']])
FGP_16[['F.Strike.']] = pct_to_number(FGP_16[['F.Strike.']])
FGP_16[['SwStr.']] = pct_to_number(FGP_16[['SwStr.']])
FGP_16[['O.Swing...pfx.']] = pct_to_number(FGP_16[['O.Swing...pfx.']])
FGP_16[['Z.Swing...pfx.']] = pct_to_number(FGP_16[['Z.Swing...pfx.']])
FGP_16[['Swing...pfx.']] = pct_to_number(FGP_16[['Swing...pfx.']])
FGP_16[['O.Contact...pfx.']] = pct_to_number(FGP_16[['O.Contact...pfx.']])
FGP_16[['Z.Contact...pfx.']] = pct_to_number(FGP_16[['Z.Contact...pfx.']])
FGP_16[['Contact...pfx.']] = pct_to_number(FGP_16[['Contact...pfx.']])
FGP_16[['Zone...pfx.']] = pct_to_number(FGP_16[['Zone...pfx.']])
FGP_16[['O.Swing...pi.']] = pct_to_number(FGP_16[['O.Swing...pi.']])
FGP_16[['Z.Swing...pi.']] = pct_to_number(FGP_16[['Z.Swing...pi.']])
FGP_16[['Swing...pi.']] = pct_to_number(FGP_16[['Swing...pi.']])
FGP_16[['Z.Contact...pi.']] = pct_to_number(FGP_16[['Z.Contact...pi.']])
FGP_16[['Contact...pi.']] = pct_to_number(FGP_16[['Contact...pi.']])
FGP_16[['Zone...pi.']] = pct_to_number(FGP_16[['Zone...pi.']])
FGP_16[['O.Contact...pi.']] = pct_to_number(FGP_16[['O.Contact...pi.']])
FGP_16[['K.BB.']] = pct_to_number(FGP_16[['K.BB.']])

FGP_results_16 = FGP_16 %>%
  group_by(Name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="Name")

PCAfgpitchers_16 = prcomp(~ . - WAR, data = FGP_results_16, scale = TRUE)

## variance plot
plot(PCAfgpitchers_16)
summary(PCAfgpitchers_16)

# 10 PCs used for the lowest RMSE (1.317851)
round(PCAfgpitchers_16$rotation[,1:10],2) 

FGpitchersWAR_16 = merge(WARpitchers_2016, PCAfgpitchers_16$x[,1:10], by="row.names")
FGpitchersWAR_16 = rename(FGpitchersWAR_16, Player = Row.names)

ggplot(FGpitchersWAR_16) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(FGpitchersWAR_16)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_FGpitchersWAR_16 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  FGpitchersWAR_16_train = FGpitchersWAR_16[train_cases,]
  FGpitchersWAR_16_test = FGpitchersWAR_16[test_cases,]
  forestFGP_16 = randomForest(WAR ~ . - Player, data = FGpitchersWAR_16_train)
  
  yhat_forestFGP_16 = predict(forestFGP_16, FGpitchersWAR_16_test)
  rmse_forestFGP_16 = mean((yhat_forestFGP_16 - FGpitchersWAR_test$WAR)^2) %>% sqrt
} 
mean(out_rf_FGpitchersWAR_16$result)


#####
# BaseballSavant Pitchers Code
#####

BSpitchers_16 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2016/BSpitchers - BSsixteenpitchers.csv")

BSP_16 = subset(BSpitchers_16, select = -c(last_name, first_name, year, n, n_fastball_formatted, 
                                    fastball_avg_speed, fastball_avg_spin, fastball_avg_break_x,
                                    fastball_avg_break_z, fastball_avg_break, fastball_range_speed,
                                    n_breaking_formatted, breaking_avg_speed, breaking_avg_spin,
                                    breaking_avg_break_x, breaking_avg_break_z, breaking_avg_break,
                                    breaking_range_speed, n_offspeed_formatted, offspeed_avg_speed,
                                    offspeed_avg_spin, offspeed_avg_break_x, offspeed_avg_break_z,
                                    offspeed_avg_break, offspeed_range_speed) )

BSP_results_16 = BSP_16 %>%
  group_by(name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="name")

PCAbspitchers_16 = prcomp(~ . - WAR, data = BSP_results_16, scale = TRUE)

## variance plot
plot(PCAbspitchers_16)
summary(PCAbspitchers_16)

# 7 PCs because it gave the lowest RMSE (1.294131)
round(PCAbspitchers_16$rotation[,1:7],2) 

BSpitchersWAR_16 = merge(WARpitchers_2016, PCAbspitchers_16$x[,1:7], by="row.names")
BSpitchersWAR_16 = rename(BSpitchersWAR_16, Player = Row.names)

ggplot(BSpitchersWAR_16) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(BSpitchersWAR_16)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_BSpitchersWAR_16 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  BSpitchersWAR_16_train = BSpitchersWAR_16[train_cases,]
  BSpitchersWAR_16_test = BSpitchersWAR_16[test_cases,]
  forestBSP_16 = randomForest(WAR ~ . - Player, data = BSpitchersWAR_16_train)
  
  yhat_forestBSP_16 = predict(forestBSP_16, BSpitchersWAR_16_test)
  rmse_forestBSP_16 = mean((yhat_forestBSP_16 - BSpitchersWAR_16_test$WAR)^2) %>% sqrt
} 
mean(out_rf_BSpitchersWAR_16$result)

