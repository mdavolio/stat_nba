# Stat Final Project
# All-NBA Merging and Analysis

all_nba_analysis <- merge(all_nba_final, box_scores, by = c('Name','Year'))

# remove double columns
doubles <- c('Pos.x','Team.x')
all_nba_analysis <- all_nba_analysis[,!(names(all_nba_analysis) %in% doubles)]

# Rename Team and Pos columns
oldnames <- c('Pos.y')
newnames <- c('Pos')
setnames(all_nba_analysis, oldnames, newnames)

# Change string to numerical
all_nba_analysis$All_NBA_Team[all_nba_analysis$All_NBA_Team == '1st'] <- 1
all_nba_analysis$All_NBA_Team[all_nba_analysis$All_NBA_Team == '2nd'] <- 2
all_nba_analysis$All_NBA_Team[all_nba_analysis$All_NBA_Team == '3rd'] <- 3
