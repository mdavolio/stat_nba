#Time Series CV
#Example - https://rpubs.com/crossxwill/time-series-cv

library(lubridate)
library(doParallel)
library(caret)
library(e1071)

registerDoParallel(cores = 2)




x<-all_nba_analysis[c(-1,-2,-4,-51,-52)]
mvp<-mvp_analysis[c(-1,-2,-3,-5,-8,-55,-56, -57)]
dpoy <- dpoy_analysis[c(-1,-2,-3,-5,-8,-56,-55,-57)]
smoy <- smoy_analysis[c(-1,-2,-3,-5,-8,-56,-55,-57)]

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

dpoy$Pos <- as.factor(dpoy$Pos)
dpoy$Draft_Pos <- as.numeric(dpoy$Draft_Pos)

smoy$Pos <- as.factor(smoy$Pos)
smoy$Draft_Pos <- as.numeric(smoy$Draft_Pos)

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

# MVP Only those receiving votes
mvp_2 <- subset(mvp, share > 0)
mvp_2.lm.mod <- train(share ~ .,
                          data = mvp_2,
                          method = 'lm',
                          trControl = cvControl,
                          na.action=na.exclude)
# MSE = 0.1820564, R^2 = 0.5225591h

# DPOY Analysis
# Stepwise selection
dpoy.stepwise.mod <- train(share ~ .,
                          data = dpoy,
                          method = 'leapSeq',
                          trControl = cvControl,
                          na.action=na.exclude)
# MSE = 0.06131, R^2 = 0.09305

# backward selection
dpoy.backselect.mod <- train(share ~ .,
                            data = dpoy,
                            method = 'leapBackward',
                            trControl = cvControl,
                            na.action=na.exclude)
# MSE = 0.06131, R^2 = 0.0944

# Linear Model
dpoy.lm.mod <- train(share ~ .,
                    data = dpoy,
                    method = 'lm',
                    trControl = cvControl,
                    na.action=na.exclude)
# MSE = 0.06065, R^2 = 0.11358

# GLM
dpoy.glm.mod <- train(share ~ .,
                     data = dpoy,
                     method = 'glmnet',
                     trControl = cvControl,
                     na.action=na.exclude)
# MSE = 0.060578, R^2 = .11278, alpha = .10

# Lasso
dpoy.lasso.mod <- train(share ~ .,
                       data = dpoy,
                       method = 'lasso',
                       trControl = cvControl,
                       na.action=na.exclude)
# MSE = .06085, R^2 = .11302

# Ridge
dpoy.ridge.mod <- train(share ~ .,
                       data = dpoy,
                       method = 'ridge',
                       trControl = cvControl,
                       na.action=na.exclude)
# MSE = .06081, R^2 = .1125851

# SMOY Analysis
# Stepwise selection
smoy.stepwise.mod <- train(share ~ .,
                           data = smoy,
                           method = 'leapSeq',
                           trControl = cvControl,
                           na.action=na.exclude)
# MSE = 0.050709, R^2 = 0.18612

# backward selection
smoy.backselect.mod <- train(share ~ .,
                             data = smoy,
                             method = 'leapBackward',
                             trControl = cvControl,
                             na.action=na.exclude)
# MSE = 0.051332, R^2 = 0.17585

# Linear Model
smoy.lm.mod <- train(share ~ .,
                     data = smoy,
                     method = 'lm',
                     trControl = cvControl,
                     na.action=na.exclude)
# MSE = 0.050216, R^2 = 0.2110057

# GLM
smoy.glm.mod <- train(share ~ .,
                      data = smoy,
                      method = 'glmnet',
                      trControl = cvControl,
                      na.action=na.exclude)
# MSE = 0.0502579, R^2 = .21234, alpha = .10

# Lasso
smoy.lasso.mod <- train(share ~ .,
                        data = smoy,
                        method = 'lasso',
                        trControl = cvControl,
                        na.action=na.exclude)
# MSE = .05038588, R^2 = .2113958

# Ridge
smoy.ridge.mod <- train(share ~ .,
                        data = smoy,
                        method = 'ridge',
                        trControl = cvControl,
                        na.action=na.exclude)
# MSE = .050343, R^2 = .2077896

# Testing with 2016 data

mvp_2016 <-mvp_analysis_2016[c(-2,-3,-5,-8,-55,-56, -57)]
dpoy_2016 <- dpoy_analysis_2016[c(-2,-3,-5,-8,-56,-55,-57)]
smoy_2016 <- smoy_analysis_2016[c(-2,-3,-5,-8,-56,-55,-57)]

mvp_2016 <- pos_fact(mvp_2016)
dpoy_2016 <- pos_fact(dpoy_2016)
smoy_2016 <- pos_fact(smoy_2016)

mvp_2016$Pos<-as.factor(mvp_2016$Pos)
mvp_2016$Draft_Pos<-as.numeric(mvp_2016$Draft_Pos)
mvp_2016[is.na(mvp_2016)] <- 0

dpoy_2016$Pos <- as.factor(dpoy_2016$Pos)
dpoy_2016$Draft_Pos <- as.numeric(dpoy_2016$Draft_Pos)
dpoy_2016[is.na(dpoy_2016)] <- 0

smoy_2016$Pos <- as.factor(smoy_2016$Pos)
smoy_2016$Draft_Pos <- as.numeric(smoy_2016$Draft_Pos)
smoy_2016[is.na(smoy_2016)] <- 0

# MVP Prediction
mvp_pred <- predict(mvp.lm.mod, newdata = mvp_2016, type = 'raw')
mvp_mse <- mean(sum((mvp_pred - mvp_2016$share)^2))

print(tail(sort(mvp_pred),10))

#MVP SUBSET
mvp_2016_2 <- subset(mvp_2016, share > 0)
mvp_pred_2 <- predict(mvp_2.lm.mod, newdata = mvp_2016_2, type = 'raw')

print(sort(mvp_pred_2))
mvp_2_mse <- mean(sum((mvp_pred_2 - mvp_2016_2$share)^2))

# DPOY Prediction
dpoy_pred <- predict(dpoy.glm.mod, newdata = dpoy_2016, type = 'raw')
dpoy_mse <- mean(sum((dpoy_pred - dpoy_2016$share)^2))

print(tail(sort(dpoy_pred),10))

#DPOY SUBSET
dpoy_2016_2 <- subset(dpoy_2016, share > 0)

dpoy_2.glm.mod <- train(share ~ .,
                      data = dpoy,
                      method = 'glmnet',
                      trControl = cvControl,
                      na.action=na.exclude)

dpoy_pred_2 <- predict(dpoy_2.glm.mod, newdata = dpoy_2016_2, type = 'raw')

print(sort(dpoy_pred_2))
dpoy_2_mse <- mean(sum((dpoy_pred_2 - dpoy_2016_2$share)^2))

# smoy Prediction
smoy_pred <- predict(smoy.glm.mod, newdata = smoy_2016, type = 'raw')
smoy_mse <- mean(sum((smoy_pred - smoy_2016$share)^2))

print(tail(sort(smoy_pred),10))

#DPOY SUBSET
smoy_2016_2 <- subset(smoy_2016, share > 0)

smoy_2.glm.mod <- train(share ~ .,
                        data = smoy,
                        method = 'glmnet',
                        trControl = cvControl,
                        na.action=na.exclude)

smoy_pred_2 <- predict(smoy_2.glm.mod, newdata = smoy_2016_2, type = 'raw')

print(sort(smoy_pred_2))
smoy_2_mse <- mean(sum((smoy_pred_2 - smoy_2016_2$share)^2))
