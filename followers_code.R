# Stat Final Project
# Twitter Followers Data

library(readr)
library(stringr)
library(data.table)

# import csv file
followers <- read_csv('nba-followers.csv')

# rename columns
oldnames <- c('Rk','Player','Twitter', NA)
newnames <- c('Rank','Name','Handle','Followers')
setnames(followers, oldnames, newnames)

# remove unused columns
unused <- c('Rank','Handle')
followers <- followers[,!(names(followers) %in% unused)]


# Fix missing values