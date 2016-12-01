	
import requests # how python goes onto the internet!
from bs4 import BeautifulSoup # (version 4)
import pandas as pd
import numpy as np


def draftGrab(year):

	r = requests.get('http://www.basketball-reference.com/awards/awards_'+ str(year) +'.html')

	import re
	clean = r.text
	clean = re.sub('<!--  \n   <div class=\"table_outer_container\">','<div class=\"table_outer_container\">', clean)
	clean = re.sub('   <\/div>\n-->','   <\/div>\n', clean)

	b = BeautifulSoup(clean, "html.parser")
	b.prettify


	print("mvp")
	mvp = getWinners("all_mvp", b)

	print("dpoy")
	dpoy = getWinners("all_dpoy", b)

	print("smoy")
	smoy = getWinners("all_smoy", b)

	draft_list = (mvp, dpoy, smoy)
	return draft_list

def getWinners(table_name, soup_obj):
	b = soup_obj
	test = b.find_all('div', {"id":table_name} )

	x = test[0].find_all('td', {"class":"left"})

	name = []
	award_shares = []
	points_won = []

	attr = ['year','player','share', 'pts won'] # needs more attributes

	temp = pd.DataFrame(columns=attr)

	for i in range(1,int(len(x)/2)+1):
		player = x[(i-1)*2].get('csk')
		name.append(player)	

	share = test[0].find_all("td", {"data-stat" : "award_share"}) # need more attributes
	pts_won = test[0].find_all('td', {'data-stat': 'points_won'})
	for i in range(len(share)):
		award_shares.append(share[i].text)
		points_won.append(pts_won[i].text)

	


	# print(name)
	# print(award_shares)

	name_array = np.array(name)
	share_array = np.array(award_shares)
	pts_won_array = np.array(points_won)

	temp['player'] = name_array
	temp['share'] = share_array
	temp['pts won'] = pts_won_array
	temp['year'] = year

	# mvp_temp = pd.concat([mvp_temp, mvp_internal_temp], axis = 1)
	# print(temp)

	return (temp)




years = range(2014,2016)
mvp_df = pd.DataFrame()
dpoy_df = pd.DataFrame()
smoy_df = pd.DataFrame()


for year in years:
    #print(year)
    (mvp, dpoy, smoy) = draftGrab(year)
    # print(mvp)
    mvp_df = pd.concat([mvp_df,mvp],axis=0)
    dpoy_df = pd.concat([dpoy_df, dpoy], axis=0)
    smoy_df = pd.concat([smoy_df, smoy], axis=0)

print(mvp_df)

#mvp_df.to_csv('mvp.csv')
# dpoy_df.to_csv('dpoy.csv')
# smoy_df.to_csv('smoy.csv')

# Remove missing values 
# nba_draftees = df.dropna(how='all')

	



