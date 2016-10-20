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

r = requests.get('http://www.basketball-reference.com/draft/NBA_2015.html')
b = BeautifulSoup(r.text, "html.parser")

players =b.find("tbody").text.split("\n")

players[1][0] #First round
players[1][1] #First Pick
players[1][2:5] #Team
players.split[5:]



