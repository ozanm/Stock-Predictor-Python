import requests
import json
import sys

from datetime import datetime
current_date = datetime.today().strftime('%Y-%m-%d')

API_KEY = "UFE443FFI7CLZC26"

data = requests.get("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=" + sys.argv[1] + "&apikey=" + API_KEY).json()["Time Series (Daily)"]

stocks_data = []
for key, value in data.items():
    if key[0:7] == str(current_date[0:7]):
        value.update({ "6. time": key })
        stocks_data.append(value)

with open('intraday_data.json', 'w') as outfile:
    json.dump(stocks_data, outfile, indent=4, sort_keys=True)
