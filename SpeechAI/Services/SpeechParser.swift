//
//  SpeechParser.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation

internal struct SpeechParser {
  func parse(_ json: (key: String, value: JSON)) -> Speech? {

    guard
      let urlString = json.value["urlString"] as? String,
      let textString = json.value["text"] as? String
      else {
        return nil
    }

    return Speech(id: json.key,
                  urlString: urlString,
                  text: textString)
  }
}

internal struct SpeechesParser {
  func parse(_ json: JSON) -> [Speech] {
    let speechParser = SpeechParser()
    return json
      .flatMap { $0 as? (key: String, value: JSON) }
      .flatMap { speechParser.parse($0) }
  }
}
