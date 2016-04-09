//
//  EventMonitor.swift
//  Quotes
//
//  Created by Joao Costa on 09/04/16.
//  Copyright © 2016 Joao Costa. All rights reserved.
//

import Cocoa

public class EventMonitor {
	private var monitor: AnyObject?
	private let mask: NSEventMask
	private let handler: NSEvent? -> ()
	
	public init(mask: NSEventMask, handler: NSEvent? -> ()) {
		self.mask			= mask
		self.handler	= handler
	}
	
	deinit { stop() }
	
	// Start Monitoring for the events according to the event mask and run the handler when needed.
	public func start() {
		monitor = NSEvent.addGlobalMonitorForEventsMatchingMask(mask, handler: handler)
	}
	
	public func stop() {
		if monitor != nil {
			NSEvent.removeMonitor(monitor!)
			monitor = nil
		}
	}
}