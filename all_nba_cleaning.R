# Stat Final Project
# All NBA data

library(readr)
library(stringr)

# import csv file
all_nba <- read_csv('all_pro.csv')

# empty data frame
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
all_nba_2[,4:6] <- as.data.frame(str_split_fixed(all_nba_2$V4, " ", 3))

# Rename columns
colnames(all_nba_2) <- c('Year','del','All_NBA_Team','First','Last','Pos')

# Remove 'nba' column that was unnecessary
drops <- ('del')
all_nba_2 <- all_nba_2[,!(names(all_nba_2) %in% drops)]

# Change year to just season end year/Fix types
all_nba_2$Year <- substr(all_nba_2$Year, 0, 4)
all_nba_2$Year <- as.numeric(all_nba_2$Year) + 1
all_nba_2[] <- lapply(all_nba_2, as.character)

# Cut off prior to 1988-89 (first year of 3rd team)
all_nba_final <- subset(all_nba_2, Year > 1988)

# Clean one column error of name
all_nba_final[193, 'Last'] <- 'World Peace'
all_nba_final[193, 'Pos'] <- 'F'

# Combined player name into one
all_nba_final$Name <- paste(all_nba_final$First, all_nba_final$Last)
drops <- c('First','Last')
all_nba_final <- all_nba_final[,!(names(all_nba_final) %in% drops)]
