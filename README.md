# Stock-Predictor-Python
This is a python program that analyzes current stock market day, and produces a graph of what it will be. It was turned into an executable with Swift as the UI. It was made with a partner for my Intermediate Computer Programming Final Project.

# Installation
Please make sure you have Swift 4 installed on your system.
  If there are any Python libraries that the script needs and is not on your computer, they will be installable with pip.
  
# Usage
Double click on the Stock Predictor executable.
  
# Screenshots
![](https://github.com/ozanmirza1/Stock-Predictor-Python/blob/master/ScreenShots/ScreenShot7.png)
![](https://github.com/ozanmirza1/Stock-Predictor-Python/blob/master/ScreenShots/ScreenShot6.png)
![](https://github.com/ozanmirza1/Stock-Predictor-Python/blob/master/ScreenShots/ScreenShot5.png)
![](https://github.com/ozanmirza1/Stock-Predictor-Python/blob/master/ScreenShots/ScreenShot4.png)
![](https://github.com/ozanmirza1/Stock-Predictor-Python/blob/master/ScreenShots/ScreenShot3.png)
![](https://github.com/ozanmirza1/Stock-Predictor-Python/blob/master/ScreenShots/ScreenShot2.png)
![](https://github.com/ozanmirza1/Stock-Predictor-Python/blob/master/ScreenShots/ScreenShot1.png)

# Discussion
For my final project of my Intermediate Computer Programming class, I knew that the entire CS department was expecting a lot because I was able to build a reputation in the best programmer in the school. So I decided to create an app that has always piqued my curiosity. A native Mac OS X desktop app with a modern UI design such as Clean My Mac X’s, but built entirely without a bundle. This means that I would be creating all my code and files from scratch and to build, compile, and test the app I would need to use terminal commands. This particular app was a stock predictor app where the user could look up any stock symbol and the app would use real-time data to predict how the stock’s prices will look for the rest of the year. I immediately looked into it, and sure enough, there was a way but it was only found in one tutorial and that tutorial left a lot of questions unanswered and only taught with a very small and simple app. And with that gateway, I explored a world that allowed me to understand Mac’s OS to a deeper level. Whenever I encountered a problem I would look it up and find that the answer explained how Xcode worked. Sometimes I would explorer Xcode itself to figure out how to build a part of the app. When I finished the basic UI, I started to integrate Python to do the data scraping, and I also used R for the predictor algorithm. And in order to integrate the two languages to work simultaneously during run-time, I had to create a system where the Swift code would run terminal commands after the user clicks on an action such as auto-complete search, or show a stock’s data, which will run a certain python script with the right arguments, and then organize the data in a designated JSON file that the Swift code would read, and then display. I wanted the finished product to be a packaged application just like any other software with its own pkg installer which I found to be really tough because of the number of files required and the manipulation of directories during run time. However, in the end, the app turned out to be just how I desired and I want to work more towards building similar software.
