#####
# FanGraphs Pitchers Code
#####

library(tidyverse)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
options('mosaic:parallelMessage' = FALSE)

FGpitchers_15 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2015/FGpitchers - FGfifteenpitchers.csv")
WARpitchers_2015 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2015/Pitchers WAR 2015 - FGfifteenpitchers.csv",
                      row.names=1)

FGP_15 = subset(FGpitchers_15, select = -c(Team, playerid, LOB., LD., GB., FB., IFFB., HR.FB, K., BB.,
                                   Soft., Med., Hard.) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}

FGP_15[['Swing.']] = pct_to_number(FGP_15[['Swing.']])
FGP_15[['O.Contact.']] = pct_to_number(FGP_15[['O.Contact.']])
FGP_15[['O.Swing.']] = pct_to_number(FGP_15[['O.Swing.']])
FGP_15[['Z.Swing.']] = pct_to_number(FGP_15[['Z.Swing.']])
FGP_15[['Z.Contact.']] = pct_to_number(FGP_15[['Z.Contact.']])
FGP_15[['Contact.']] = pct_to_number(FGP_15[['Contact.']])
FGP_15[['Zone.']] = pct_to_number(FGP_15[['Zone.']])
FGP_15[['F.Strike.']] = pct_to_number(FGP_15[['F.Strike.']])
FGP_15[['SwStr.']] = pct_to_number(FGP_15[['SwStr.']])
FGP_15[['O.Swing...pfx.']] = pct_to_number(FGP_15[['O.Swing...pfx.']])
FGP_15[['Z.Swing...pfx.']] = pct_to_number(FGP_15[['Z.Swing...pfx.']])
FGP_15[['Swing...pfx.']] = pct_to_number(FGP_15[['Swing...pfx.']])
FGP_15[['O.Contact...pfx.']] = pct_to_number(FGP_15[['O.Contact...pfx.']])
FGP_15[['Z.Contact...pfx.']] = pct_to_number(FGP_15[['Z.Contact...pfx.']])
FGP_15[['Contact...pfx.']] = pct_to_number(FGP_15[['Contact...pfx.']])
FGP_15[['Zone...pfx.']] = pct_to_number(FGP_15[['Zone...pfx.']])
FGP_15[['O.Swing...pi.']] = pct_to_number(FGP_15[['O.Swing...pi.']])
FGP_15[['Z.Swing...pi.']] = pct_to_number(FGP_15[['Z.Swing...pi.']])
FGP_15[['Swing...pi.']] = pct_to_number(FGP_15[['Swing...pi.']])
FGP_15[['Z.Contact...pi.']] = pct_to_number(FGP_15[['Z.Contact...pi.']])
FGP_15[['Contact...pi.']] = pct_to_number(FGP_15[['Contact...pi.']])
FGP_15[['Zone...pi.']] = pct_to_number(FGP_15[['Zone...pi.']])
FGP_15[['O.Contact...pi.']] = pct_to_number(FGP_15[['O.Contact...pi.']])
FGP_15[['K.BB.']] = pct_to_number(FGP_15[['K.BB.']])

PFG_results_15 = FGP_15 %>%
  group_by(Name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="Name")

PCAfgpitchers_15 = prcomp(~ . - WAR, data = PFG_results_15, scale = TRUE)

## variance plot
plot(PCAfgpitchers_15, main = 
       "Percent Variation Explained by Each Principal Component", 
     xlab = "Principal Components")
summary(PCAfgpitchers_15)

# 9 PCs used for the lowest RMSE (1.241023)
round(PCAfgpitchers_15$rotation[,1:9],2) 

FGpitchersWAR_15 = merge(WARpitchers_2015, PCAfgpitchers_15$x[,1:9], by="row.names")
FGpitchersWAR_15 = rename(FGpitchersWAR_15, Player = Row.names)

ggplot(FGpitchersWAR_15) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2)

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(FGpitchersWAR_15)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_FGpitchersWAR_15 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  FGpitchersWAR_15_train = FGpitchersWAR_15[train_cases,]
  FGpitchersWAR_15_test = FGpitchersWAR_15[test_cases,]
  forestPFG_15 = randomForest(WAR ~ . - Player, data = FGpitchersWAR_15_train)
  
  yhat_forestPFG_15 = predict(forestPFG_15, FGpitchersWAR_15_test)
  rmse_forestPFG_15 = mean((yhat_forestPFG_15 - FGpitchersWAR_15_test$WAR)^2) %>% sqrt
} 
mean(out_rf_FGpitchersWAR_15$result)


#####
# BaseballSavant Pitchers Code
#####

BSpitchers_15 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2015/BSpitchers - BSfifteenpitchers.csv")

BSP_15 = subset(BSpitchers_15, select = -c(last_name, first_name, year, n, n_fastball_formatted, 
                                    fastball_avg_speed, fastball_avg_spin, fastball_avg_break_x,
                                    fastball_avg_break_z, fastball_avg_break, fastball_range_speed,
                                    n_breaking_formatted, breaking_avg_speed, breaking_avg_spin,
                                    breaking_avg_break_x, breaking_avg_break_z, breaking_avg_break,
                                    breaking_range_speed, n_offspeed_formatted, offspeed_avg_speed,
                                    offspeed_avg_spin, offspeed_avg_break_x, offspeed_avg_break_z,
                                    offspeed_avg_break, offspeed_range_speed) )

BSP_results_15 = BSP_15 %>%
  group_by(name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="name")

PCAbspitchers_15 = prcomp(~ . - WAR, data = BSP_results_15, scale = TRUE)

## variance plot
plot(PCAbspitchers_15, main = 
       "Percent Variation Explained by Each Principal Component")
summary(PCAbspitchers_15)

# 10 PCs because it gave the lowest RMSE (1.278716)
round(PCAbspitchers_15$rotation[,1:10],2) 

BSpitchersWAR_15 = merge(WARpitchers_2015, PCAbspitchers_15$x[,1:10], by="row.names")
BSpitchersWAR_15 = rename(BSpitchersWAR_15, Player = Row.names)

ggplot(BSpitchersWAR_15) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2)

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(BSpitchersWAR_15)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_BSpitchersWAR_15 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  BSpitchersWAR_15_train = BSpitchersWAR_15[train_cases,]
  BSpitchersWAR_15_test = BSpitchersWAR_15[test_cases,]
  forestBSP_15 = randomForest(WAR ~ . - Player, data = BSpitchersWAR_15_train)
  
  yhat_forestBSP_15 = predict(forestBSP_15, BSpitchersWAR_15_test)
  rmse_forestBSP_15 = mean((yhat_forestBSP_15 - BSpitchersWAR_15_test$WAR)^2) %>% sqrt
} 
mean(out_rf_BSpitchersWAR_15$result)

