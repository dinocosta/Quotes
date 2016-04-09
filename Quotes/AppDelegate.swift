//
//  AppDelegate.swift
//  Quotes
//
//  Created by Joao Costa on 09/04/16.
//  Copyright © 2016 Joao Costa. All rights reserved.
//

import Cocoa

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {

	private var statusItem: NSStatusItem	=
		NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
	private let popover: NSPopover				= NSPopover()
	private var eventMonitor: EventMonitor?

	public func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Change status bar icon and tell OSX to invert image in dark mode.
		if let icon = NSImage(named: "StatusBarIcon") {
			statusItem.image	= icon
			icon.template			= true
		}
		
		// Set popover view controller.
		popover.contentViewController	= PopoverViewController(nibName: nil, bundle: nil)
		
		// Change status item action to toggle popover.
		statusItem.button?.action			= #selector(togglePopover)
		
		// Create an event monitor to listen when the mouse is clicked outside the popover
		// and close the popover.
		eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) {
			[unowned self] event -> () in
    		if self.popover.shown { self.closePopover(event) }
  		}
		eventMonitor?.start()
	}
	
	// Toggle Popover, show if hidden and hide if shown.
	public func togglePopover(sender: AnyObject?) {
		if popover.shown	{ closePopover(sender) }
		else								{ showPopover(sender) }
	}
		
	// Show popover.
	private func showPopover(sender: AnyObject?) {
		if let button = sender as? NSStatusBarButton {
			popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
		}
	}
	
	// Close Popover.
	private func closePopover(sender: AnyObject?) {
		popover.performClose(sender)
	}
}
