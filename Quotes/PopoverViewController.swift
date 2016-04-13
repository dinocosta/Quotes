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
	@IBOutlet weak var playButton: NSButton!
	
	let url: NSURL? =
		NSURL(string: "http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json")
	var quote: String = "Hello World" {
		didSet { quoteTextField.stringValue	= quote }
	}
	var author: String = "You" {
		didSet { authorTextField.stringValue = author }
	}
	var connected: Bool {
		get { return Reachability.isConnectedToNetwork() }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Change plya button icon and tell OSX to invert it in dark mode.
		let playIcon				= NSImage(named: "PlayIcon")
		playIcon?.template	= true
		playButton.image		= playIcon
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
				if let data = data, JSONString = NSString(data: data, encoding: NSUTF8StringEncoding) {
					// Remove '\' from the quoteText field to prevent JSON Serialization from failing.
					let fixedString	=
						JSONString.stringByReplacingOccurrencesOfString("\\", withString: "") as NSString
					let fixedData		= fixedString.dataUsingEncoding(NSUTF8StringEncoding)
					
					do {
						// Try to convert data to JSON and extract the author and the quote.
						let json = try NSJSONSerialization.JSONObjectWithData(fixedData!,
							options: NSJSONReadingOptions())
						
						// Get the quote text from the JSON, trimming it.
						if let jsonQuote = json["quoteText"] as? String {
							self.quote = jsonQuote
							.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
							.stringByReplacingOccurrencesOfString("\\", withString: "")
							self.quote = "\"\(self.quote)\""
						} else { self.quote = "\"Something went wrong :/\"" }
						
						// Get the quote author from the JSON, trimming it.
						if let jsonAuthor = json["quoteAuthor"] as? String {
							self.author = jsonAuthor
  							.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
							
							if self.author == "" { self.author = "Unknown" }
						}
					} catch {
						// Failure reading JSON.
						self.quote	= "Something went wrong! Try again."
						self.author	= "This App"
					}
				} else if error != nil {
					// No Internet Connection.
					if !self.connected {
						self.quote	= "\"It seems that you are not connected to the internet!\""
						self.author	= "This App"
					}
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
	
	// Copy quote to clipboard.
	@IBAction func copyQuote(sender: AnyObject?) {
		let pasteBoard: NSPasteboard = NSPasteboard.generalPasteboard()
		pasteBoard.clearContents()
		pasteBoard.writeObjects(["\(quote) - \(author)\n"])
	}
	
	@IBAction func sayQuote(sender: AnyObject?) {
		let task: NSTask	= NSTask()
		task.launchPath		= "/usr/bin/say"
		task.arguments		= ["--voice=Alex", "\(quote) - \(author)\n"]
		task.launch()
	}
}
