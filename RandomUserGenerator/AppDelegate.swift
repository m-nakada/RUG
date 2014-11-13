//
//  AppDelegate.swift
//  RandomUserGenerator
//
//  Created by m-nakada on 11/12/2014.
//  Copyright (c) 2014 Nekojarashi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var pictureView: NSImageView!
  @IBOutlet weak var usernameTextField: NSTextField!
  @IBOutlet weak var nameTextField: NSTextField!
  @IBOutlet weak var emailTextField: NSTextField!
  @IBOutlet weak var legoSwitch: NSButtonCell!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  @IBOutlet weak var refreshButton: NSButton!
  @IBOutlet weak var saveImageButton: NSButton!
  @IBOutlet weak var copyButton1: NSButton!
  @IBOutlet weak var copyButton2: NSButton!
  @IBOutlet weak var copyButton3: NSButton!
  
  var copyButtons: Array<NSButton> = [];
  var textFileds: Array<NSTextField> = [];

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Insert code here to initialize your application
    self.copyButtons = [self.copyButton1, self.copyButton2, self.copyButton3]
    self.textFileds  = [self.usernameTextField, self.nameTextField, self.emailTextField]
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }

  @IBAction func refreshAction(sender: AnyObject) {
    self.getRondomUser()
  }
  
  @IBAction func saveAction(sender: AnyObject) {
    // Decide destination path
    let name = self.nameTextField.stringValue
    let path = NSHomeDirectory().stringByAppendingString("/Desktop/\(name).png")

    // Export image to Desktop
    let image = self.pictureView.image!
    let representations = image.representations as NSArray
    let imageRep = representations.firstObject as NSBitmapImageRep
    let data = imageRep.representationUsingType(.NSPNGFileType, properties: [NSImageInterlaced: true])
    data?.writeToFile(path, atomically: true)
  }
  
  @IBAction func copyAction(sender: AnyObject) {
    // Copy to pasteboard
    let str = self.textFileds[sender.tag()].stringValue
    let pb = NSPasteboard.generalPasteboard()
    pb.declareTypes([NSStringPboardType], owner: self)
    pb.setString(str, forType: NSStringPboardType)
  }
  
  func startLoding() {
    self.progressIndicator.startAnimation(self)
    self.pictureView.image = nil
    self.usernameTextField.stringValue = ""
    self.nameTextField.stringValue = ""
    self.emailTextField.stringValue = ""
  }
  
  func stopLoding() {
    self.progressIndicator.stopAnimation(self)
  }
  
  func getRondomUser() {
    self.startLoding()
    
    let url = self.legoSwitch.state == NSOnState ? "http://api.randomuser.me/0.4/?lego" : "http://api.randomuser.me/"
    let request = NSURLRequest(URL: NSURL(string: url)!)
    var session = NSURLSession.sharedSession()
    
    // Download JSON
    var resultsTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if (data != nil) {
        var error: NSError?
        let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
        println("json \(json)")
        
        // Retrieve user
        let results = json["results"] as NSArray
        let user = results.firstObject?.objectForKey("user") as NSDictionary
        
        // Retrieve name
        let name  = user["name"] as NSDictionary
        let first = name["first"] as String
        let last  = name["last"] as String
        
        let username = user["username"] as String
        let email = user["email"] as String
        
        // Retrieve picture url
        let pictureObj = user["picture"] as NSObject
        var picture = "" as String

        // For LEGO
        if pictureObj is NSString {
          picture = user["picture"] as String
        }

        // For Normal
        if pictureObj is NSDictionary {
          let pictureDict = user["picture"] as NSDictionary
          picture = pictureDict["large"] as String
        }

        // Download Picture
        let pictureRequest = NSURLRequest(URL: NSURL(string: picture)!)
        var pictureTask = session.dataTaskWithRequest(pictureRequest, completionHandler: { (data, respoonse, error) -> Void in
          let image = NSImage(data: data)
          
          self.stopLoding()
          
          // Update UI
          dispatch_async(dispatch_get_main_queue()) {
            self.pictureView.image = image
            self.nameTextField.stringValue = first.capitalizedString + " " + last.capitalizedString
            self.usernameTextField.stringValue = first + "-" + last
            self.emailTextField.stringValue = email
          }
        })
        
        pictureTask.resume()
      }
    })
    
    resultsTask.resume()
  }
}
