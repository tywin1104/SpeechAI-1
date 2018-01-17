//
//  User.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation
import Firebase

class User {
    var id: String?
    var name: String?
    var speeches = [Speech]()
    
    static var currentUser = User()
    let ref : DatabaseReference = Database.database().reference()
    private init() {
    }
    
    init(id: String, name: String, speeches: [Speech]) {
        
    }
    
    func addSpeech(speech: Speech) -> User {
        self.speeches.append(speech)
        return User(id: id!, name: name!, speeches: self.speeches)
    }
    
    func setUID() {
        self.id = (Auth.auth().currentUser?.uid)!
    }
    
    func setUpUser() {
        id = Auth.auth().currentUser?.uid
        ref.child("users").child(id!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.name = value?["name"] as? String
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}


