//
//  UserProfileViewController.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-19.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    var container: UserProfileView?
    let dataManager = DataManager.default
    override func viewDidLoad() {
        super.viewDidLoad()

        addContainerToViewController()

        dataManager.fetchUserAudios(with: User.currentUser.id!) { (result) in
            switch result {
            case .success(let audios):
                self.container?.listOfAudios = audios
                self.container?.tableview.reloadData()
                self.container?.loadingIndicator.isHidden = true
                return
            case .failure(let message):
                print(message)
                return
            }
        }


        addContainerToViewController()
        // Do any additional setup after loading the view.
    }

    private func addContainerToViewController() {
        container = UserProfileView.instanceFromNib(frame: CGRect(x:0,y:0,  width:view.bounds.width, height:view.bounds.height))

        if let userName = User.currentUser.name  {
            container?.userName.text = userName
        }
        container?.delegate = self
        self.view.addSubview(container!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension UserProfileViewController: UserProfileViewDelegate {
    func goBackToChatView() {
        self.navigationController?.popViewController(animated: true)
    }

    func logout() {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "initial", sender: self)
    }
}
