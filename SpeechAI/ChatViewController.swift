//
//  ChatViewController.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase



final class ChatViewController: UIViewController {
  static func viewController() -> ChatViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let vc = storyboard.instantiateInitialViewController() as? ChatViewController else { fatalError() }
    return vc

  }


  @IBOutlet weak var communityButton: UIButton!
  @IBOutlet weak var welcomeView: UIStackView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var avatarTopImage: UIImageView!
  @IBOutlet weak var viewProfileButton: UIButton!
    
  let dataManager = DataManager.default

  enum ChatState: Int {
    case empty, intro, record, doneRecording, feedback
  }

  enum IntroState: Int {
    case greeting, name

    var message: String {
      switch self {
      case .greeting:
        return "I'm Talky and my mission is to make you a better public speaker!"
      case .name:
        return "Before we get started, what is your name?"
      }
    }

    var identifier: String {
      switch self {
      case .greeting:
        return "ChatTextTableCell"
      case .name:
        return "ChatInputTableCell"
      }
    }

    static var totalCells: Int = 2
  }

  enum PreRecordingState: Int {
    case options, speechInput

    func message(name: String) -> String {
      switch self {
      case .options:
        return "Hi \(name), let's get started! Do you want me to give you a speech or do you want to enter your own?"
      case .speechInput:
        return "Tap the record button when you're ready to make your speech!"
      }

    }

    var options: [String] {
      switch self {
      case .options:
        return ["Give me", "Enter my own"]
      default:
        return []
      }
    }

    var identifier: String {
      switch self {
      case .options:
        return "ChatOptionsTableCell"
      case .speechInput:
        return "ChatViewRecordCell"
      }
    }

    static var totalCells: Int = 2
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

    var identifier: String {
      switch self {
      case .analyzing:
        return "ChatTextTableCell"
      case .ellipses:
        return "EllipsesTableCell"
      }
    }

    static var totalCells: Int = 2
  }

  enum FeedbackState: Int {
    case starting, wpm, accuracy, volume, pauses, overall, again

    var identifier: String {
      switch self {
      case .again:
        return "ChatOptionsTableCell"
      default:
        return "ChatTextTableCell"
      }
    }

    var options: [String] {
      switch self {
      case .again:
        return ["Yes", "No"]
      default:
        return []
      }
    }

    static var totalCells: Int = 7
  }

  var currentState: ChatState = .empty
  var currentRow: Int = 0

  var feedback: Feedback?

  var selectedRecordingOption: Int?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.isNavigationBarHidden = true 
    tableView.dataSource = self
    tableView.separatorStyle = .none

    tableView.isHidden = true
    welcomeView.isHidden = false
    welcomeView.alpha = 0
    avatarTopImage.alpha = 0
    communityButton.alpha = 0
    viewProfileButton.alpha = 0
    
    User.currentUser.setUpUser()

    self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)

    self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [#colorLiteral(red: 0.1647058824, green: 0.9607843137, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.6823529412, blue: 0.9176470588, alpha: 1)])

    UIView.animate(withDuration: 0.8, animations: {
        self.welcomeView.alpha = 1
    }) { completed in
        UIView.animate(withDuration: 0.8, delay: 2.0, animations: {
            self.welcomeView.alpha = 0
            self.welcomeView.center.y -= 20
            self.avatarTopImage.alpha = 1
            self.communityButton.alpha = 1
            self.viewProfileButton.alpha = 1
        }, completion: { _ in
            self.welcomeView.isHidden = true
            self.tableView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.advance()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.advance()
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
      if self.currentRow == 0 {
        self.currentRow = 1
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: PreRecordingState.speechInput.rawValue, section: ChatState.record.rawValue)], with: .bottom)
        self.tableView.endUpdates()
      } else {
        self.currentState = .doneRecording
        self.currentRow = 0
        self.tableView.beginUpdates()
        self.tableView.insertSections(IndexSet(integer: ChatState.doneRecording.rawValue), with: .bottom)
        self.tableView.insertRows(at: [IndexPath.init(row: PostRecordingState.analyzing.rawValue, section: ChatState.doneRecording.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      }
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
        self.tableView.insertRows(at: [IndexPath.init(row: FeedbackState.starting.rawValue, section: ChatState.feedback.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      }
    case .feedback:
      if self.currentRow == 0 {
        self.currentRow = 1
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: FeedbackState.wpm.rawValue, section: ChatState.feedback.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      } else if self.currentRow == 1 {
        self.currentRow = 2
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: FeedbackState.accuracy.rawValue, section: ChatState.feedback.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      } else if self.currentRow == 2 {
        self.currentRow = 3
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: FeedbackState.volume.rawValue, section: ChatState.feedback.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      } else if self.currentRow == 3 {
        self.currentRow = 4
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: FeedbackState.pauses.rawValue, section: ChatState.feedback.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      } else if self.currentRow == 4 {
        self.currentRow = 5
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: FeedbackState.overall.rawValue, section: ChatState.feedback.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      } else if self.currentRow == 5 {
        self.currentRow = 6
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: FeedbackState.again.rawValue, section: ChatState.feedback.rawValue)], with: .automatic)
        self.tableView.endUpdates()
      } else if self.currentRow == 6 {

      }
    case .empty:
      self.currentState = .intro
      self.currentRow = 0
      self.tableView.beginUpdates()
      self.tableView.insertSections(IndexSet(integer: ChatState.intro.rawValue), with: .bottom)
      self.tableView.insertRows(at: [IndexPath.init(row: IntroState.greeting.rawValue, section: ChatState.intro.rawValue)], with: .automatic)
      self.tableView.endUpdates()
    }

    DispatchQueue.main.async {
      let indexPath = IndexPath(row: self.currentRow, section: self.currentState.rawValue)
      self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: introState.identifier) as? ChatInputTableCell else { fatalError() }
        cell.configure(text: introState.message)
        cell.delegate = self
        return cell
      }
    case .record:
      guard let preRecordingState: PreRecordingState = PreRecordingState(rawValue: indexPath.row) else { fatalError() }
      switch preRecordingState {
      case .options:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: preRecordingState.identifier) as? ChatOptionsTableCell,
          let currentUserName = dataManager.currentUser?.name else { fatalError() }

        cell.configure(text: preRecordingState.message(name: currentUserName), options: preRecordingState.options)
        cell.delegate = self
        return cell
      case .speechInput:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: preRecordingState.identifier) as? ChatViewRecordCell,
          let selectedOption = self.selectedRecordingOption
          else { fatalError() }
        cell.configure(isShuffle: selectedOption == 0)
        cell.delegate = self
        return cell
      }

    case .doneRecording:
      guard let postRecordingState: PostRecordingState = PostRecordingState(rawValue: indexPath.row) else { fatalError() }
      switch postRecordingState {
      case .analyzing:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postRecordingState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: postRecordingState.message)
        return cell
      case .ellipses:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postRecordingState.identifier) as? EllipsesTableCell else { fatalError() }
        return cell
      }
      
    case .feedback:
      guard let feedbackState: FeedbackState = FeedbackState(rawValue: indexPath.row),
        let speechFeedback = feedback else { fatalError() }
      switch feedbackState {
      case .starting:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: speechFeedback.StartingSent)
        return cell
      case .wpm:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: speechFeedback.WPMSent)
        return cell
      case .accuracy:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: speechFeedback.SimSent)
        return cell
      case .volume:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: speechFeedback.LoudSent)
        return cell
      case .pauses:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: speechFeedback.PausSent)
        return cell
      case .overall:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackState.identifier) as? ChatTextTableCell else { fatalError() }
        cell.configure(text: speechFeedback.overallSent)
        return cell
      case .again:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: feedbackState.identifier) as? ChatOptionsTableCell else { fatalError() }
        cell.configure(text: "Would you like to record another speech?", options: feedbackState.options)
        return cell

      }
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return currentState.rawValue + 1
  }
}

extension ChatViewController: ChatInputTableCellDelegate {
  func didPressSubmit(name: String) {
    dataManager.createUser(name: name)
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
      self.advance()
    })
  }
}

extension ChatViewController: ChatOptionsTableCellDelegate {
  func optionPressed(optionNumber: Int) {
    if currentState == .feedback {
      if optionNumber == 0 {
        currentState = .intro
        currentRow = 1
        tableView.reloadData()
        self.advance()
      } else {

      }
    } else {
      selectedRecordingOption = optionNumber

      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        self.advance()
      })
    }
  }
}


extension ChatViewController: ChatViewRecordCellDelegate {
  func uploadDidStart() {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
      self.advance()
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        self.advance()
      })
    })
  }

  func responseReceived(feedback: Feedback) {
    self.feedback = feedback
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
      self.advance()
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
        self.advance()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
          self.advance()
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.advance()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
              self.advance()
              DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.advance()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                  self.advance()
                })
              })
            })
          })
        })
      })
    })
  }
}
