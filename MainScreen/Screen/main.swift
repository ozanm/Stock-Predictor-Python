import AppKit

autoreleasepool { () -> () in // Releases values right after termination
  NSApplication.shared.delegate = AppDelegate()
  NSApplication.shared.setActivationPolicy(.regular)
  NSApplication.shared.activate(ignoringOtherApps: true)
  NSApplication.shared.run()
  NSApplication.shared.dockTile.display() // Making App Icon
}

// Commands:
//   - Complile: swiftc -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk StockStructer.swift HelperExtensions.swift SearchScreenView.swift GraphScreenView.swift ScreenApplicationController.swift main.swift
//   - Run: ./main
