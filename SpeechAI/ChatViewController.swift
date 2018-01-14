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
  @IBOutlet weak var avatarTopImage: UIImageView!

  enum ChatState: Int {
    case empty, intro, record, doneRecording, feedback
  }

  enum IntroState: Int {
    case greeting, name

    var message: String {
      switch self {
      case .greeting:
        return "Welcome to SpeechAI! This is just some filler data on what this app actaully does!"
      case .name:
        return "Before we get started, what is your name?"
      }
    }

    var identifier: String {
      switch self {
      case .greeting:
        return "ChatTextTableCell"
      case .name:
        return "ChatTextTableCell"
      }
    }

    static var totalCells: Int = 2
  }

  enum PreRecordingState: Int {
    case options, speechInput, recording

    var message: String {
      switch self {
      case .options:
        return "To practice public speaking we can a large collection of speeches to use or you can use your own."
      case .speechInput:
        return "Hit next when you've selected your speech"
      case .recording:
        return "Record when you're ready!"
      }
        
    }

    var options: [String] {
      switch self {
      case .options:
        return ["Use yours", "Use my own"]
      default:
        return []
      }
    
    }

    static var totalCells: Int = 3
  }

  enum PostRecordingState: Int {
    case analyzing, ellipses

    var message: String {
      switch self {
      case .analyzing:
        return "Awesome! I will start analyzing your speech."
      case .ellipses:
        return ""
      }
    }

    static var totalCells: Int = 2
  }

  enum FeedbackState: Int {
    case tone

    var message: String {
      switch self {
      case .tone:
        return "You have a very disgusting tone lol."
      }
    }

    static var totalCells: Int = 1
  }

  var currentState: ChatState = .empty
  var currentRow: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.separatorStyle = .none

    tableView.isHidden = true
    welcomeView.isHidden = false
    welcomeView.alpha = 0
    avatarTopImage.alpha = 0

    self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [#colorLiteral(red: 0.1647058824, green: 0.9607843137, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.6823529412, blue: 0.9176470588, alpha: 1)])
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIView.animate(withDuration: 0.8, animations: {
      self.welcomeView.alpha = 1
    }) { completed in
      UIView.animate(withDuration: 0.8, delay: 2.0, animations: {
        self.welcomeView.alpha = 0
        self.welcomeView.center.y -= 20
        self.avatarTopImage.alpha = 1
      }, completion: { _ in
        self.welcomeView.isHidden = true
        self.tableView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
          self.advance()
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.advance()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
              self.advance()
            })
          })
        })
      })
    }
  }

  func advance() {
      switch self.currentState {
      case .intro:
        if self.currentRow == 0 {
          self.currentRow = 1
          self.tableView.beginUpdates()
          self.tableView.insertRows(at: [IndexPath.init(row: IntroState.name.rawValue, section: ChatState.intro.rawValue)], with: .bottom)
          self.tableView.endUpdates()
        } else if self.currentRow == 1 {
          self.currentState = .record
          self.currentRow = 0
          self.tableView.beginUpdates()
          self.tableView.insertSections(IndexSet(integer: ChatState.record.rawValue), with: .bottom)
          self.tableView.insertRows(at: [IndexPath.init(row: PreRecordingState.options.rawValue, section: ChatState.record.rawValue)], with: .bottom)
          self.tableView.endUpdates()
        }
      case .record:
        self.currentState = .doneRecording
        self.currentRow = 0
        self.tableView.beginUpdates()
        self.tableView.insertSections(IndexSet(integer: ChatState.doneRecording.rawValue), with: .bottom)
        self.tableView.insertRows(at: [IndexPath.init(row: PostRecordingState.analyzing.rawValue, section: ChatState.doneRecording.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      case .doneRecording:
        if self.currentRow == 0 {
          self.currentRow = 1
          self.tableView.beginUpdates()
          self.tableView.insertRows(at: [IndexPath.init(row: PostRecordingState.ellipses.rawValue, section: ChatState.doneRecording.rawValue)], with: .automatic)
          self.tableView.endUpdates()
        } else if self.currentRow == 1 {
          self.currentState = .feedback
          self.currentRow = 0
          self.tableView.beginUpdates()
          self.tableView.insertSections(IndexSet(integer: ChatState.feedback.rawValue), with: .bottom)
          self.tableView.insertRows(at: [IndexPath.init(row: FeedbackState.tone.rawValue, section: ChatState.feedback.rawValue)], with: .automatic)
          self.tableView.endUpdates()
        }
      case .feedback:
        return
      case .empty:
        self.currentState = .intro
        self.currentRow = 0
        self.tableView.beginUpdates()
        self.tableView.insertSections(IndexSet(integer: ChatState.intro.rawValue), with: .bottom)
        self.tableView.insertRows(at: [IndexPath.init(row: IntroState.greeting.rawValue, section: ChatState.intro.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      }
  }

}

extension ChatViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let chatState = ChatState(rawValue: section) else { fatalError() }
    switch chatState {
    case .intro:
      return chatState == currentState ? currentRow + 1 : IntroState.totalCells
    case .record:
      return chatState == currentState ? currentRow + 1 : PreRecordingState.totalCells
    case .doneRecording:
      return chatState == currentState ? currentRow + 1 : PostRecordingState.totalCells
    case .feedback:
      return chatState == currentState ? currentRow + 1 : FeedbackState.totalCells
    case .empty:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let chatState = ChatState(rawValue: indexPath.section) else { fatalError() }
    switch chatState {
    case .empty:
      fatalError()
    case .intro:
      guard let introState: IntroState = IntroState(rawValue: indexPath.row) else { fatalError() }
      switch introState {
      case .greeting:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: introState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: introState.message)
        return cell
      case .name:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: introState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: introState.message)
        return cell
      }
    case .record:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: IntroState.greeting.identifier) as? ChatTextTableCell else { fatalError() }
//      switch PreRecordingState {
//      case .options:
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: , for: <#T##IndexPath#>)
//      }
      cell.configure(text: IntroState.greeting.message)
      return cell

    case .doneRecording:
      return UITableViewCell()
    case .feedback:
      return UITableViewCell()
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return currentState.rawValue + 1
  }
}
