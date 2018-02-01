//
//  SignUpViewController.swift
//  SpeechAI
//
//  Created by Avinash Jain on 1/16/18.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class SignUpViewController: UIViewController {
    
    static func viewController() -> SignUpViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? SignUpViewController else { fatalError() }
        return vc
    }
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [#colorLiteral(red: 0.1647058824, green: 0.9607843137, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.6823529412, blue: 0.9176470588, alpha: 1)])
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            
            User.currentUser.setUpUser()
            self.performSegue(withIdentifier: "signup", sender: nil)
            
        } else {
            print("user is NOT signed in")
            // ...
        }
        
    }
    
    @IBAction func signUpUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil {
                User.currentUser.setUID()
                let ref : DatabaseReference! = Database.database().reference()
                ref.child("users").child(user!.uid).updateChildValues(["name": self.firstNameField.text!])
                ref.child("users").child(user!.uid).child("lastData").setValue(
                    [
                        "wpm" : "pass",
                        "pausing" : "pass",
                        "similarity": "pass",
                        "loudness": "pass"

                    ]
                )
                self.performSegue(withIdentifier: "signup", sender: self)
            }
        }
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
