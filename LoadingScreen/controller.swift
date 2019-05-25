import AppKit

// LOADING ANIMATION: https://im5.ezgif.com/tmp/ezgif-5-d7557c14edf0.gif

class AppDelegate: NSWindowController, NSApplicationDelegate, NSWindowDelegate {

  func applicationDidFinishLaunching(_ notification: Notification) {
    LoadingWindowController().showWindow(self) // Displaying window of app
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

class LoadingWindowController: NSWindowController, NSWindowDelegate {
  convenience init() {
    self.init(window: NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 400), styleMask: [.borderless], backing: .buffered, defer: false))
    window!.delegate = self
    window!.contentViewController = LoadingViewController()
    window!.titleVisibility = .hidden
    window!.titlebarAppearsTransparent = true
    window!.hasShadow = false // Removing shadow because it looks bad
    window!.invalidateShadow() // Keeping shadow away

    window!.center()
    window!.isMovableByWindowBackground = true
    window!.isOpaque = false
    window!.backgroundColor = NSColor.black
  }
}

class LoadingViewController : NSViewController {
  override func loadView() {
    self.view = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 400))
    self.view.wantsLayer = true
    self.view.layer!.backgroundColor = NSColor.black.cgColor
    self.view.layer!.cornerRadius = 35
    self.view.layer!.maskedCorners = [.layerMaxXMaxYCorner]

    self.view.autoresizesSubviews = true // To keep everything in porportion
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.

    NSApplication.shared.applicationIconImage = NSImage(contentsOf: URL(string: "https://i.imgur.com/9YhK6XK.png")!) // Displaying app icon

    // Playing Blop sound when app starts
    NSSound(contentsOf: URL(string: "https://drive.google.com/uc?export=download&id=1PFYOft5-nIysrfDGvOQfA279Wj5_VeiD")!, byReference: false)!.play()

    // Styling the loading gif and displaying it
    let animation = NSImageView(frame: self.view.bounds)
    animation.canDrawSubviewsIntoLayer = true
    animation.animates = true
    animation.image = NSImage(contentsOf: URL(string: "https://media.giphy.com/media/VFptbTQbk2zwRhO6FT/giphy.gif")!)
    self.view.addSubview(animation)

    animation.frame.size.width += 100
    animation.frame.size.height += 100
    animation.frame.origin.y -= 50
    animation.frame.origin.x -= 50
  }
}
