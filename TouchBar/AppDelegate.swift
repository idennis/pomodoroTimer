//
//  AppDelegate.swift
//  TouchBar
//
//  Created by Chris Ricker on 10/28/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }
  
}
