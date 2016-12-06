#Example - https://rpubs.com/crossxwill/time-series-cv
#http://topepo.github.io/caret/measuring-performance.html#class
#install Libraries
getwd()
library(lubridate)
library(doParallel)
library(caret)
install.packages('e1071', dependencies=TRUE)

registerDoParallel(cores = 2)



#Read in Data
load("/Users/Kerry/Documents/UVA-DSI/Fall/STAT_6021_Linear_Regression/stat_nba/final_tables.RData")
#get rid of string variables
data<-all_nba_analysis[c(-1,-2,-4,-51,-52)]

#Recode positions into factors
unique(data$Pos)

data$Pos[data$Pos == "PF"]<-4
data$Pos[data$Pos == "PF-C"]<-4
data$Pos[data$Pos == "PF-SF"]<-4
data$Pos[data$Pos == "C"]<-5
data$Pos[data$Pos == "C-PF"]<-5
data$Pos[data$Pos == "C-SF"]<-5
data$Pos[data$Pos == "SF-SG"]<-3
data$Pos[data$Pos == "SF-PF"]<-3
data$Pos[data$Pos == "SF"]<-3
data$Pos[data$Pos == "SG"]<-2
data$Pos[data$Pos == "SG-PF"]<-2
data$Pos[data$Pos == "SG-SF"]<-2
data$Pos[data$Pos == "SG-PG"]<-2
data$Pos[data$Pos == "G-F"]<-2
data$Pos[data$Pos == "PG"]<-1
data$Pos[data$Pos == "PG-SG"]<-1
data$Pos[data$Pos == "PG-SF"]<-1
data$All_NBA_Team<-as.factor(data$All_NBA_Team)
data$Pos<-as.factor(data$Pos)

#Create dataset x to train model with. 
x = data
x$All_NBA_Team<-make.names(x$All_NBA_Team)#required for modeling techniques 
#required for modeling techniques 

#Model

#Set up training parametes
ctrl<- trainControl(method = "cv",
                    classProbs = TRUE,
                    repeats = 5,
                    number = 5)


#Stepwise LDA Model 
step_LDA_M1 <- train(All_NBA_Team ~ . - Draft_Year,
                    data = x,
                    method = 'stepLDA',
                    trControl = ctrl,
                    na.action=na.exclude)



#95% accurate
#Unequal classes 

# Linear Discriminant Analysis with Stepwise Feature Selection 
# 
# 8346 samples
# 48 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 6677, 6676, 6677, 6676, 6678 
# Resampling results:
#   
#   Accuracy  Kappa   
#0.9583039  0.4434933# 
# Tuning parameter 'maxvar' was held constant at a value of Inf
# Tuning parameter 'direction' was held
# constant at a value of both

## Linear Discriminant Analysis Model
LDA_M1 <- train(All_NBA_Team ~ . - Draft_Year,
                data = x,
                method = 'lda',
                #metric = "ROC",
                trControl = ctrl,
                na.action=na.exclude)
# 
# 8346 samples
# 48 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 6675, 6678, 6678, 6678, 6675 
# Resampling results:
#   
#   Accuracy   Kappa    
# 0.9529102  0.5391847

multi_nom1 <- train(All_NBA_Team ~ . - Draft_Year,
                   data = x,
                   method = 'multinom',
                   trControl = ctrl,
                   na.action=na.exclude)
# Penalized Multinomial Regression 
# 
# 8346 samples
# 48 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 6676, 6678, 6676, 6676, 6678 
# Resampling results across tuning parameters:
#   
#   decay  Accuracy   Kappa    
# 0e+00  0.9642939  0.5776746
# 1e-04  0.9646536  0.5823285
# 1e-01  0.9657321  0.5862105
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was decay = 0.1. 

set.seed(212)


#Down sample subsampling

x = data # reintalize x
down_train<- downSample(x = x[,-x$Draft_Year],y = x$All_NBA_Team)
down_train$All_NBA_Team<-make.names(down_train$All_NBA_Team)
table(down_train$Class)
#  1   2   3   4 
#135 135 135 135

#up sample subssampling
x = data # reintalize x
up_train<- upSample(x = x[,-x$Draft_Year],y = x$All_NBA_Team)
up_train$All_NBA_Team<-make.names(up_train$All_NBA_Team)
table(up_train$Class)

#1    2    3    4 
#9496 9496 9496 9496 

#Hybrid of two
library(DMwR)
x = data # reintalize x
smote_train<-SMOTE(All_NBA_Team ~.-x$Draft_Year, data = x)
smote_train$All_NBA_Team<-make.names(smote_train$All_NBA_Team)
nrow(smote_train)
#Stepwise LDA with 
step_LDA_M2 <- train(All_NBA_Team ~ . - Draft_Year -Class,
                    data = down_train,
                    method = 'stepLDA',
                    #metric = "ROC",
                    trControl = ctrl,
                    na.action=na.exclude)
