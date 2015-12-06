//
//  UI.swift
//  RUG
//
//  Created by mitsuru on 12/6/15.
//  Copyright © 2015 mna. All rights reserved.
//

import XCTest

struct UI {
  static var window: XCUIElement {
    return XCUIApplication().windows["RUG"]
  }

  struct Button {
    static var refresh: XCUIElement {
      return window.buttons["RefreshButton"]
    }
    static var copyUsername: XCUIElement {
      return window.buttons["CopyUsernameButton"]
    }
    static var copyName: XCUIElement {
      return window.buttons["CopyNameButton"]
    }
    static var copyEmail: XCUIElement {
      return window.buttons["CopyEmailButton"]
    }
    static var savePhoto: XCUIElement {
      return window.buttons["SavePhotoButton"]
    }
  }
  
  struct TextField {
    static var username: XCUIElement {
      return window.textFields["UsernameTextField"]
    }
    static var name: XCUIElement {
      return window.textFields["NameTextField"]
    }
    static var email: XCUIElement {
      return window.textFields["EmailTextField"]
    }
  }

  struct CheckBox {
    static var lego: XCUIElement {
      return window.checkBoxes["LegoButton"]
    }
  }
  
  struct ImageView {
    static var face: XCUIElement {
      return window.images["FaceImageView"]
    }
  }

  struct ProgressIndicator {
    static var face: XCUIElement {
      return window.progressIndicators["FaceProgressIndicator"]
    }
  }
  
}
