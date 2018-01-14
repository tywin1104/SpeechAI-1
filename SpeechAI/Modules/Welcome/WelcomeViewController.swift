//
//  WelcomeViewController.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

  static func viewController() -> WelcomeViewController {
    let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
    guard let vc = storyboard.instantiateInitialViewController() as? WelcomeViewController else { fatalError() }
    return vc
  }

  @IBOutlet weak var textField: UITextField!

  let dataManager = DataManager.default

  override func viewDidLoad() {
    super.viewDidLoad()

  }
}

extension WelcomeViewController {
  @IBAction func submitPressed() {
    guard let name = textField.text else { return }
    dataManager.createUser(name: name)
    let recordVC = RecordSpeechViewController.viewController()
    present(recordVC, animated: true, completion: nil)
  }
}
