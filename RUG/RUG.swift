//
//  RUG.swift
//  RUG
//
//  Created by mitsuru on 12/6/15.
//  Copyright © 2015 mna. All rights reserved.
//

import Foundation
import Himotoki

struct RUG: Decodable {
  let results: [Result]
  
  static func decode(e: Extractor) throws -> RUG {
    return try RUG (
      results: e <|| "results"
    )
  }
}

struct Result: Decodable {
  let user: User
  
  static func decode(e: Extractor) throws -> Result {
    return try Result (
      user: e <| "user"
    )
  }
}

struct User: Decodable {
  let name: Name
  let email: String
  let picture: Picture
  
  var displayName: String {
    return name.first.capitalizedString + " " + name.last.capitalizedString
  }
  
  var username: String {
    return name.first + "-" + name.last
  }
  
  static func decode(e: Extractor) throws -> User {
    return try User (
      name:     e <| "name",
      email:    e <| "email",
      picture:  e <| "picture"
    )
  }
}

struct Name: Decodable {
  let first: String
  let last: String
  
  static func decode(e: Extractor) throws -> Name {
    return try Name (
      first: e <| "first",
      last:  e <| "last"
    )
  }
}

struct Picture: Decodable {
  let large: String
  let medium: String
  let thumbnail: String
  
  static func decode(e: Extractor) throws -> Picture {
    return try Picture (
      large:     e <| "large",
      medium:    e <| "medium",
      thumbnail: e <| "thumbnail"
    )
  }
}
