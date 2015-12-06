//
//  RUGUITests.swift
//  RUGUITests
//
//  Created by mitsuru on 12/6/15.
//  Copyright © 2015 mna. All rights reserved.
//

import XCTest

class RUGUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  private func waitForElementToEnable(element: XCUIElement) {
    let existsPredicate = NSPredicate(format: "enabled == true")
    expectationForPredicate(existsPredicate, evaluatedWithObject: element, handler: nil)
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  func testLEGOCheckbox() {
    let lego = UI.CheckBox.lego
    lego.click()
    XCTAssertTrue(lego.enabled)
  }
  
  func testRefresh() {
    let refresh      = UI.Button.refresh
    let username     = UI.TextField.username
    let name         = UI.TextField.name
    let email        = UI.TextField.email
    let copyUsername = UI.Button.copyUsername
    let copyName     = UI.Button.copyName
    let copyEmail    = UI.Button.copyEmail
    
    refresh.click()
    
    XCTAssertFalse(refresh.enabled)
    XCTAssertFalse(username.enabled)
    XCTAssertFalse(name.enabled)
    XCTAssertFalse(email.enabled)
    XCTAssertFalse(name.enabled)
    XCTAssertFalse(copyUsername.enabled)
    XCTAssertFalse(copyName.enabled)
    XCTAssertFalse(copyEmail.enabled)
    
    waitForElementToEnable(email)
    
    XCTAssertTrue(refresh.enabled)
    XCTAssertTrue(username.enabled)
    XCTAssertTrue(name.enabled)
    XCTAssertTrue(email.enabled)
    XCTAssertTrue(copyUsername.enabled)
    XCTAssertTrue(copyName.enabled)
    XCTAssertTrue(copyEmail.enabled)
    
    XCTAssertFalse((username.value as! String).isEmpty)
    XCTAssertFalse((name.value as! String).isEmpty)
    XCTAssertFalse((email.value as! String).isEmpty)
  }
  
}
