# -*- coding: utf-8 -*-
"""
Created on Thu Oct 20 14:10:11 2016

@author: Kerry
"""


import requests # how python goes onto the internet!
from bs4 import BeautifulSoup # (version 4)
import unicodedata
import pandas as pd
import numpy as np
import csv
import re

r = requests.get('http://www.basketball-reference.com/draft/NBA_2015.html')
b = BeautifulSoup(r.text, "html.parser")
test = b.find_all('td', class_ = 'left ')
#test = b.find_all('tr')

test_list = []
for est in test:
    test_list.append(est)

columns = ['Team','Name','College']
draft_order = np.arange(1,61)
draft_list = pd.DataFrame(columns = columns, index = draft_order)


for i in range(1,int(len(test_list)/3)+1):
    team = test_list[(i-1)*3].get('csk')
    Name = test_list[(i-1)*3+1].get('csk')
    College = test_list[(i-1)*3+2].get('csk')
    
    draft_list['Team'][i] = team
    draft_list['Name'][i] = Name
    draft_list['College'][i] = College

 
draft_list['Pick'] = draft_list['Team'].str.split(".").str[1]
draft_list['Pick'] = draft_list['Pick'].str.lstrip('0')
draft_list['Team'] = draft_list['Team'].str.split(".").str[0]
print(draft_list)



    
    

        



