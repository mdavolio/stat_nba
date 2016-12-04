# Stat Final Project
# All-NBA Merging

draft_box <- merge(box_scores, draft, by = c('Name'), all.x = T)
all_nba_analysis <- merge(draft_box, all_nba_final, by = c('Name','Year'), all.x=T)

# Change undrafted players draft_pos from NA to 61
all_nba_analysis$Draft_Pos[is.na(all_nba_analysis$Draft_Pos)] <- 61

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