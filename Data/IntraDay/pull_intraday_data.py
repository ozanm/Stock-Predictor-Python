import sys

import requests
import json

from datetime import datetime

current_date = datetime.today().strftime('%Y-%m-%d')

def sort(data):
    dates = []
    for obj in data:
        dates.append(int(obj["6. time"][-2:]))
    dates.sort()

    for i in range(len(dates)):
        if dates[i] < 10:
            dates[i] = "0" + str(dates[i])
        else:
            dates[i] = str(dates[i])

    for i in range(len(dates)):
        for j in range(len(data)):
            if data[j]["6. time"][-2:] == dates[i]:
                temp = data[j]
                data[j] = data[i]
                data[i] = temp
    return data

API_KEY = "UFE443FFI7CLZC26"

data = requests.get("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=" + sys.argv[1] + "&apikey=" + API_KEY).json()["Time Series (Daily)"]

stocks_data = []

for key, value in data.items():
    if key[0:7] == str(current_date[0:7]):
        value.update({ "6. time": key })
        stocks_data.append(value)

stocks_data = sort(stocks_data)

with open('/Users/ozanmirza/desktop/Stock-Predictor-Python/Data/IntraDay/intraday_data.json', 'w') as outfile:
    json.dump(stocks_data, outfile, indent=4, sort_keys=True)
