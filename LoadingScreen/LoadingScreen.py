import os
import sys

from kivy.app import App
from kivy.clock import Clock
from kivy.core.window import Window
from kivy.uix.button import Button
from kivy.uix.image import Image

if sys.platform == 'linux2':
    import subprocess
    output = subprocess.Popen(
        'xrandr | grep "\*" | cut -d" " -f4',
        shell=True,
        stdout=subprocess.PIPE).communicate()[0]
    screenx = int(output.replace('\n', '').split('x')[0])
    screeny = int(output.replace('\n', '').split('x')[1])
elif sys.platform == 'win32':
    from win32api import GetSystemMetrics
    screenx = GetSystemMetrics(0)
    screeny = GetSystemMetrics(1)
elif sys.platform == 'darwin':
    from AppKit import NSScreen
    frame_size = NSScreen.mainScreen().frame().size
    screenx = frame_size.width
    screeny = frame_size.height
else:
    # For mobile devices, use full screen
    screenx, screeny = 800, 600  # setting screen sizes

class LoadingScreen(App):
    def build(self):
        Window.borderless = True
        self.center_window(400, 400)
        self.icon = "FINAL.Circle.png"
        Clock.schedule_once(lambda dt: Window.close(), 3)
        return Image(source = 'loading.zip', anim_delay = 0.05, allow_stretch = True,  keep_ratio = True, keep_data = True)

    def center_window(self, sizex, sizey):
        Window.size = (sizex, sizey)
        Window.left = (screenx - sizex) / 2
        Window.top = (screeny - sizey) / 2
