# Stat Final Project
# All-NBA Merging and Analysis

draft_box <- merge(box_scores, draft, by = c('Name'))
all_nba_analysis <- merge(draft_box, all_nba_final, by = c('Name','Year'), all.x=T)

# remove double columns
doubles <- c('Pos.y','Team.x')
all_nba_analysis <- all_nba_analysis[,!(names(all_nba_analysis) %in% doubles)]

# Rename Team and Pos columns
oldnames <- c('Pos.x')
newnames <- c('Pos')
setnames(all_nba_analysis, oldnames, newnames)

# Change string to numerical
all_nba_analysis$All_NBA_Team[all_nba_analysis$All_NBA_Team == '1st'] <- 1
all_nba_analysis$All_NBA_Team[all_nba_analysis$All_NBA_Team == '2nd'] <- 2
all_nba_analysis$All_NBA_Team[all_nba_analysis$All_NBA_Team == '3rd'] <- 3
all_nba_analysis$All_NBA_Team[is.na(all_nba_analysis$All_NBA_Team)] <- 4

