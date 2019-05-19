import fix_yahoo_finance as TickerData

import sys
import requests
import json

# print("Beginning script for autocomplete")

stocks = requests.get("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query={}&region=1&lang=en".format(sys.argv[1])).json()['ResultSet']['Result']
data = []

for stock in stocks:
    data.append(TickerData.Ticker(stock["symbol"]).info)

with open('autocomplete.json', 'w') as outfile:
    json.dump(data, outfile, indent=4, sort_keys=True)

# print("Successfully autocompleted data for {}".format(sys.argv[1]))
