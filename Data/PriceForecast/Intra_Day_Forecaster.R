# Loading Data and setting it up
stock_data <- read.csv("/Users/ozanmirza/Desktop/Stock-Predictor-Python/Data/PriceForecast/inserted_price_data.csv")
attach(stock_data)

# Importing the libraries neccessary to predict with the ARIMA model
library(MASS)
library(tseries)
library(forecast)

# Plot and convert to log format for percentages
lnStockData = log(Close)

# ACF, PACF, and Dickey-Fuller Test
acf(lnStockData, lag.max=20)
pacf(lnStockData, lag.max=20)
difflnStockData <- diff(lnStockData, 1)

adf.test(lnStockData)
adf.test(difflnStockData)
# Time series and auto.arima
priceArima <- ts(lnStockData, start=c(2019, 02), frequency=12)
fitlnStockData <- auto.arima(priceArima)
plot(priceArima, type="l")
title('Stock Price')
exp(lnStockData)

# Forecasted Values from ARIMA Model (finally the good stuff)
forecasted_values <- forecast(fitlnStockData, h=26)
plot(forecasted_values)

forecastedvaluesextracted <- as.numeric(forecasted_values$mean)
final_forecast_values <- exp(forecastedvaluesextracted)
