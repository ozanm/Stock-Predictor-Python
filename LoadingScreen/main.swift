import AppKit

// APP_ICON: https://i.imgur.com/9YhK6XK.png

autoreleasepool { () -> () in
  NSApplication.shared.delegate = AppDelegate()
  // This puts an app icon on the dock
  NSApplication.shared.setActivationPolicy(.regular)
  NSApplication.shared.activate(ignoringOtherApps: true)
  NSApplication.shared.run()
  NSApplication.shared.dockTile.display()
}

// Commands:
//   - Complile: swiftc -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk main.swift controller.swift
//   - Run: ./main
