//
//  DataManager.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation
import Alamofire

internal typealias JSON = [String: Any]
internal typealias JSONArray = [JSON]

internal final class DataManager {
  static var `default` = DataManager()
  var currentUser: User?
  var feedback = Feedback()


  fileprivate let firebaseManager: FirebaseManager
  fileprivate let defaults = UserDefaults.standard

  init(firebaseManager: FirebaseManager = FirebaseManager()) {
    self.firebaseManager = firebaseManager
  }
}

extension DataManager {
  func fetchCurrentUser() {
    guard let userID = retrieveUserDefaults(key: "userID") else { return }
    self.firebaseManager.fetchUser(with: userID) { result in
      switch result {
      case .success(let user):
        self.currentUser = user
        return
      case .failure(let message):
        print(message)
        return
      }
    }
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }

  func uploadAudio(audioURL: URL, audioName: String, speechText: String, completion: @escaping ((Result<Void>) -> Void)) {
    firebaseManager.uploadAudio(audioURL: audioURL, audioName: audioName) { result in
      switch result {
      case .success(let url):
        let speech = Speech(id: UUID().uuidString, urlString: url, text: speechText)
        guard let newUser = self.currentUser?.addSpeech(speech: speech) else {
          completion(.failure(message: "No current user"))
          return
        }
        self.currentUser = newUser
        self.firebaseManager.saveSpeechURL(user: newUser, speech: speech)
        self.updateToNetwork(userId: newUser.id, speechId: speech.id, completion: { (result) in
          switch result {
          case .success:
            completion(.success(()))
            return
          case .failure(let message):
            print(message)
          }
        })

      case .failure(let message):
        print(message)
      }
    }
  }

  func updateToNetwork(userId: String, speechId: String, completion: @escaping ((Result<Void>) -> Void)) {
    let requestString = "https://thawing-waters-31085.herokuapp.com/api"

    let params =  ["userId": userId, "speechId": speechId ] as Parameters


    Alamofire.request(requestString, method: .get, parameters: params, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in

      guard let status = response.response?.statusCode else {
        completion(.failure(message: ("unable to get status code")))
        return
      }

      if status != 200   {
        completion(.failure(message: ("Staus: \(status)")))
      }

      guard let result = response.result.value, let json = result as? NSDictionary else {

        completion(.failure(message: ("failed to get the response")))
        return
      }

      if let wpm = json["wpm"] as? Double {
        self.feedback.wpm = wpm
      }

      if let pausing = json["pausing"] as? String {
        self.feedback.pausing = pausing
      }

      if  let similarity = json["similarity"] as? Double {
        self.feedback.similarity = similarity
      }

      if let loudness = json["loudness"]  as? String {
        self.feedback.loudness = loudness
      }

      if let score = json["score"] as? Double {
        self.feedback.score = score
      }

      if let pastData = json["wpm"] as? [String:AnyObject] {

        if let wpm = pastData["wpm"] as? Bool {
          self.feedback.pastData.wpm = wpm
        }

        if let pausing = pastData["pausing"] as? Bool {
          self.feedback.pastData.pausing = pausing
        }

        if  let similarity = pastData["similarity"] as? Bool {
          self.feedback.pastData.similarity = similarity
        }

        if let loudness = pastData["loudness"]  as? Bool {
          self.feedback.pastData.loudness = loudness
        }
      }

      self.displayFeedackMessage()

      completion(.success(()))
    }
  }





  func displayFeedackMessage() {

    let StartingSent = "Here are your results!"
    var WPMSent = ""
    var SimSent = ""
    var LoudSent = ""
    var  PausSent = ""
    var overallSent = ""
    var positiveWords = ["Great", "Fantastic", "Superb", "Awesome", "Marvelous"]
    var negativeWords = ["difficult", "hard", "not easy"]

    if (feedback.wpm < 120) {
      WPMSent = "Your Words Per Minute (WPM) was \(feedback.wpm). I would suggest talking faster and increasing your pace!"
    } else if (feedback.wpm > 180) {
      WPMSent = "Your Words Per Minute (WPM) was \(feedback.wpm). I would suggest talking slower in your speech."
    }

    if (feedback.similarity) > 0.85 {
      let randomIndex = Int(arc4random_uniform(UInt32(positiveWords.count)))
      SimSent = "I was able to understand \(feedback.similarity*100)% of the words you spoke. You were extremely clear. \(positiveWords[randomIndex]) job!"
    } else {
      SimSent = "It seems that you were either talking too fast or slurring words. I was only able to understand \(feedback.similarity*100)%. I would suggest talking slower and focusing on pronunciation."
    }

    if (feedback.loudness == "loud") {
      let randomIndex = Int(arc4random_uniform(UInt32(positiveWords.count)))
      LoudSent = "\(positiveWords[randomIndex]) volume! You had a strong voice that carried across the room."
    } else {
      let randomIndex = Int(arc4random_uniform(UInt32(negativeWords.count)))
      LoudSent = "Hmmm. I noticed that you spoke quietly. It was \(negativeWords[randomIndex]) for me to hear you. Try speaking louder next time!"
    }

    if (feedback.pausing) == "good" {
      let randomIndex = Int(arc4random_uniform(UInt32(positiveWords.count)))
      PausSent = "\(positiveWords[randomIndex]) job with your pausing! The breaks in your speech made your speech quite effective."
    } else if feedback.pausing == "fast" {
      PausSent = "One last thing, you spoke too fast in your speech. There was a noticeable lack of pauses that could've made your speech a lot more effective"
    } else {
      PausSent = "In your speech, there were too many pauses! You need to talk a bit faster and convey more information in the time given to better engage your audience."
    }

    overallSent = "Overall, the final score I give your speech is \(feedback.score). Good job! "

    if feedback.pastData.wpm == true {
      overallSent.append("You increased your WPM from your last speech! ")
    } else if feedback.pastData.loudness == true {
      overallSent.append("You spoke louder than your last speech! ")
    }

    if feedback.pastData.pausing == true {
      overallSent.append("You had more pauses from your last speech.")
    } else if feedback.pastData.similarity == true {
      overallSent.append("You enunciated more clearly from your last speech.")
    }

    return [StartingSent, WPMSent, SimSent, LoudSent, PausSent, overallSent]

  }

  func createUser(name: String) {
    let user = User(id: UUID().uuidString, name: name, speeches: [])
    currentUser = user
    firebaseManager.createUser(user: user)
    saveUserDefaults(key: "userID", text: user.id)
  }

  func isNewUser() -> Bool {
    return retrieveUserDefaults(key: "userID") == nil
  }

  private func saveUserDefaults(key: String, text: String) {
    defaults.set(text, forKey: key)
  }

  private func retrieveUserDefaults(key: String) -> String? {
    return defaults.string(forKey: key)
  }
}
