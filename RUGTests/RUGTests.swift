//
//  RUGTests.swift
//  RUGTests
//
//  Created by m-nakada on 11/12/2014.
//  Copyright (c) 2014 mna. All rights reserved.
//

import Cocoa
import Himotoki
import XCTest

class RUGTests: XCTestCase {
  
  lazy var userJSON: [String: AnyObject] = {
    let name: [String: AnyObject] = [
      "title": "miss",
      "first": "aino",
      "last": "pulkkinen"
    ]
    
    let location: [String: AnyObject] = [
      "street": "2789 mechelininkatu",
      "city": "sastamala",
      "state": "lapland",
      "zip": 37274
    ]
    
    let picture: [String: AnyObject] = [
      "large": "https://randomuser.me/api/portraits/women/12.jpg",
      "medium": "https://randomuser.me/api/portraits/med/women/12.jpg",
      "thumbnail": "https://randomuser.me/api/portraits/thumb/women/12.jpg"
    ]
    
    let user: [String: AnyObject] = [
      "gender": "female",
      "name": name,
      "location": location,
      "email": "aino.pulkkinen@example.com",
      "username": "organicbird335",
      "password": "mortgage",
      "salt": "DrCnPyut",
      "md5": "08c5dbc43733e97063b301e6b35500a1",
      "sha1": "24d2ef1d3edbe56f1f52658139bd245d9b4c6cc9",
      "sha256": "2c2cefb1ab6505a5f1c357589e86656d3589a493dc68ccd05aa4e0d422cfbe28",
      "registered": 1141121176,
      "dob": 636229167,
      "phone": "08-347-116",
      "cell": "048-291-60-32",
      "HETU": "280290A9728",
      "picture": picture
    ]
    
    let result: [String: AnyObject] = [
      "user": user
    ]
    
    let JSON: [String: AnyObject] = [
      "results" : [result],
      "nationality": "FI",
      "seed": "12ca86b84a7aa05302",
      "version": "0.7"
    ]
    
    return JSON
  }()
  
  func testUser() {
    let JSON = userJSON
    
    do {
      let rug: RUG = try decode(JSON)
      XCTAssertTrue(rug.results.count == 1)
      
      guard let result = rug.results.first else {
        XCTFail("Invalid user.")
        return
      }
      
      let user = result.user
      XCTAssertTrue(user.name.first == "aino")
      XCTAssertTrue(user.name.last  == "pulkkinen")
      XCTAssertTrue(user.email      == "aino.pulkkinen@example.com")
      XCTAssertTrue(user.username   == "aino-pulkkinen")
      
      let picture = user.picture
      XCTAssertTrue(picture.large     == "https://randomuser.me/api/portraits/women/12.jpg")
      XCTAssertTrue(picture.medium    == "https://randomuser.me/api/portraits/med/women/12.jpg")
      XCTAssertTrue(picture.thumbnail == "https://randomuser.me/api/portraits/thumb/women/12.jpg")
      
    } catch let DecodeError.MissingKeyPath(keyPath) {
      XCTFail("Missing key path: \(keyPath)")
    } catch {
      XCTFail("Unknown decode error")
    }
  }
  
}
