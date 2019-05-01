import AppKit

class AppDelegate: NSWindowController, NSApplicationDelegate, NSWindowDelegate {

  let windowController = MainWindowController()

  func applicationDidFinishLaunching(_ notification: Notification) {
    windowController.showWindow(self)
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

class MainWindowController: NSWindowController {
  convenience init() {
    self.init(window: NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1000, height: 650), styleMask: [.titled, .fullSizeContentView, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false))
    window!.contentViewController = MainViewController()
    window!.titleVisibility = .hidden
    window!.titlebarAppearsTransparent = true

    window!.center()
    window!.isMovableByWindowBackground = true
    window!.isOpaque = false
    window!.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0)

    let customToolbar = NSToolbar()
    customToolbar.showsBaselineSeparator = false
    window!.toolbar = customToolbar
  }
}
