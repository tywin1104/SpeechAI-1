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
    self.ref.child("users/\(user.id)/speeches").child(speech.id).setValue(
      [
        "url": speech.urlString,
        "text": speech.text
      ]
    )

    self.ref.child("posts").child(speech.id).setValue(
    [
        "user": user.name,
        "url": speech.urlString,
        "text": speech.text,
        "likes": 0
    ]
    )
    
  }


    func retrievePosts (completion: @escaping ((Result<[Post]>) -> Void)) {
        self.ref.child("posts").observe(DataEventType.childAdded) { snapshot in

            guard let dicData = snapshot.value as? NSDictionary else {
                completion(.failure(message: "sdfadsf"))
                return
            }

            var newPosts = [Post]()
            for (_, value) in dicData  {
                var post = Post()

                guard let subDicData = value as? NSDictionary else {
                    continue
                }

                guard let userName = subDicData["user"] as? String  else {
                    continue
                }

                guard let audioURL = subDicData["url"] as? String else {
                    continue
                }

                guard let likes = subDicData["likes"] as? Int else {
                    continue
                }


                post.audioURL = audioURL
                post.userName = userName
                post.numOfLikes = likes

                newPosts.append(post)
            }
            completion(.success(newPosts))
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
    self.ref.child("users").child(user.id).setValue(["name": user.name])
  }
}
