#Time Series CV
#Example - https://rpubs.com/crossxwill/time-series-cv

library(lubridate)
library(doParallel)
library(caret)
library(e1071)

registerDoParallel(cores = 2)




x<-all_nba_analysis[c(-1,-2,-4,-51,-52)]
mvp<-mvp_analysis[c(-1,-2,-3,-5,-8,-55,-56, -57)]
dpoy <- dpoy_analysis[c(-1,-3,-5,-8,-56,-55)]
smoy <- smoy_analysis[c(-1,-3,-5,-7,-56,-55)]

#Recode positions into factors - all_nba
unique(mvp$Pos)

pos_fact <- function(table){
  table$Pos[table$Pos == "PF"]<-4
  table$Pos[table$Pos == "F"]<-4
  table$Pos[table$Pos == "PF-C"]<-4
  table$Pos[table$Pos == "PF-SF"]<-4
  table$Pos[table$Pos == "C"]<-5
  table$Pos[table$Pos == "C-PF"]<-5
  table$Pos[table$Pos == "C-SF"]<-5
  table$Pos[table$Pos == "SF-SG"]<-3
  table$Pos[table$Pos == "SF-PF"]<-3
  table$Pos[table$Pos == "SF"]<-3
  table$Pos[table$Pos == "SG"]<-2
  table$Pos[table$Pos == "SG-PF"]<-2
  table$Pos[table$Pos == "SG-SF"]<-2
  table$Pos[table$Pos == "SG-PG"]<-2
  table$Pos[table$Pos == "G-F"]<-2
  table$Pos[table$Pos == "PG"]<-1
  table$Pos[table$Pos == "PG-SG"]<-1
  table$Pos[table$Pos == "PG-SF"]<-1
  return(table)
}

x <- pos_fact(x)
mvp <- pos_fact(mvp)
dpoy <- pos_fact(dpoy)
smoy <- pos_fact(smoy)

x$Pos<-as.factor(x$Pos)
x$All_NBA_Team<-as.factor(x$All_NBA_Team)
x$Draft_Pos<-as.factor(x$Draft_Pos)

mvp$Pos<-as.factor(mvp$Pos)
mvp$Draft_Pos<-as.numeric(mvp$Draft_Pos)

dpoy$Pos <- as.numeric(dpoy$Pos)
dpoy$Draft_Pos <- as.numeric(dpoy$Draft_Pos)

smoy$Pos <- as.numeric(smoy$Pos)
smoy$Year <- as.numeric(smoy$Year)

# All_NBA Analysis
length(x$Draft_Year[x$Draft_Year== 1994])


timeControl <- trainControl(method = "timeslice",
                            initialWindow =  length((x$Draft_Year[x$Draft_Year== 1994])), 
                              horizon = 350,
                              fixedWindow = FALSE)

tuneLength.num <- 4

is.na(x)
mulnom.mod <- train(All_NBA_Team ~ . - Draft_Year,
                    data = x,
                    method = 'multinom',
                    trControl = timeControl,
                    tuneLength=tuneLength.num,
                    na.action=na.exclude)



# All 10-fold cross validation, repeated 10 times

cvControl <- trainControl(method = "repeatedCV",
                            repeats = 10,
                            number = 10)

# MVP Analysis
# Stepwise selection
mvp.stepwise.mod <- train(share ~ .,
                    data = mvp,
                    method = 'leapSeq',
                    trControl = cvControl,
                    na.action=na.exclude)
# MSE = 0.05499, R^2 = 0.25663

# backward selection
mvp.backselect.mod <- train(share ~ .,
                    data = mvp,
                    method = 'leapBackward',
                    trControl = cvControl,
                    na.action=na.exclude)
# MSE = 0.05543, R^2 = 0.24827

# Linear Model
mvp.lm.mod <- train(share ~ .,
                    data = mvp,
                    method = 'lm',
                    trControl = cvControl,
                    na.action=na.exclude)
# MSE = 0.05345, R^2 = 0.29961

# GLM
mvp.glm.mod <- train(share ~ .,
                    data = mvp,
                    method = 'glmnet',
                    trControl = cvControl,
                    na.action=na.exclude)
# MSE = 0.05371, R^2 = .2963, alpha = .10

# Lasso
mvp.lasso.mod <- train(share ~ .,
                      data = mvp,
                      method = 'lasso',
                      trControl = cvControl,
                      na.action=na.exclude)
# MSE = .05349, R^2 = .2966

# Ridge
mvp.ridge.mod <- train(share ~ .,
                       data = mvp,
                       method = 'ridge',
                       trControl = cvControl,
                       na.action=na.exclude)
# MSE = .0536845, R^2 = .29719