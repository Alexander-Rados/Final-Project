#####
# FanGraphs Pitchers Code
#####

library(tidyverse)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
options('mosaic:parallelMessage' = FALSE)

FGpitchers_17 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2017/FGpitchers - FGseventeenpitchers.csv")
WARpitchers_2017 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2017/Pitchers WAR 2017 - FGseventeenpitchers.csv",
                       row.names=1)

FGP_17 = subset(FGpitchers_17, select = -c(Team, playerid, LOB., LD., GB., FB., IFFB., HR.FB, K., BB.,
                                    Soft., Med., Hard.) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}

FGP_17[['Swing.']] = pct_to_number(FGP_17[['Swing.']])
FGP_17[['O.Contact.']] = pct_to_number(FGP_17[['O.Contact.']])
FGP_17[['O.Swing.']] = pct_to_number(FGP_17[['O.Swing.']])
FGP_17[['Z.Swing.']] = pct_to_number(FGP_17[['Z.Swing.']])
FGP_17[['Z.Contact.']] = pct_to_number(FGP_17[['Z.Contact.']])
FGP_17[['Contact.']] = pct_to_number(FGP_17[['Contact.']])
FGP_17[['Zone.']] = pct_to_number(FGP_17[['Zone.']])
FGP_17[['F.Strike.']] = pct_to_number(FGP_17[['F.Strike.']])
FGP_17[['SwStr.']] = pct_to_number(FGP_17[['SwStr.']])
FGP_17[['O.Swing...pfx.']] = pct_to_number(FGP_17[['O.Swing...pfx.']])
FGP_17[['Z.Swing...pfx.']] = pct_to_number(FGP_17[['Z.Swing...pfx.']])
FGP_17[['Swing...pfx.']] = pct_to_number(FGP_17[['Swing...pfx.']])
FGP_17[['O.Contact...pfx.']] = pct_to_number(FGP_17[['O.Contact...pfx.']])
FGP_17[['Z.Contact...pfx.']] = pct_to_number(FGP_17[['Z.Contact...pfx.']])
FGP_17[['Contact...pfx.']] = pct_to_number(FGP_17[['Contact...pfx.']])
FGP_17[['Zone...pfx.']] = pct_to_number(FGP_17[['Zone...pfx.']])
FGP_17[['O.Swing...pi.']] = pct_to_number(FGP_17[['O.Swing...pi.']])
FGP_17[['Z.Swing...pi.']] = pct_to_number(FGP_17[['Z.Swing...pi.']])
FGP_17[['Swing...pi.']] = pct_to_number(FGP_17[['Swing...pi.']])
FGP_17[['Z.Contact...pi.']] = pct_to_number(FGP_17[['Z.Contact...pi.']])
FGP_17[['Contact...pi.']] = pct_to_number(FGP_17[['Contact...pi.']])
FGP_17[['Zone...pi.']] = pct_to_number(FGP_17[['Zone...pi.']])
FGP_17[['O.Contact...pi.']] = pct_to_number(FGP_17[['O.Contact...pi.']])
FGP_17[['K.BB.']] = pct_to_number(FGP_17[['K.BB.']])

FGP_results_17 = FGP_17 %>%
  group_by(Name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="Name")

PCAfgpitchers_17 = prcomp(~ . - WAR, data = FGP_results_17, scale = TRUE)

## variance plot
plot(PCAfgpitchers_17)
summary(PCAfgpitchers_17)

# 10 PCs used for the lowest RMSE (1.274874)
round(PCAfgpitchers_17$rotation[,1:10],2) 

FGpitchersWAR_17 = merge(WARpitchers_2017, PCAfgpitchers_17$x[,1:10], by="row.names")
FGpitchersWAR_17 = rename(FGpitchersWAR_17, Player = Row.names)

ggplot(FGpitchersWAR_17) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(FGpitchersWAR_17)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_FGpitchersWAR_17 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  FGpitchersWAR_17_train = FGpitchersWAR_17[train_cases,]
  FGpitchersWAR_17_test = FGpitchersWAR_17[test_cases,]
  forestFGP_17 = randomForest(WAR ~ . - Player, data = FGpitchersWAR_17_train)
  
  yhat_forestFGP_17 = predict(forestFGP_17, FGpitchersWAR_17_test)
  rmse_forestFGP_17 = mean((yhat_forestFGP_17 - FGpitchersWAR_17_test$WAR)^2) %>% sqrt
} 
mean(out_rf_FGpitchersWAR_17$result)


#####
# BaseballSavant Pitchers Code
#####

BSpitchers_17 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2017/BSpitchers - BSseventeenpitchers.csv")

BSP_17 = subset(BSpitchers_17, select = -c(last_name, first_name, year) )

BSP_results_17 = BSP_17 %>%
  group_by(name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="name")

PCAbspitchers_17 = prcomp(~ . - WAR, data = BSP_results_17, scale = TRUE)

## variance plot
plot(PCAbspitchers_17)
summary(PCAbspitchers_17)

# 6 PCs used for the lowest RMSE (1.327133)
round(PCAbspitchers_17$rotation[,1:6],2) 

BSpitchersWAR_17 = merge(WARpitchers_2017, PCAbspitchers_17$x[,1:6], by="row.names")
BSpitchersWAR_17 = rename(BSpitchersWAR_17, Player = Row.names)

ggplot(BSpitchersWAR_17) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(BSpitchersWAR_17)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_BSpitchersWAR_17 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  BSpitchersWAR_17_train = BSpitchersWAR_17[train_cases,]
  BSpitchersWAR_17_test = BSpitchersWAR_17[test_cases,]
  forestBSP_17 = randomForest(WAR ~ . - Player, data = BSpitchersWAR_17_train)
  
  yhat_forestBSP_17 = predict(forestBSP_17, BSpitchersWAR_17_test)
  rmse_forestBSP_17 = mean((yhat_forestBSP_17 - BSpitchersWAR_17_test$WAR)^2) %>% sqrt
} 
mean(out_rf_BSpitchersWAR_17$result)
