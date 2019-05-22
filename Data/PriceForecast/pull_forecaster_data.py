#import sys class to read user args in command line
import sys

#import external pandas_datareader library with alias of web
import pandas_datareader as web

#import datetime internal datetime module
#datetime is a Python module
from datetime import datetime

#datetime is a data type within the datetime module
start = datetime.today() - timedelta(days=96)
end = datetime.now()

#DataReader method name is case sensitive
df = web.DataReader("nvda", sys.argv[1], start, end)

#invoke to_csv for df dataframe object from
#DataReader method in the pandas_datareader library

#..\first_yahoo_prices_to_csv_demo.csv must not
#be open in another app, such as Excel

df.to_csv('inserted_price_data.csv')
