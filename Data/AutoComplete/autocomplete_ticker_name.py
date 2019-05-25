import fix_yahoo_finance as TickerData

import os
import sys
import requests
import json

# print("Beginning script for autocomplete")

# I don't know how the person on the stack overflow got this link :)
stocks = requests.get("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query={}&region=1&lang=en".format(sys.argv[1])).json()['ResultSet']['Result']

data = []

# First we autocomple for specified string in command line, then we get the info of every stock
for stock in stocks:
    data.append(TickerData.Ticker(stock["symbol"]).info)

# Making sure to open the absolute path because ran by swift
with open(os.path.abspath(os.path.dirname(os.path.realpath(__file__))) + '/autocomplete.json', 'w') as outfile:
    json.dump(data, outfile, indent=4, sort_keys=True) # Saving autocomplete file, ran with swift so I need the full absolute path

# print("Successfully autocompleted data for {}".format(sys.argv[1]))
