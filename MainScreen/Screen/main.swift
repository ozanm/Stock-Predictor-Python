import AppKit

autoreleasepool { () -> () in
  NSApplication.shared.delegate = AppDelegate()
  NSApplication.shared.setActivationPolicy(.accessory)
  NSApplication.shared.run()
}

// swiftc -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk SearchScreenView.swift SearchScreenApplicationController.swift main.swift
// ./main
