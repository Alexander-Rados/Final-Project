#####
# FanGraphs Pitchers Code
#####

library(tidyverse)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
library(kableExtra)
library(gridExtra)
options('mosaic:parallelMessage' = FALSE)

FGpitchers_18 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2018/FGpitchers - FGeighteenpitchers.csv")
WARpitchers_2018 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2018/Pitchers WAR 2018 - FGeighteenpitchers.csv",
                       row.names=1)

FGP_18 = subset(FGpitchers_18, select = -c(Team, playerid, LOB., LD., GB., FB., IFFB., HR.FB, K., BB.,
                                    Soft., Med., Hard.) )

pct_to_number<- function(x){
  x_replace_pct<-sub("%", "", x)
  x_as_numeric<-as.numeric(x_replace_pct)
}

FGP_18[['Swing.']] = pct_to_number(FGP_18[['Swing.']])
FGP_18[['O.Contact.']] = pct_to_number(FGP_18[['O.Contact.']])
FGP_18[['O.Swing.']] = pct_to_number(FGP_18[['O.Swing.']])
FGP_18[['Z.Swing.']] = pct_to_number(FGP_18[['Z.Swing.']])
FGP_18[['Z.Contact.']] = pct_to_number(FGP_18[['Z.Contact.']])
FGP_18[['Contact.']] = pct_to_number(FGP_18[['Contact.']])
FGP_18[['Zone.']] = pct_to_number(FGP_18[['Zone.']])
FGP_18[['F.Strike.']] = pct_to_number(FGP_18[['F.Strike.']])
FGP_18[['SwStr.']] = pct_to_number(FGP_18[['SwStr.']])
FGP_18[['O.Swing...pfx.']] = pct_to_number(FGP_18[['O.Swing...pfx.']])
FGP_18[['Z.Swing...pfx.']] = pct_to_number(FGP_18[['Z.Swing...pfx.']])
FGP_18[['Swing...pfx.']] = pct_to_number(FGP_18[['Swing...pfx.']])
FGP_18[['O.Contact...pfx.']] = pct_to_number(FGP_18[['O.Contact...pfx.']])
FGP_18[['Z.Contact...pfx.']] = pct_to_number(FGP_18[['Z.Contact...pfx.']])
FGP_18[['Contact...pfx.']] = pct_to_number(FGP_18[['Contact...pfx.']])
FGP_18[['Zone...pfx.']] = pct_to_number(FGP_18[['Zone...pfx.']])
FGP_18[['O.Swing...pi.']] = pct_to_number(FGP_18[['O.Swing...pi.']])
FGP_18[['Z.Swing...pi.']] = pct_to_number(FGP_18[['Z.Swing...pi.']])
FGP_18[['Swing...pi.']] = pct_to_number(FGP_18[['Swing...pi.']])
FGP_18[['Z.Contact...pi.']] = pct_to_number(FGP_18[['Z.Contact...pi.']])
FGP_18[['Contact...pi.']] = pct_to_number(FGP_18[['Contact...pi.']])
FGP_18[['Zone...pi.']] = pct_to_number(FGP_18[['Zone...pi.']])
FGP_18[['O.Contact...pi.']] = pct_to_number(FGP_18[['O.Contact...pi.']])
FGP_18[['K.BB.']] = pct_to_number(FGP_18[['K.BB.']])

FGP_results_18 = FGP_18 %>%
  group_by(Name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="Name")

PCAfgpitchers_18 = prcomp(~ . - WAR, data = FGP_results_18, scale = TRUE)

## variance plot
plot(PCAfgpitchers_18)
summary(PCAfgpitchers_18)

# 16 PCs used for the lowest RMSE (1.341678)
round(PCAfgpitchers_18$rotation[,1:16],2) 

FGpitchersWAR_18 = merge(WARpitchers_2018, PCAfgpitchers_18$x[,1:16], by="row.names")
FGpitchersWAR_18 = rename(FGpitchersWAR_18, Player = Row.names)

