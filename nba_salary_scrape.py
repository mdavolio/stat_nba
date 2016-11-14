# -*- coding: utf-8 -*-
"""
Created on Fri Oct 14 11:54:04 2016

@author: Kerry
"""

import requests # how python goes onto the internet!
from bs4 import BeautifulSoup # (version 4)
import pandas as pd


r = requests.get('http://www.basketball-reference.com/leagues/NBA_2016_advanced.html')
b = BeautifulSoup(r.text, "html.parser")

attrs = b.find('tr').text

#attrs = unicodedata.normalize('NFKD', attrs).encode('ascii','ignore')

attributes = attrs.split("\n")
salary_attr = ['RK','NAME','TEAM','SALARY']
#year = 2015

def SalaryStats(year,page):
    df = pd.DataFrame(columns = salary_attr)
    r =requests.get('http://http://www.espn.com/nba/salaries/_/year/' + str(year) + '/seasontype/'+ str(page) + '.html')
    b = BeautifulSoup(r.text, "html.parser")
    players_sal_data = b.find_all('tr', attrs = {"class":"full_table"})
    for player in players_sal_data:
        players_bas = player.find_all('td')
        players_bas_list = []
        players_bas_list.append(str(year))
        for att in players_bas:
            players_bas_list.append(str(att.text))
        df.loc[len(df)] = players_bas_list
    return df

years = range(2007,2018)
pages = range(1,2)
player_salaries = pd.DataFrame()
for year in years:
  for page in pages:
    salaries = SalaryStats(year,page)
    player_salaries = player_salaries.append(salaries)
     
