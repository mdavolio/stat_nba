# Stat Final Project
# Award Merging

draft_box <- merge(box_scores, draft, by = c('Name'))

# MVP
mvp_analysis <- merge(mvp_final, draft_box, by = c('Name','Year'), all.y = T)
mvp_analysis$First_Place_Votes[is.na(mvp_analysis$First_Place_Votes)] <- 0
mvp_analysis$share[is.na(mvp_analysis$share)] <- 0
mvp_analysis$`pts won`[is.na(mvp_analysis$`pts won`)] <- 0

# Defensive POY
dpoy_analysis <- merge(dpoy_final, box_scores, by = c('Name','Year'), all.y = T)
dpoy_analysis$First_Place_Votes[is.na(dpoy_analysis$First_Place_Votes)] <- 0
dpoy_analysis$share[is.na(dpoy_analysis$share)] <- 0
dpoy_analysis$`pts won`[is.na(dpoy_analysis$`pts won`)] <- 0

# 6 Man Of Year
smoy_analysis <- merge(smoy_final, box_scores, by = c('Name','Year'), all.y = T)
smoy_analysis$First_Place_Votes[is.na(smoy_analysis$First_Place_Votes)] <- 0
smoy_analysis$share[is.na(smoy_analysis$share)] <- 0
smoy_analysis$`pts won`[is.na(smoy_analysis$`pts won`)] <- 0

