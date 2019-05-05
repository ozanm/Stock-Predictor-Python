import fix_yahoo_finance as TickerData

import json

indices = ["^DJI", "^GSPC", "^IXIC", "^RUT", "CL=F", "GC=F", "SI=F", "EURUSD=X", "^TNX", "^VIX"]

indices_data = []

for index in indices:
    indices_data.append(TickerData.Ticker(index).info)

with open("featuredindicies.json", "w") as outfile:
    json.dump(indices_data, outfile, indent=4, sort_keys=True)
