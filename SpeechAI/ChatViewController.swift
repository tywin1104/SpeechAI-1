//
//  ChatViewController.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit
import ChameleonFramework



final class ChatViewController: UIViewController {
  static func viewController() -> ChatViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let vc = storyboard.instantiateInitialViewController() as? ChatViewController else { fatalError() }
    return vc
  }

  @IBOutlet weak var welcomeView: UIStackView!
  @IBOutlet weak var tableView: UITableView!

  enum ChatState: Int {
    case intro, record, doneRecording, feedback

//    var numberOfSections: Int {
//      switch self {
//      case .intro:
//        return 1
//      case .record:
//      case .doneRecording:
//      case .feedback:
//      }
//    }
  }

  enum IntroState: Int {
    case greeting, name

    var message: String {
      switch self {
      case .greeting:
        return "Welcome to _____! This is just some filler data on what this app actaully does!"
      case .name:
        return "Before we get started, what is your name?"
      }
    }
  }

  enum PreRecording: Int {
    case options

    var message: String {
      switch self {
      case .options:
        return "To practice public speaking we can a large collection of speeches to use or you can use your own."
      }
    }

    var options: [String] {
      switch self {
      case .options:
        return ["Use yours", "Use my own"]
      }
    }
  }

  enum PostRecording: Int {
    case analyzing, ellipses

    var message: String {
      switch self {
      case .analyzing:
        return "Awesome! I will start analyzing your speech."
      case .ellipses:
        return ""
      }
    }
  }

  enum Feedback: Int {
    case tone

    var message: String {
      switch self {
      case .tone:
        return "You have a very disgusting tone lol."
      }
    }
  }

  var currentState: ChatState = .intro

  override func viewDidLoad() {
    super.viewDidLoad()
//    tableView.dataSource = self
    tableView.separatorStyle = .none

    tableView.isHidden = true
    welcomeView.isHidden = false
    welcomeView.alpha = 0

    self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [#colorLiteral(red: 0.1647058824, green: 0.9607843137, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.6823529412, blue: 0.9176470588, alpha: 1)])
  }

  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 0.8, animations: {
      self.welcomeView.alpha = 1
    }) { _ in
      UIView.animate(withDuration: 0.8, delay: 2.0, animations: {
        self.welcomeView.alpha = 0
        self.welcomeView.center.y -= 20
      }, completion: { _ in
        self.welcomeView.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
      })
    }
  }



}

extension ChatViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    <#code#>
  }
}

