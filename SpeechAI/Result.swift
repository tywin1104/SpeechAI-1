//
//  Result.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation

public enum Result<T> {
  case success(T)
  case failure(message: String)
}
