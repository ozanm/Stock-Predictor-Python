import AppKit

class AppDelegate: NSWindowController, NSApplicationDelegate, NSWindowDelegate { // Delegate object attached to NSApp

  func applicationDidFinishLaunching(_ notification: Notification) {
    MainWindowController().showWindow(self)
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true // When window closes, automatically stop running
  }
}

class MainWindowController: NSWindowController, NSWindowDelegate {
  convenience init() {
    // Creating Standard window
    self.init(window: NSWindow(contentRect: NSScreen.main!.visibleFrame, styleMask: [.titled, .fullSizeContentView, .closable, .miniaturizable], backing: .buffered, defer: false))
    window!.delegate = self // Manipulating the window
    window!.contentViewController = MainViewController() // Content inside window
    // Styling the window
    window!.titleVisibility = .hidden
    window!.titlebarAppearsTransparent = true
    window!.hasShadow = false
    window!.invalidateShadow()

    // Customizing properties for interation
    window!.center()
    window!.isMovableByWindowBackground = true
    window!.isOpaque = false
    window!.backgroundColor = NSColor.clear

    // Lowering buttons
    let customToolbar = NSToolbar()
    customToolbar.showsBaselineSeparator = false
    window!.toolbar = customToolbar
  }
}

class GraphWindowController: NSWindowController, NSWindowDelegate {
  convenience init() {
    // Creating Standard window
    self.init(window: NSWindow(contentRect: NSScreen.main!.visibleFrame, styleMask: [.fullSizeContentView, .titled], backing: .buffered, defer: false))
    window!.contentViewController = GraphViewController()
    // Styling the window
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
