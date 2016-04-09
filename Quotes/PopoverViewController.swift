//
//  PopoverViewController.swift
//  Quotes
//
//  Created by Joao Costa on 09/04/16.
//  Copyright © 2016 Joao Costa. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController, NSPopoverDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}
	
	// Quit Application.
	@IBAction func quitApp(sender: AnyObject?) {
		exit(EXIT_SUCCESS)
	}
	
}
