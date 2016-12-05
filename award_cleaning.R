# Stat final project
# Cleaning award data

library(readr)
library(data.table)

# import csv's
# mvp <- read_csv('mvp.csv')
# dpoy <- read_csv('dpoy.csv')
# smoy <- read_csv('smoy.csv')

mvp <- read_csv('mvp_2016.csv')
dpoy <- read_csv('dpoy_2016.csv')
smoy <- read_csv('smoy_2016.csv')

# remove index column
mvp <- mvp[,-1]
dpoy <- dpoy[,-1]
smoy <- smoy[,-1]

# rename columns
oldnames <- c('year', 'player', 'first')
newnames <- c('Year','Name','First_Place_Votes')
setnames(mvp, oldnames, newnames)
setnames(dpoy, oldnames, newnames)
setnames(smoy, oldnames, newnames)

# fix name column
mvp[,6:7] <- as.data.frame(str_split_fixed(mvp$Name, ",", 2))
mvp$Name <- paste(mvp$V2, mvp$V1)
drops <- c('V2','V1')
mvp_final <- mvp[,!(names(mvp) %in% drops)]

dpoy[,6:7] <- as.data.frame(str_split_fixed(dpoy$Name, ",", 2))
dpoy$Name <- paste(dpoy$V2, dpoy$V1)
dpoy_final <- dpoy[,!(names(dpoy) %in% drops)]

smoy[,6:7] <- as.data.frame(str_split_fixed(smoy$Name, ",", 2))
smoy$Name <- paste(smoy$V2, smoy$V1)
smoy_final <- smoy[,!(names(smoy) %in% drops)]