#! /usr/bin/env python

# importing libraries
import threading
import subprocess
import traceback
import shlex
import urllib2
import json
import sys
import os

# Used for the Directory
import pyperclip

DIRECTORY = os.path.dirname(os.path.realpath(__file__))

pyperclip.copy(DIRECTORY)

class Setup: # Uses methods to make sure app won't carsh and updates starting data
    activatedSystems = { "Internet": False, "Indicies": False, "Stocks": False } # the test/check varibales
    def bind(self, process, callback):
        """ Runs the methods for making sure all the requirements are in place before excecuting app's contents. """
        process.run(shell=True)
        self.checkForInternetConnection()
        self.fetchFeaturedIndicies()
        self.fetchFeaturedStocks()

        if self.allSystemsActivated():
            process.process.terminate()
            callback.run(shell=True)

    def checkForInternetConnection(self):
        """ Checks for the internet connect by trying connect to one of Google's ip and returns the status of the connection. """
        try:
            urllib2.urlopen('http://216.58.192.142', timeout=1) # Connecting to Google
            self.activatedSystems["Internet"] = True # It Works!! :)
        except:
            pass # don't need to do anything here :)

    def fetchFeaturedIndicies(self):
        """ Runs the Python script for extracting the quote data for the featured indicies. """
        os.system("python " + DIRECTORY + "/Data/FeaturedIndicies/fetch_featured_indicies.py")
        self.activatedSystems["Indicies"] = True # It Works!!

    def fetchFeaturedStocks(self):
        """ Runs the Python script for extracting the quote data for the featured stocks. """
        os.system("python " + DIRECTORY + "/Data/FeaturedStocks/fetch_featured_stocks.py") # Just running a different python script
        self.activatedSystems["Stocks"] = True

    def allSystemsActivated(self):
        # returns True if all values are True, False otherwise
        return self.activatedSystems["Internet"] and self.activatedSystems["Indicies"] and self.activatedSystems["Stocks"]


class Command(object):
    command = None # The line to excecute
    process = None # The subprocess object that runs the commands
    status = None # Where the process is: Running, Stopped
    output, error = '', ''

    def __init__(self, command):
        """ Enables to run subprocess commands in a different thread with TIMEOUT option.
            :param command: The command to run
        """
        if isinstance(command, basestring): # Switching out multiple commands
            command = shlex.split(command)
        self.command = command

    def run(self, timeout=None, **kwargs): # Time for the good stuff
        """ Run a command then return: (status, output, error). """
        def target(**kwargs): # Setting up sub-params for the subprocess
        # Implementing self.output, self.error
            try:
                self.process = subprocess.Popen(self.command, **kwargs)
                self.output, self.error = self.process.communicate()
                self.status = self.process.returncode
            except:
                self.error = traceback.format_exc()
                self.status = -1
        # default stdout and stderr
        if 'stdout' not in kwargs:
            kwargs['stdout'] = subprocess.PIPE
        if 'stderr' not in kwargs:
            kwargs['stderr'] = subprocess.PIPE
        # thread
        thread = threading.Thread(target=target, kwargs=kwargs)
        thread.start()

class LoadingScreen(Command): # Made as a placeholder for better code
    def __init__(self):
        """ Creates a command class for displaying the loading screen. """
        super(LoadingScreen, self).__init__(DIRECTORY + "/LoadingScreen/main")

class MainScreen(Command): # Made as a placeholder for better code
    def __init__(self):
        """ Creates a command class for displaying the main window. """
        # For the rest of the program, making sure that the directory is in the project
        os.chdir(DIRECTORY + "/MainScreen/Screen")
        super(MainScreen, self).__init__(DIRECTORY + "/MainScreen/Screen/main")

if __name__ == '__main__': # Running main thread
    system = Setup().bind(process=LoadingScreen(), callback=MainScreen()) # Displaying loading screen
