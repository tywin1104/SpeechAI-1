//
//  UserParser.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation


internal struct UserParser {
  func parse(_ json: (key: String, value: JSON)) -> User? {
    guard let name = json.value["name"] as? String else {
        return nil
    }

    if let reviewJSON = json.value["reviews"] as? JSON {
      let speeches = SpeechesParser().parse(reviewJSON)

      return User(id: json.key,
                  name: name,
                  speeches: speeches)
    } else {
      return User(id: json.key,
                  name: name,
                  speeches: [])
    }
  }
}
