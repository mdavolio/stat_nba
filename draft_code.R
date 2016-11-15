# Stat Final Project
# Draft Data

library(readr)
library(stringr)

# import csv file
draft <- as.data.frame(read_csv('nbaDraftList.csv'))

# Rename columns
colnames(draft) <- c('Draft_Pos','Team','Name','College','Year')

# reconfigure name column
draft[,6:7] <- as.data.frame(str_split_fixed(draft$Name, ",", 2))
draft$Name <- paste(draft$V2, draft$V1)
drops <- c('V1','V2')
draft <- draft[,!(names(draft) %in% drops)]

# If no college change 'Zzz' to 'None'
# Some are international, some are High School
# Differentiate manually??
draft$College[draft$College == 'Zzz'] <- 'None'
