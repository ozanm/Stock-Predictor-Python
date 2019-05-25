import fix_yahoo_finance as TickerData

import json # Used to put data in JSON file

# Why do indexes need the carrot top infront of them lol
indices = ["^DJI", "^GSPC", "^IXIC", "^RUT", "CL=F", "GC=F", "SI=F", "EURUSD=X", "^TNX", "^VIX"]

indices_data = []

for index in indices: # Getting info for every index needed
    indices_data.append(TickerData.Ticker(index).info)

with open("featuredindicies.json", "w") as outfile: # Basically same script as the other featured one
    json.dump(indices_data, outfile, indent=4, sort_keys=True)
