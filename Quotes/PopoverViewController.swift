//
//  PopoverViewController.swift
//  Quotes
//
//  Created by Joao Costa on 09/04/16.
//  Copyright © 2016 Joao Costa. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController, NSPopoverDelegate {
	
	@IBOutlet weak var quoteTextField: NSTextField!
	@IBOutlet weak var authorTextField: NSTextField!
	
	let url: NSURL? =
		NSURL(string: "http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json")
	var quote: String = "Hello World" {
		didSet { quoteTextField.stringValue	= quote }
	}
	var author: String = "You" {
		didSet { authorTextField.stringValue = author }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}
	
	// Quit Application.
	@IBAction func quitApp(sender: AnyObject?) {
		NSApplication.sharedApplication().terminate(sender)
	}
	
	// Get a new quote and update the popover.
	@IBAction func newQuote(sender: AnyObject?) {
		if let url = url {
			// Create a new data task to make a request to the API.
			let session = NSURLSession.sharedSession()
			session.dataTaskWithURL(url) {
				[unowned self] (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
				if let data = data {
					do {
						// Try to convert data to JSON and extract the author and the quote.
						let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
						
						// Get the quote text from the JSON, trimming it.
						if let jsonQuote = json["quoteText"] as? String {
							self.quote = jsonQuote
							.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
							self.quote = "\"\(self.quote)\""
						} else { self.quote = "\"Something went wrong :/\"" }
						
						// Get the quote author from the JSON, trimming it.
						if let jsonAuthor = json["quoteAuthor"] as? String {
							self.author = jsonAuthor
  							.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
						} else { self.author = "Unknown" }
					} catch {
						// Failure reading JSON.
						self.quote	= "Something went wrong! Try again."
						self.author	= "This App"
					}
				} else if let error = error {
					print(error.localizedDescription)
				}
			}.resume()
		}
	}
	
	// Open default browser on the app github repo and close popover.
	@IBAction func openGithubPage(sender: AnyObject?) {
		if let githubURL = NSURL(string: "https://github.com/JoaoFCosta") {
			NSWorkspace.sharedWorkspace().openURL(githubURL)
			let delegate = NSApplication.sharedApplication().delegate as! AppDelegate
			delegate.togglePopover(sender)
		}
	}
	
}
