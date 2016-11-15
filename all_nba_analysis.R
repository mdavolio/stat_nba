# Stat Final Project
# All-NBA Merging and Analysis

all_nba_analysis_1 <- merge(all_nba_final, draft, by = 'Name')
all_nba_analysis_2 <- merge(all_nba_analysis_1, box_scores, by = c('Name','Year'))
