//
//  User.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation

struct User {
  let id: String
  let name: String
  let speeches: [Speech]
}

extension User {
  func addSpeech(speech: Speech) -> User {
    var totalSpeeches = self.speeches
    totalSpeeches.append(speech)
    return User(id: id, name: name, speeches: totalSpeeches)
  }
}

