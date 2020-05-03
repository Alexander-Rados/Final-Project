library(tidyverse)
library(lubridate)
library(randomForest)
library(doMC)
library(foreach)
library(mosaic)
options('mosaic:parallelMessage' = FALSE)

# Now look at PCA of the (average) survey responses.  
# This is a common way to treat survey data
PCApilot = prcomp(pilot_results, scale=TRUE)

## variance plot
plot(PCApilot)
summary(PCApilot)

# first few pcs
round(PCApilot$rotation[,1:3],2) 

shows = merge(shows, PCApilot$x[,1:3], by="row.names")
shows = rename(shows, Show = Row.names)

ggplot(shows) + 
  geom_text(aes(x=PC2, y=PC3, label=Show), size=3)


# split into a training and testing set
train_frac = 0.8
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
load_train = load_coast[train_ind,]
load_test = load_coast[-train_ind,]

# now true random forests
# now average over 100 bootstrap samples
# this time only 5 candidate variables (mtry=5) in each bootstrapped sample
forest2 = randomForest(COAST ~ ., data = load_train, mtry = 5, ntree=100)
yhat_forest2 = predict(forest2, load_test)
rmse_forest2 = mean((yhat_forest2 - load_test$COAST)^2) %>% sqrt
