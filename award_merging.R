# Stat Final Project
# Award Merging

draft_box <- merge(box_scores, draft, by = c('Name'), all.x = T)

# Change undrafted players draft_pos from NA to 61
draft_box$Draft_Pos[is.na(draft_box$Draft_Pos)] <- 61

# MVP
mvp_analysis <- merge(mvp_final, draft_box, by = c('Name','Year'), all.y = T)
mvp_analysis$First_Place_Votes[is.na(mvp_analysis$First_Place_Votes)] <- 0
mvp_analysis$share[is.na(mvp_analysis$share)] <- 0
mvp_analysis$`pts won`[is.na(mvp_analysis$`pts won`)] <- 0

# Defensive POY
dpoy_analysis <- merge(dpoy_final, draft_box, by = c('Name','Year'), all.y = T)
dpoy_analysis$First_Place_Votes[is.na(dpoy_analysis$First_Place_Votes)] <- 0
dpoy_analysis$share[is.na(dpoy_analysis$share)] <- 0
dpoy_analysis$`pts won`[is.na(dpoy_analysis$`pts won`)] <- 0

# 6 Man Of Year
smoy_analysis <- merge(smoy_final, draft_box, by = c('Name','Year'), all.y = T)
smoy_analysis$First_Place_Votes[is.na(smoy_analysis$First_Place_Votes)] <- 0
smoy_analysis$share[is.na(smoy_analysis$share)] <- 0
smoy_analysis$`pts won`[is.na(smoy_analysis$`pts won`)] <- 0

smoy_analysis <- subset(smoy_analysis, (GS / G) < .5) # eligibility requirement