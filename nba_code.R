# Stat Final Project

library(readr)

all_nba <- read_csv('all_pro.csv')

all_nba_2 <- data.frame()
count = 1

for(i in 1:nrow(all_nba)){
  for(k in 4:8){
    all_nba_2[count,1] <- all_nba[i, 1]    
    all_nba_2[count,2] <- all_nba[i, 2]
    all_nba_2[count,3] <- all_nba[i, 3]
    all_nba_2[count, 4] <- all_nba[i,k] 
    count = count + 1
  }
}

