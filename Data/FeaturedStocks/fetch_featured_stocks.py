import fix_yahoo_finance as TickerData

import json

# print("Beginning script for autocomplete")

stocks = ["AAPL", "FB", "GOOG", "MSFT", "GE", "TSLA", "INTC", "IBM"]

stocks_data = []

for stock in stocks:
    stocks_data.append(TickerData.Ticker(stock).info)

with open('featuredstocks.json', 'w') as outfile:
    json.dump(stocks_data, outfile, indent=4, sort_keys=True)