# Linear Discriminant Analysis with Stepwise Feature Selection 
# 
# 504 samples
# 49 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 402, 404, 404, 404, 402 
# Resampling results:
#   
#   Accuracy   Kappa    
# 0.5813333  0.4400736
# 
# Tuning parameter 'maxvar' was held constant at a value of Inf
# Tuning parameter 'direction' was held
# constant at a value of both


LDA_M2 <- train(All_NBA_Team ~ . - Draft_Year -Class,
                    data = down_train,
                    method = 'lda',
                    #metric = "ROC",
                    trControl = ctrl,
                    na.action=na.exclude)

# Linear Discriminant Analysis 
# 
# 504 samples
# 49 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 404, 404, 403, 402, 403 
# Resampling results:
#   
#   Accuracy   Kappa    
# 0.5990363  0.4624487




multi_nom2 <- train(All_NBA_Team ~ . - Draft_Year -Class,
               data = down_train,
               method = 'multinom',
               trControl = ctrl,
               na.action=na.exclude)
# Penalized Multinomial Regression 
# 
# 504 samples
# 49 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 404, 403, 402, 403, 404 
# Resampling results across tuning parameters:
#   
#   decay  Accuracy   Kappa    
# 0e+00  0.6169955  0.4880744
# 1e-04  0.6189955  0.4907068
# 1e-01  0.6308783  0.5070003
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was decay = 0.1.   


step_LDA_3 <- train(All_NBA_Team ~ . - Draft_Year -Class,
                    data = up_train,
                    method = 'stepLDA',
                    #metric = "ROC",
                    trControl = ctrl,
                    na.action=na.exclude)
# Linear Discriminant Analysis with Stepwise Feature Selection 
# 
# 35771 samples
# 49 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 28617, 28617, 28617, 28615, 28618 
# Resampling results:
#   
#   Accuracy   Kappa    
# 0.6026391  0.4695753
# 
# Tuning parameter 'maxvar' was held constant at a value of Inf
# Tuning parameter 'direction' was held
# constant at a value of both


LDA_M3 <- train(All_NBA_Team ~ . - Draft_Year -Class,
                data = up_train,
                method = 'lda',
                #metric = "ROC",
                trControl = ctrl,
                na.action=na.exclude)

# Linear Discriminant Analysis 
# 
# 35771 samples
# 49 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 28615, 28618, 28617, 28617, 28617 
# Resampling results:
#   
#   Accuracy   Kappa   
# 0.7049564  0.605221


multi_nom3 <- train(All_NBA_Team ~ . - Draft_Year -Class,
                    data = up_train,
                    method = 'multinom',
                    trControl = ctrl,
                    na.action=na.exclude)

# Penalized Multinomial Regression 
# 
# 35771 samples
# 49 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 28618, 28616, 28618, 28617, 28615 
# Resampling results across tuning parameters:
#   
#   decay  Accuracy   Kappa    
# 0e+00  0.7405999  0.6533549
# 1e-04  0.7405999  0.6533549
# 1e-01  0.7399571  0.6524928
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was decay = 1e-04. 


smote_train$All_NBA_Team<-make.names(smote_train$All_NBA_Team)

step_LDA_M4 <- train(All_NBA_Team ~ . - Draft_Year,
                    data = smote_train,
                    method = 'stepLDA',
                    #metric = "ROC",
                    trControl = ctrl,
                    na.action=na.exclude)
# Linear Discriminant Analysis with Stepwise Feature Selection 
# 
# 833 samples
# 48 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 666, 667, 668, 666, 665 
# Resampling results:
#   
#   Accuracy   Kappa    
# 0.9015772  0.8074688
# 

LDA_M4 <- train(All_NBA_Team ~ . - Draft_Year,
               data = smote_train,
               method = 'lda',
               #metric = "ROC",
               trControl = ctrl,
               na.action=na.exclude)

# Linear Discriminant Analysis 
# 
# 833 samples
# 48 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 667, 666, 667, 666, 666 
# Resampling results:
#   
#   Accuracy   Kappa    
# 0.9123945  0.8324503


multi_nom4 <- train(All_NBA_Team ~ . - Draft_Year,
                   data = smote_train,
                   method = 'multinom',
                   trControl = ctrl,
                   na.action=na.exclude)
