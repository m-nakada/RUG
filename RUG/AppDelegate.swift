//
//  AppDelegate.swift
//  RUG
//
//  Created by m-nakada on 11/12/2014.
//  Copyright (c) 2014 mna. All rights reserved.
//

import Cocoa
import Himotoki

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  // MARK: - Outlet
  
  @IBOutlet weak var copyButton1: NSButton!
  @IBOutlet weak var copyButton2: NSButton!
  @IBOutlet weak var copyButton3: NSButton!
  @IBOutlet weak var emailTextField: NSTextField!
  @IBOutlet weak var legoSwitch: NSButton!
  @IBOutlet weak var legoSwitchCell: NSButtonCell!
  @IBOutlet weak var nameTextField: NSTextField!
  @IBOutlet weak var pictureView: NSImageView!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  @IBOutlet weak var refreshButton: NSButton!
  @IBOutlet weak var saveImageButton: NSButton!
  @IBOutlet weak var usernameTextField: NSTextField!
  @IBOutlet weak var window: NSWindow!

  // MARK: - Property
  
  var buttons:    [NSControl] = []
  var textFileds: [NSControl] = []
  var controls:   [NSControl] = []
  var pictureData: NSData?
  
  // MARK: - NSApplicationDelegate
  
  func applicationDidFinishLaunching(notification: NSNotification) {
    buttons    = [legoSwitch, refreshButton, saveImageButton, copyButton1, copyButton2, copyButton3]
    textFileds = [usernameTextField, nameTextField, emailTextField]
    controls   = buttons + textFileds
  }

  // MARK: - Action
  
  @IBAction func refreshAction(sender: AnyObject) {
    getRondomUser()
  }
  
  @IBAction func saveAction(sender: AnyObject) {
    // Export image to Desktop
    let path = NSHomeDirectory() + "/Desktop/\(nameTextField.stringValue).jpg"
    pictureData?.writeToFile(path, atomically: true)
  }
  
  @IBAction func copyAction(sender: AnyObject) {
    // Copy to pasteboard
    let str = textFileds[sender.tag()].stringValue
    let pb = NSPasteboard.generalPasteboard()
    pb.declareTypes([NSStringPboardType], owner: self)
    pb.setString(str, forType: NSStringPboardType)
  }
  
  // MARK: - Helper
  
  func startLoding() {
    progressIndicator.startAnimation(self)
    pictureView.image = nil
    usernameTextField.stringValue = ""
    nameTextField.stringValue = ""
    emailTextField.stringValue = ""
    controls.forEach { $0.enabled = false }
  }
  
  func stopLoding() {
    progressIndicator.stopAnimation(self)
    controls.forEach { $0.enabled = true }
  }
  
  func getRondomUser() {
    startLoding()
    let url = legoSwitch.state == NSOnState ? "http://api.randomuser.me/?lego" : "http://api.randomuser.me/"
    let request = NSURLRequest(URL: NSURL(string: url)!)

    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
      guard let data = data else { return }
      
      do {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] else { return }
        let rug: RUG = try decode(json)
        guard let result = rug.results.first else { return }
        
        self.downloadPicture(result.user.picture)
        
        dispatch_async(dispatch_get_main_queue()) {
          self.nameTextField.stringValue     = result.user.displayName
          self.usernameTextField.stringValue = result.user.username
          self.emailTextField.stringValue    = result.user.email
        }
        
      } catch let error as NSCocoaError {
        print(error)
      } catch let DecodeError.MissingKeyPath(keyPath) {
        print("Missing key path: \(keyPath)")
      } catch {
        print("Unknwon decode error")
      }
    }
    task.resume()
  }
  
  func downloadPicture(picture: Picture) {
    guard let url = NSURL(string: picture.large) else { return }
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: url)) { (data, respoonse, error) in
      dispatch_async(dispatch_get_main_queue()) { self.stopLoding() }
      
      guard let data = data, image = NSImage(data: data) else { return }
      self.pictureData = data;
      
      dispatch_async(dispatch_get_main_queue()) {
        self.pictureView.image = image
      }
    }
    task.resume()
  }
  
}
