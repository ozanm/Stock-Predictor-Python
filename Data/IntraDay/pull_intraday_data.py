import sys
import os

import requests
import json

from datetime import datetime

current_date = datetime.today().strftime('%Y-%m-%d') # Getting today's date for organizing the data

def sort(data):
    """ Takes the data from the Yahoo! finance and sorts it by time
        :param data: The times to be sorted
    """
    dates = []
    for obj in data:
        dates.append(int(obj["6. time"][-2:]))

    dates.sort() # Now that we have a list of numbers we can use the Python sort function

    for i in range(len(dates)):
        if dates[i] < 10: # Reformatting back
            dates[i] = "0" + str(dates[i])
        else:
            dates[i] = str(dates[i])

    for i in range(len(dates)):
        for j in range(len(data)):
            if data[j]["6. time"][-2:] == dates[i]: # Checking which time was there
            # Triangle swap taught in Mr. Golanka's class
                temp = data[j]
                data[j] = data[i]
                data[i] = temp
    return data

API_KEY = "UFE443FFI7CLZC26" # From AlphaVantage for the email ozan.i.mirza@gmail.com

# Pulling from AlphaVantage's timeseries 100 days data center. The symbol would be inputted from the command line
data = requests.get("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=" + sys.argv[1] + "&apikey=" + API_KEY).json()["Time Series (Daily)"]

stocks_data = [] # The Final data to be filtered

for key, value in data.items():
    if key[0:7] == str(current_date[0:7]): # Checking the time is in the same month
        value.update({ "6. time": key })
        stocks_data.append(value) # Making the time that was the key as a value

stocks_data = sort(stocks_data) # Sorting the list

with open('intraday_data.json', 'w') as outfile:
    json.dump(stocks_data, outfile, indent=4, sort_keys=True) # Writing it to the JSON file and formatting it
