# -*- coding: utf-8 -*-
"""
Created on Fri Oct 14 11:54:04 2016

@author: Kerry
"""

import requests # how python goes onto the internet!
from bs4 import BeautifulSoup # (version 4)
import unicodedata
import pandas as pd
import numpy as np
import csv


r = requests.get('http://www.basketball-reference.com/leagues/NBA_2016_advanced.html')
b = BeautifulSoup(r.text, "html.parser")

attrs = b.find('tr').text

#attrs = unicodedata.normalize('NFKD', attrs).encode('ascii','ignore')

attributes = attrs.split("\n")
advance_attr = [ 'season_end', 'player', 'Pos', 'Age', 'Tm', 'G', 'MP', 'PER', 'TS%', '3PAr', 'FTr', 'ORB%', 'DRB%', 'TRB%', 'AST%', 'STL%', 'BLK%', 'TOV%', 'USG%','blnk', 'OWS', 'DWS', 'WS', 'WS/48','blnk2','OBPM', 'DBPM', 'BPM', 'VORP']
basic_attr = ["season_end","player","Pos","Age","Tm","G","GS","MP","FG","FGA","FG%","3P","3PA","3P%","2P","2PA","2P%","eFG%","FT","FTA","FT%","ORB","DRB","TRB","AST","STL","BLK","TOV","PF","PS/G"]
#year = 2015

def BasicStats(year):
    df = pd.DataFrame(columns = basic_attr)
    r =requests.get('http://www.basketball-reference.com/leagues/NBA_'+ str(year) +'_per_game.html')
    b = BeautifulSoup(r.text, "html.parser")
    players_data = b.find_all('tr', attrs = {"class":"full_table"})
    for player in players_data:
        players_bas = player.find_all('td')
        players_bas_list = []
        players_bas_list.append(str(year))
        for att in players_bas:
            players_bas_list.append(str(att.text))
        df.loc[len(df)] = players_bas_list
    return df

years = range(1989,2016)
basic_player_stats = pd.DataFrame()
for year in years:
    stats = BasicStats(year)
    basic_player_stats = basic_player_stats.append(stats)
     
def AdvanceStats(year):
    df = pd.DataFrame(columns = advance_attr)
    r = requests.get('http://www.basketball-reference.com/leagues/NBA_'+ str(year) +'_advanced.html')
    b = BeautifulSoup(r.text,"html.parser")
    players_data_adv = b.find_all('tr',attrs = {"class":"full_table"})
#    print(players_data_adv)
    for player in players_data_adv:
        players_adv = player.find_all('td')
#        print(players_adv)
        players_adv_list = []
        players_adv_list.append(str(year))
        for att in players_adv:
            players_adv_list.append(str(att.text))
#            print(players_adv_list[:])
        df.loc[len(df)] = players_adv_list
    return df
#AdvanceStats(2015)        

years = range(1989,2016)
advance_player_stats = pd.DataFrame()
for year in years:
    stats = AdvanceStats(year)
    advance_player_stats = advance_player_stats.append(stats)

advance_player_stats['player'] = advance_player_stats['player'].map(lambda x:x.strip('*'))
#Merge
CurrentStats=pd.merge(basic_player_stats,advance_player_stats,how = "left", on = ['player', 'season_end'])


