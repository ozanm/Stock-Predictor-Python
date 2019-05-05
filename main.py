import os
import sys

from LoadingScreen.LoadingScreen import LoadingScreen

if __name__ == '__main__':
    LoadingScreen().run()
    
    os.system("MainScreen/Screen/main")
    sys.exit(0)

class Setup:
    def __init__(self):
        pass
