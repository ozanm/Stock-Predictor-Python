import AppKit

class AppDelegate: NSWindowController, NSApplicationDelegate, NSWindowDelegate {

  func applicationDidFinishLaunching(_ notification: Notification) {
    MainWindowController().showWindow(self)
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

class MainWindowController: NSWindowController, NSWindowDelegate {
  convenience init() {
    self.init(window: NSWindow(contentRect: NSScreen.main!.visibleFrame, styleMask: [.titled, .fullSizeContentView, .closable, .miniaturizable], backing: .buffered, defer: false))
    window!.delegate = self
    window!.contentViewController = MainViewController()
    window!.titleVisibility = .hidden
    window!.titlebarAppearsTransparent = true
    window!.hasShadow = false
    window!.invalidateShadow()

    window!.center()
    window!.isMovableByWindowBackground = true
    window!.isOpaque = false
    window!.backgroundColor = NSColor.clear

    let customToolbar = NSToolbar()
    customToolbar.showsBaselineSeparator = false
    window!.toolbar = customToolbar

    NotificationCenter.default.addObserver(self, selector: Selector("windowDidResize:"), name: NSWindow.didResizeNotification, object: nil)
  }
}

class GraphWindowController: NSWindowController, NSWindowDelegate {
  convenience init() {
    self.init(window: NSWindow(contentRect: NSScreen.main!.visibleFrame, styleMask: [.fullSizeContentView, .titled], backing: .buffered, defer: false))
    window!.contentViewController = GraphViewController()
    window!.titleVisibility = .hidden
    window!.titlebarAppearsTransparent = true
    window!.hasShadow = false
    window!.invalidateShadow()

    window!.center()
    window!.isMovableByWindowBackground = true
    window!.isOpaque = false
    window!.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0)

    window!.delegate = self
  }
}
