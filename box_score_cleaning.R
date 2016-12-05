# Stat Final Project
# Box Scores data cleaning

library(readr)
library(stringr)
library(data.table)

# import csv file
# box_scores <- read_csv('All_player_data.csv')
box_scores <- read_csv('All_player_data_2016.csv')

# remove duplicate columns
duplicates <- c('Age_y','Tm_y','G_y','MP_y','Pos_y')
box_scores <- box_scores[,!(names(box_scores) %in% duplicates)]

# remove empty columns
box_scores <- box_scores[,-1]
empty <- c('blnk','blnk2')
box_scores <- box_scores[,!(names(box_scores) %in% empty)]

# rename columns
oldnames <- c('season_end','player','Pos_x','Age_x','Tm_x','G_x','MP_x')
newnames <- c('Year','Name','Pos','Age','Team','G','MP')
setnames(box_scores, oldnames, newnames)