ggplot(FGpitchersWAR_18) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Graph of Principal Components 1 and 2")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(FGpitchersWAR_18)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_FGpitchersWAR_18 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  FGpitchersWAR_18_train = FGpitchersWAR_18[train_cases,]
  FGpitchersWAR_18_test = FGpitchersWAR_18[test_cases,]
  forestFGP_18 = randomForest(WAR ~ . - Player, data = FGpitchersWAR_18_train)
  
  yhat_forestFGP_18 = predict(forestFGP_18, FGpitchersWAR_18_test)
  rmse_forestFGP_18 = mean((yhat_forestFGP_18 - FGpitchersWAR_18_test$WAR)^2) %>% sqrt
} 
FGpitchersWAR_2018 = mean(out_rf_FGpitchersWAR_18$result)


#####
# BaseballSavant Pitchers Code
#####
BSpitchers_18 = read.csv("~/Documents/GitHub/Data-Mining-Final-Project/Data 2018/BSpitchers - BSeighteenpitchers.csv")

BSP_18 = subset(BSpitchers_18, select = -c(last_name, first_name, year) )

BSP_results_18 = BSP_18 %>%
  group_by(name) %>% 
  summarize_all(mean) %>%
  column_to_rownames(var="name")

PCAbspitchers_18 = prcomp(~ . - WAR, data = BSP_results_18, scale = TRUE)

## variance plot
plot(PCAbspitchers_18, main =
       "Percent Variation Explained by Each Principal Component", 
     xlab = "Principal Components", sub = "Figure 1")
summary(PCAbspitchers_18)

# 15 PCs used for the lowest RMSE (1.452963)
round(PCAbspitchers_18$rotation[,1:15],2) 

BSpitchersWAR_18 = merge(WARpitchers_2018, PCAbspitchers_18$x[,1:15], by="row.names")
BSpitchersWAR_18 = rename(BSpitchersWAR_18, Player = Row.names)

BSpitchersWAR_18_bust = subset(BSpitchersWAR_18, WAR < 0.3)
BSpitchersWAR_18_elite = subset(BSpitchersWAR_18, WAR > 2)

elite_graph <- ggplot(BSpitchersWAR_18_elite) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  xlim(-15, 10) +
  ylim(-10, 10) +
  labs(title = "Figure 2: Distribution of Elite Players Based On Principal Components 1 and 2", 
       subtitle = "2018 Baseball Savant Pitcher Statistics")

bust_graph <- ggplot(BSpitchersWAR_18_bust) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  xlim(-15, 10) +
  ylim(-10, 10) +
  labs(title = "Figure 3: Distribution of Bust Players Based On Principal Components 1 and 2", 
       subtitle = "2018 Baseball Savant Pitcher Statistics")

grid.arrange(elite_graph, bust_graph, ncol=2)

ggplot(BSpitchersWAR_18) + 
  geom_text(aes(x=PC1, y=PC2, label=Player), size=2) +
  labs(title = "Figure 2: Distribution of Players Based On Principal Components 1 and 2", 
       subtitle = "2018 Baseball Savant Pitcher Statistics")
 
ggplot(BSpitchersWAR_18) + 
  geom_text(aes(x=PC1, y=PC2, label=Player, color = WAR), size=2) +
  labs(title = "Figure 2: Distribution of Players Based On Principal Components 1 and 2", 
       subtitle = "2018 Baseball Savant Pitcher Statistics")

###########################
# Trying to create the do-loop
###########################
# split into a training and testing set
n = nrow(BSpitchersWAR_18)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train

out_rf_BSpitchersWAR_18 = do(250)*{
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  BSpitchersWAR_18_train = BSpitchersWAR_18[train_cases,]
  BSpitchersWAR_18_test = BSpitchersWAR_18[test_cases,]
  forestBS_18 = randomForest(WAR ~ . - Player, data = BSpitchersWAR_18_train)
  
  yhat_forestBS_18 = predict(forestBS_18, BSpitchersWAR_18_test)
  rmse_forestBS_18 = mean((yhat_forestBS_18 - BSpitchersWAR_18_test$WAR)^2) %>% sqrt
} 
BSpitchersWAR_2018 = mean(out_rf_BSpitchersWAR_18$result)

RMSE_pitchers_table <- data.frame("FanGraph" = FGpitchersWAR_2018, 
                                  "Baseball Savant" = BSpitchersWAR_2018)




