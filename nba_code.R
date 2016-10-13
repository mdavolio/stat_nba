# Stat Final Project

library(readr)
library(stringr)

# import csv file
all_nba <- read_csv('all_pro.csv')

all_nba_2 <- data.frame()
count = 1

# change data frame so each player is individual row
for(i in 1:nrow(all_nba)){
  for(k in 4:8){
    all_nba_2[count,1] <- all_nba[i, 1]    
    all_nba_2[count,2] <- all_nba[i, 2]
    all_nba_2[count,3] <- all_nba[i, 3]
    all_nba_2[count, 4] <- all_nba[i,k] 
    count = count + 1
  }
}

# split names and pos into individual columns
# Still need to clean names that appear in position column
all_nba_2[,4:6] <- as.data.frame(str_split_fixed(all_nba_2$V4, " ", 3))

# Rename columns
colnames(all_nba_2) <- c('Year','del','Team','First','Last','Pos')

# Remove 'nba' column that was unnecessary
drops <- ('del')
all_nba_2 <- all_nba_2[,!(names(all_nba_2) %in% drops)]

# Cut off prior to 1988-89 (first year of 3rd team)
