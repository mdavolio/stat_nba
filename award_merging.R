# Stat Final Project
# Award Merging

mvp_analysis <- merge(mvp_final, box_scores, by = c('Name','Year'))

dpoy_analysis <- merge(dpoy_final, box_scores, by = c('Name','Year'))

smoy_analysis <- merge(smoy_final, box_scores, by = c('Name','Year'))
