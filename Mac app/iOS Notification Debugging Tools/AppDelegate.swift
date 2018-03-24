//
//  AppDelegate.swift
//  iOS Notification Debugging Tools
//
//  Created by AppleBetas on 2018-03-10.
//  Copyright © 2018 Dynastic Development. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

