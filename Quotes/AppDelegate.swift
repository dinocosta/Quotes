//
//  AppDelegate.swift
//  Quotes
//
//  Created by Joao Costa on 09/04/16.
//  Copyright © 2016 Joao Costa. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let statusItem: NSStatusItem =
		NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Change status bar icon and tell OSX to invert image in dark mode.
		if let icon = NSImage(named: "StatusBarIcon") {
			statusItem.image	= icon
			icon.template			= true
		}
	}

}

