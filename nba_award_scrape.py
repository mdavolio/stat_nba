	
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

	for i in range(1,int(len(x)/2)+1):
		player = x[(i-1)*2].get('csk')
		name.append(player)	

	results = test[0].find_all("td", {"data-stat" : "award_share"})
	# print(results)
	for i in range(len(results)):
		award_shares.append(results[i].text)	

	print(name)
	print(award_shares)

	return (name, award_shares)




years = range(1989,2016)
mvp_df = pd.DataFrame()
dpoy_df = pd.DataFrame()
smoy_df = pd.DataFrame()


for year in years:
    print(year)
    (mvp, dpoy, smoy) = draftGrab(year)
    mvp_df = mvp_df.append(pd.DataFrame(list(mvp)))
    dpoy_df = dpoy_df.append(pd.DataFrame(list(dpoy)))
    smoy_df = smoy_df.append(pd.DataFrame(list(smoy)))

mvp_df.to_csv('mvp.csv')
dpoy_df.to_csv('dpoy.csv')
smoy_df.to_csv('smoy.csv')

# Remove missing values 
# nba_draftees = df.dropna(how='all')

	



