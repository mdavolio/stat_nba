#Time Series CV
#Example - https://rpubs.com/crossxwill/time-series-cv

library(lubridate)
library(doParallel)
library(caret)
install.packages('e1071', dependencies=TRUE)
library(e1071)

registerDoParallel(cores = 2)




x<-all_nba_analysis[c(-1,-2,-4,-51,-52)]
mvp<-mvp_analysis[c(-1,-3,-5,-8,-55,-56)]
dpoy <- dpoy_analysis[c(-1,-3,-5,-8,-56,-55)]
smoy <- smoy_analysis[c(-1,-3,-5,-7,-56,-55)]

#Recode positions into factors - all_nba
unique(x$Pos)

pos_fact <- function(table){
  table$Pos[table$Pos == "PF"]<-4
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
mvp$Draft_Pos<-as.factor(mvp$Draft_Pos)
mvp$Year<-as.factor(mvp$Year)

dpoy$Pos <- as.factor(dpoy$Pos)
dpoy$Draft_Pos <- as.factor(dpoy$Draft_Pos)

smoy$Pos <- as.factor(smoy$Pos)
smoy$Year <- as.factor(smoy$Year)

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

# MVP Analysis

length(mvp$Year[mvp$Year == 1994])

timeControl <- trainControl(method = "timeslice",
                            initialWindow =  length(mvp$Year[mvp$Year == 1994]), 
                            horizon = 350,
                            fixedWindow = FALSE)
tuneLength.num <- 4

is.na(mvp)
mvp.lm.mod <- train(share ~ . - Draft_Year - Year,
                    data = mvp,
                    method = 'lm',
                    trControl = timeControl,
                    tuneLength=tuneLength.num,
                    na.action=na.exclude)

# Subsetted model for mvp??

mvp.lm.mod_2 <- train(share ~ GS + MP + `eFG%` + FTA + TOV + PER + `TS%` + 
                      VORP,
                    data = mvp,
                    method = 'lm',
                    trControl = timeControl,
                    tuneLength=tuneLength.num,
                    na.action=na.exclude)



# dpoy Analysis

length(dpoy$Year[dpoy$Year == 1994])

timeControl <- trainControl(method = "timeslice",
                            initialWindow =  length(dpoy$Year[dpoy$Year == 1994]), 
                            horizon = 350,
                            fixedWindow = FALSE)
tuneLength.num <- 4

is.na(dpoy)
dpoy.lm.mod <- train(share ~ . -Year -Draft_Year ,
                        data = dpoy,
                        method = 'lm',
                        trControl = timeControl,
                        tuneLength=tuneLength.num,
                        na.action=na.exclude)

# smoy Analysis

length(smoy$Year[smoy$Year == 1994])

timeControl <- trainControl(method = "timeslice",
                            initialWindow =  length(smoy$Year[smoy$Year == 1994]), 
                            horizon = 350,
                            fixedWindow = FALSE)
tuneLength.num <- 4

is.na(smoy)
smoy.lm.mod <- train(share ~ . -Year -Draft_Year ,
                     data = smoy,
                     method = 'lm',
                     trControl = timeControl,
                     tuneLength=tuneLength.num,
                     na.action=na.exclude)