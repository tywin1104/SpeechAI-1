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
        let speech = Speech(id: UUID().uuidString, urlString: url, text: "HELLO MY NAMES IS JAMES")
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

            completion(.success(()))
        }
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
