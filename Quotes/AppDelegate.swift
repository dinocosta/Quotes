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

	var statusItem: NSStatusItem	=
		NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
	let popover: NSPopover				= NSPopover()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Change status bar icon and tell OSX to invert image in dark mode.
		if let icon = NSImage(named: "StatusBarIcon") {
			statusItem.image	= icon
			icon.template			= true
		}
		
		// Set popover view controller.
		popover.contentViewController	= PopoverViewController(nibName: nil, bundle: nil)
		
		// Change status item action to toggle popover.
		statusItem.button?.action			= #selector(togglePopover)
	}
	
	// Toggle Popover, show if hidden and hide if shown.
	func togglePopover(sender: AnyObject?) {
		if popover.shown	{ closePopover(sender) }
		else								{ showPopover(sender) }
	}
		
	// Show popover.
	func showPopover(sender: AnyObject?) {
		if let button = sender as? NSStatusBarButton {
			popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
		}
	}
	
	// Close Popover.
	func closePopover(sender: AnyObject?) {
		popover.performClose(sender)
	}
}
