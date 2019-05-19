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
    self.init(window: NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1000, height: 650), styleMask: [.titled, .fullSizeContentView, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false))
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

    window!.delegate = self
  }

  func windowWillResize(notification: NSNotification) {
    print("CALLED")
    self.window!.contentViewController!.view.subviews[0].frame.origin = NSPoint(x: self.window!.contentViewController!.view.bounds.size.width - 60, y: self.window!.contentViewController!.view.bounds.size.height - 80)
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
