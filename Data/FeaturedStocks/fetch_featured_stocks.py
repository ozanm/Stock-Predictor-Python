import fix_yahoo_finance as TickerData # Class to get data

import json

stocks = ["AAPL", "FB", "GOOG", "MSFT", "GE", "TSLA", "INTC", "IBM"] # The Featured stocks' symbols

stocks_data = []

for stock in stocks:
    stocks_data.append(TickerData.Ticker(stock).info) # The info has all the quote data

with open('featuredstocks.json', 'w') as outfile:
    # Saving the final data to the specified JSON file and insertting tabs when needed
    json.dump(stocks_data, outfile, indent=4, sort_keys=True)
