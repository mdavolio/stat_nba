# Stat Final Project
# All-NBA Merging and Analysis

all_nba_analysis_1 <- merge(all_nba_final, box_scores, by = c('Name','Year'))
all_nba_analysis_2 <- merge(all_nba_analysis_1, draft, by = 'Name')

# remove double columns
doubles <- c('Pos.x','Team.x')
all_nba_analysis_2 <- all_nba_analysis_2[,!(names(all_nba_analysis_2) %in% doubles)]

# Rename Team and Pos columns
oldnames <- c('Pos.y','Team.y')
newnames <- c('Pos','Team')
setnames(all_nba_analysis_2, oldnames, newnames)

# Change string to numerical
all_nba_analysis_2$All_NBA_Team[all_nba_analysis_2$All_NBA_Team == '1st'] <- 1
all_nba_analysis_2$All_NBA_Team[all_nba_analysis_2$All_NBA_Team == '2nd'] <- 2
all_nba_analysis_2$All_NBA_Team[all_nba_analysis_2$All_NBA_Team == '3rd'] <- 3
