# STAT 6021 Final Project
## Analysis of Invividual Player Success in the NBA

Focusing on statistics at the individual player level, various linear modeling techniques were applied to try to predict the players whom the media voted for several year end honors. Of the several year end honors, we chose to focus on the All-NBA Team (all three teams), the Most Valuable Player Award (MVP), the Defensive Player of the Year (DPOY), and the 6th-Man of the Year Award.

Data:
The data was scraped from various pages on the site basketball-reference (http://www.basketball-reference.com/). The Scraping was done using Python's beautifulSoup package and stored as CSV files. The data began with the 1988-89 season as this was the first year of three All-NBA teams and continued through the 2015-16 season. The creation of the models was based on data between the 1988-89 and 2014-15 seasons and tested on the 2015-16 season. For predictors, box scores for individals were collected (both basic and advanced statistics), along with the player's draft information. The results for the voting for the four honors of interest were also scraped.

All-NBA Results
After cleaning and structuring the data, the resulting table contained observations for each player, for every year in the data set. The response variable was which All-NBA team the player was selected to in that year: 1, 2, 3, or if they were not selected to a team, 4. Due to disproportionate classes (96% in class 4), downsampling and upsampling approaches were both tested with upsampling performing better with cross validation on the training data. An LDA and Multinomial Model were both tested with a mutlinomial approach having a stronger overall accuracy, but the LDA model seeming to perform better at predicting players who aren't in class 4.
[matrix]: https://github.com/mdavolio/stat_nba/blob/master/confusion_matrix.PNG, "Confusion Matrix for LDA All-NBA Analysis"
