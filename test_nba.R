#Time Series CV
#Example - https://rpubs.com/crossxwill/time-series-cv

library(lubridate)
library(doParallel)
library(caret)
install.packages('e1071', dependencies=TRUE)

registerDoParallel(cores = 2)




x<-all_nba_analysis[c(-1,-2,-4,-51,-52)]
#Recode positions into factors
unique(x$Pos)

x$Pos[x$Pos == "PF"]<-4
x$Pos[x$Pos == "PF-C"]<-4
x$Pos[x$Pos == "PF-SF"]<-4
x$Pos[x$Pos == "C"]<-5
x$Pos[x$Pos == "C-PF"]<-5
x$Pos[x$Pos == "C-SF"]<-5
x$Pos[x$Pos == "SF-SG"]<-3
x$Pos[x$Pos == "SF-PF"]<-3
x$Pos[x$Pos == "SF"]<-3
x$Pos[x$Pos == "SG"]<-2
x$Pos[x$Pos == "SG-PF"]<-2
x$Pos[x$Pos == "SG-SF"]<-2
x$Pos[x$Pos == "SG-PG"]<-2
x$Pos[x$Pos == "G-F"]<-2
x$Pos[x$Pos == "PG"]<-1
x$Pos[x$Pos == "PG-SG"]<-1
x$Pos[x$Pos == "PG-SF"]<-1

x$Pos<-as.factor(x$Pos)
x$All_NBA_Team<-as.factor(x$All_NBA_Team)
x$Draft_Pos<-as.factor(x$Draft_Pos)

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