# Penalized Multinomial Regression 
# 
# 833 samples
# 48 predictor
# 4 classes: 'X1', 'X2', 'X3', 'X4' 
# 
# No pre-processing
# Resampling: Cross-Validated (5 fold) 
# Summary of sample sizes: 666, 665, 667, 666, 668 
# Resampling results across tuning parameters:
#   
#decay  Accuracy   Kappa    
#0e+00  0.9052016  0.8201435
#1e-04  0.9064065  0.8222902
#1e-01  0.9220186  0.8493470
# 
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was decay = 0.1. 

###### Test LDA_M3 and Multi_nom3 model on testset. 
#Open environment with Test Set...
load("~/Downloads/all_dfs.RData")

#Follow same clearning techniques used on training set

data2<-na.omit(all_nba_analysis_2016[c(-1,-2,-4,-51,-52)])
data2$Pos[data2$Pos == "PF"]<-4
data2$Pos[data2$Pos == "PF-C"]<-4
data2$Pos[data2$Pos == "PF-SF"]<-4
data2$Pos[data2$Pos == "C"]<-5
data2$Pos[data2$Pos == "C-PF"]<-5
data2$Pos[data2$Pos == "C-SF"]<-5
data2$Pos[data2$Pos == "SF-SG"]<-3
data2$Pos[data2$Pos == "SF-PF"]<-3
data2$Pos[data2$Pos == "SF"]<-3
data2$Pos[data2$Pos == "SG"]<-2
data2$Pos[data2$Pos == "SG-PF"]<-2
data2$Pos[data2$Pos == "SG-SF"]<-2
data2$Pos[data2$Pos == "SG-PG"]<-2
data2$Pos[data2$Pos == "G-F"]<-2
data2$Pos[data2$Pos == "PG"]<-1
data2$Pos[data2$Pos == "PG-SG"]<-1
data2$Pos[data2$Pos == "PG-SF"]<-1 
data2$Pos<-as.factor(data2$Pos) 

data2$Class<-data2$All_NBA_Team #make class variable to match training  dataset
data2$All_NBA_Team<-make.names(data2$All_NBA_Team)



#Prediction using LDA model
data2$test_preds_lda <- predict(LDA_M3,data2)
#Evaluation 
confusionMatrix(data = data2$test_preds_lda, reference = data2$All_NBA_Team)
# Confusion Matrix and Statistics
# 
# Reference
# Prediction  X1  X2  X3  X4
# X1   4   1   0   1
# X2   0   4   2   4
# X3   1   0   3  42
# X4   0   0   0 300
# 
# Overall Statistics
# 
# Accuracy : 0.8591         
# 95% CI : (0.819, 0.8933)
# No Information Rate : 0.9586         
# P-Value [Acc > NIR] : 1              
# 
# Kappa : 0.3068         
# Mcnemar's Test P-Value : 2.962e-09      
# 
# Statistics by Class:
# 
# Class: X1 Class: X2 Class: X3 Class: X4
# Sensitivity            0.80000   0.80000  0.600000    0.8646
# Specificity            0.99440   0.98319  0.879552    1.0000
# Pos Pred Value         0.66667   0.40000  0.065217    1.0000
# Neg Pred Value         0.99719   0.99716  0.993671    0.2419
# Prevalence             0.01381   0.01381  0.013812    0.9586
# Detection Rate         0.01105   0.01105  0.008287    0.8287
# Detection Prevalence   0.01657   0.02762  0.127072    0.8287
# Balanced Accuracy      0.89720   0.89160  0.739776    0.9323

 
#Prediction using Multinomial
data2$test_preds_multi <- predict(multi_nom3,data2)
 #Evaluation
confusionMatrix(data = data2$test_preds_multi, reference = data2$All_NBA_Team)

# 
# Confusion Matrix and Statistics
# 
# Reference
# Prediction  X1  X2  X3  X4
# X1   4   2   1   3
# X2   0   3   1   3
# X3   1   0   3  19
# X4   0   0   0 322
# 
# Overall Statistics
# 
# Accuracy : 0.9171          
# 95% CI : (0.8838, 0.9434)
# No Information Rate : 0.9586          
# P-Value [Acc > NIR] : 0.9999          
# 
# Kappa : 0.4317          
# Mcnemar's Test P-Value : 9.396e-05       
# 
# Statistics by Class:
# 
# Class: X1 Class: X2 Class: X3 Class: X4
# Sensitivity            0.80000  0.600000  0.600000    0.9280
# Specificity            0.98319  0.988796  0.943978    1.0000
# Pos Pred Value         0.40000  0.428571  0.130435    1.0000
# Neg Pred Value         0.99716  0.994366  0.994100    0.3750
# Prevalence             0.01381  0.013812  0.013812    0.9586
# Detection Rate         0.01105  0.008287  0.008287    0.8895
# Detection Prevalence   0.02762  0.019337  0.063536    0.8895
# Balanced Accuracy      0.89160  0.794398  0.771989    0.9640