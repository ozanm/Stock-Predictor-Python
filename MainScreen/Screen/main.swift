import AppKit

autoreleasepool { () -> () in
  NSApplication.shared.delegate = AppDelegate()
  NSApplication.shared.setActivationPolicy(.accessory)
  NSApplication.shared.activate(ignoringOtherApps: true)
  NSApplication.shared.run()
}

// Commands:
//   - Complile: swiftc -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk StockStructer.swift HelperExtensions.swift SearchScreenView.swift GraphScreenView.swift ScreenApplicationController.swift main.swift
//   - Run: ./main
