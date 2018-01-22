//
//  FirebaseManager.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation
import Firebase

internal class FirebaseManager {
  let storageRef: StorageReference

  init() {
    storageRef = Storage.storage().reference()
  }

  var ref: DatabaseReference! = Database.database().reference()

  func uploadAudio(audioURL: URL, audioName: String, completion: @escaping ((Result<String>) -> Void)) {

    let audioRef = storageRef.child("speeches/\(audioName)")

    let uploadTask = audioRef.putFile(from: audioURL, metadata: nil) { metadata, error in
      if let error = error {
        print(error)
      }
    }

    uploadTask.observe(.success) { snapshot in

      if let url = snapshot.metadata?.downloadURL()?.absoluteString {
        completion(.success(url))
      }
    }

    uploadTask.observe(.failure) { snapshot in
        completion(.failure(message: "Upload to Firebase failed"))
    }
  }

  func saveSpeechURL(user: User, speech: Speech) {
    self.ref.child("users/\(user.id!)/speeches").child(speech.id).setValue(
      [
        "url": speech.urlString,
        "text": speech.text
      ]
    )

    self.ref.child("posts").child(speech.id).setValue(
    [
        "user": user.name!,
        "url": speech.urlString,
        "text": speech.text,
        "likes": 0
    ]
    )
    
  }


    func addALike(to speechId:String, completion: @escaping ((Result<Int>) -> Void) ) {
        self.ref.child("posts").child(speechId).child("likes").runTransactionBlock( { (currentData) -> TransactionResult in
            guard let value = currentData.value as? Double else {
                return TransactionResult.success(withValue: currentData)
            }

            guard value >= 0.0 else {
                return TransactionResult.success(withValue: currentData)
            }

            currentData.value = value + 1
            let retnVale = currentData.value as! Int
            completion(.success(( retnVale)))
            return TransactionResult.success(withValue: currentData)
        })
    }


    private func addInitialPastData(userID: String) {
        self.ref.child("users").child(userID).child("lastData").setValue(
            [
                "wpm" : "pass",
                "pausing" : "pass",
                "similarity": "pass",
                "loudness": "pass"

        ]
        )

    }

    func observeChangedLikes (from speedID:String, completion: @escaping ((Result<Int>) -> Void)) {
        self.ref.child("posts").child(speedID).child("likes").observe(DataEventType.value) { (snapshot) in
            guard let likes = snapshot.value as? Int else {
                completion(.failure(message: "sdfadsf"))
                return
            }

             completion(.success(likes))

        }

    }

    func retrievePosts (completion: @escaping ((Result<Post>) -> Void)) {
        self.ref.child("posts").observe(DataEventType.childAdded) { snapshot in

            guard
                let dicData = snapshot.value as? NSDictionary,
                let userName = dicData["user"] as? String,
                let audioURL = dicData["url"] as? String,
                let likes = dicData["likes"] as? Int else {

                completion(.failure(message: "Unable to get post"))
                return
            }


            let post = Post()

            post.speechID = snapshot.key
            post.audioURL = audioURL
            post.userName = userName
            post.numOfLikes = likes

            completion(.success(post))
        }
    }


    func fetchUserAudios(with userID: String, completion: @escaping ((Result<[RecordedAudio]>) -> Void)) {
        self.ref.child("users").child(userID).child("speeches").observeSingleEvent(of: .value) { snapshot in

            guard snapshot.exists() else {
                 completion(.success([RecordedAudio]()))
                return
            }
            guard let json = snapshot.value as? JSON else {
                completion(.failure(message: "Parsing error"))
                return
            }


            var listOfRecordedAudio = [RecordedAudio]()
            for (_, value) in json {

                guard
                    let subJson = value as? JSON,
                    let audioURL = subJson["url"] as? String,
                    let audioData = subJson["data"] as? JSON,
                    let score = audioData["score"] as? Double else {
                    continue 
                }

                var tmpRecordedAudio = RecordedAudio()

                tmpRecordedAudio.audioFile = audioURL
                tmpRecordedAudio.score = round(score*100)

                listOfRecordedAudio.append(tmpRecordedAudio)
            }

            completion(.success(listOfRecordedAudio))

        }

    }

  func fetchUser(with userID: String, completion: @escaping ((Result<User>) -> Void)) {
    self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
      if let value = snapshot.value as? JSON {
        let userParser = UserParser()
        if let user: User = userParser.parse((key: snapshot.key, value: value)) {
          completion(.success(user))
        } else {
          completion(.failure(message: "Parsing error"))
        }
      }
    }) { (error) in
      print(error.localizedDescription)
    }
  }

  func createUser(user: User) {
    self.ref.child("users").child(user.id!).setValue(["name": user.name])
    addInitialPastData(userID: user.id!)
  }
}
