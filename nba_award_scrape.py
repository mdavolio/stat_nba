	
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
	getWinners("all_mvp", b)

	print("dpoy")
	getWinners("all_dpoy", b)

	print("smoy")
	getWinners("all_smoy", b)

	draft_list = 1
	return draft_list


def getWinners(table_name, soup_obj):
	b = soup_obj
	test = b.find_all('div', {"id":table_name} )

	x = test[0].find_all(class_ = 'left')

	name = []

	for i in range(1,int(len(x)/2)+1):
		player = x[(i-1)*2].get('csk')
		name.append(player)

	x = test[0].find_all('td', {"class":"left"})

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




draftGrab(2014)
# years = range(1989,2016)
# df = pd.DataFrame()

# for year in years:
#     print(year)
#     Draft_list = draftGrab(year)
#     df = df.append(Draft_list)

# print(df)
# Remove missing values 
# nba_draftees = df.dropna(how='all')

	



