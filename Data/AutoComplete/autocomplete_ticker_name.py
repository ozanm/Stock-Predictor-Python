import sys
import requests
import json

# print("Beginning script for autocomplete")

data = requests.get("http://d.yimg.com/autoc.finance.yahoo.com/autoc?query={}&region=1&lang=en".format(sys.argv[1])).json()['ResultSet']['Result']

with open('autocomplete.json', 'w') as outfile:
    json.dump(data, outfile, indent=4, sort_keys=True)

# print("Successfully autocompleted data for {}".format(sys.argv[1]))
