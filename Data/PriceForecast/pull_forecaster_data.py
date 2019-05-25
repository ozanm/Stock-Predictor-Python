#import sys class to read user args in command line
import sys

#import external pandas_datareader library with alias of web
import pandas_datareader as web
#import pasndas datareader for csv parsing
import pandas as pd

#import datetime internal datetime module
#datetime is a Python module
from datetime import datetime, date, time, timedelta

#datetime is a data type within the datetime module
start = datetime.today() - timedelta(days=96)
end = datetime.today()

#DataReader method name is case sensitive
df = web.DataReader(sys.argv[1], "yahoo", start, end)

#csv file must not
#be open in another app, such as Excel

df.to_csv('inserted_price_data.csv')
