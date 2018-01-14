//
//  ChatViewRecordCell.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-14.
//  Copyright © 2018 Speak. All rights reserved.
//

import AVFoundation
import UIKit

protocol ChatViewRecordCellDelegate: class {
  func uploadDidStart()
  func responseReceived()
}

class ChatViewRecordCell: UITableViewCell {

  let dataManager = DataManager.default
  let audioSession = AVAudioSession.sharedInstance()
  var audioRecorder: AVAudioRecorder!
  var audioFileURL: URL?
  var audioFileName: String?

  @IBOutlet var textView: UITextView!
  @IBOutlet var recordButton: UIButton!
  @IBOutlet var shuffleButton: UIButton!

  weak var delegate: ChatViewRecordCellDelegate?

  @IBAction func shuffle() {
    if isShuffle {
      textView.text = speechGenerator()
    }

  }


  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var bubbleView: UIView!


  override func awakeFromNib() {
    super.awakeFromNib()
    bubbleView.layer.cornerRadius = 21
    bubbleView.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
    bubbleView.layer.borderWidth = 0.5
    backgroundColor = UIColor.clear
  }



  @IBAction func record() {

    requestAudioPermission()

    if audioRecorder != nil {
      finishRecording(success: true)
      delegate?.uploadDidStart()
      if let audioURL = audioFileURL,
        let audioName = audioFileName {
        dataManager.uploadAudio(audioURL: audioURL, audioName: audioName, speechText: textView.text ?? "") { result in
          switch result {
          case .success:
            return
          case .failure(let message):
            print(message)
          }

        }
      }
    } else {
      startRecording()
      recordButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
    }
  }

  var isShuffle = true

  func configure(isShuffle: Bool) {
    self.isShuffle = isShuffle
    if isShuffle {
      textView.text = speechGenerator()
    } else {
      textView.text = ""
      shuffleButton.isHidden = true
    }
  }

  func requestAudioPermission() {
    do {
      try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
      try audioSession.setActive(true)
      audioSession.requestRecordPermission() { [unowned self] allowed in

      }
    } catch {
      // failed to set audio category
    }
  }

  func startRecording() {
    let fileName = UUID().uuidString
    audioFileURL = dataManager.getDocumentsDirectory().appendingPathComponent("\(fileName).wav")
    audioFileName = "\(fileName).wav"

    let settings = [
      AVFormatIDKey: Int(kAudioFormatLinearPCM),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    guard let audioURL = audioFileURL else { return }

    do {
      audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
      audioRecorder.delegate = self
      audioRecorder.prepareToRecord()
      audioRecorder.record()

    } catch {
      finishRecording(success: false)
    }
  }

  func finishRecording(success: Bool) {
    audioRecorder.stop()
    audioRecorder = nil
  }


  func speechGenerator() -> String {
    var speeches = ["We have also come to this hallowed spot to remind America of the fierce urgency of Now. This is no time to engage in the luxury of cooling off or to take the tranquilizing drug of gradualism. Now is the time to make real the promises of democracy. Now is the time to rise from the dark and desolate valley of segregation to the sunlit path of racial justice. Now is the time to lift our nation from the quicksands of racial injustice to the solid rock of brotherhood. Now is the time to make justice a reality for all of God's children.",
                    "But there is something that I must say to my people, who stand on the warm threshold which leads into the palace of justice: In the process of gaining our rightful place, we must not be guilty of wrongful deeds. Let us not seek to satisfy our thirst for freedom by drinking from the cup of bitterness and hatred. We must forever conduct our struggle on the high plane of dignity and discipline. We must not allow our creative protest to degenerate into physical violence. Again and again, we must rise to the majestic heights of meeting physical force with soul force.",
                    "The marvelous new militancy which has engulfed the Negro community must not lead us to a distrust of all white people, for many of our white brothers, as evidenced by their presence here today, have come to realize that their destiny is tied up with our destiny. And they have come to realize that their freedom is inextricably bound to our freedom.",
                    "On behalf of the great Empire State and the whole family of New York, let me thank you for the great privilege of being able to address this convention. Please allow me to skip the stories and the poetry and the temptation to deal in nice but vague rhetoric. Let me instead use this valuable opportunity to deal immediately with the questions that should determine this election and that we all know are vital to the American people.",
                    "But the hard truth is that not everyone is sharing in this city's splendor and glory. A shining city is perhaps all the President sees from the portico of the White House and the veranda of his ranch, where everyone seems to be doing well. But there's another city; there's another part to the shining the city; the part where some people can't pay their mortgages, and most young people can't afford one; where students can't afford the education they need, and middle-class parents watch the dreams they hold for their children evaporate.",
                    "On the third of February last I officially laid before you the extraordinary announcement of the Imperial German Government that on and after the first day of February it was its purpose to put aside all restraints of law or of humanity and use its submarines to sink every vessel that sought to approach either the ports of Great Britain and Ireland or the western coasts of Europe or any of the ports controlled by the enemies of Germany within the Mediterranean."]
    let randomIndex = Int(arc4random_uniform(UInt32(speeches.count)))
    return speeches[randomIndex]
  }
}

extension ChatViewRecordCell: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if !flag {
      finishRecording(success: false)
    }
  }
}
