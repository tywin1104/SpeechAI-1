//
//  RecordSpeechViewController.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-13.
//  Copyright © 2018 Speak. All rights reserved.
//




import UIKit
import AVFoundation

class RecordTableViewCell: UITableViewCell {
    
    let dataManager = DataManager.default
    let audioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    var audioFileURL: URL?
    var audioFileName: String?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var labelText: UILabel!
    @IBAction func beginRecording(_ sender: Any) {
        requestAudioPermission()
        
        if audioRecorder != nil {
            finishRecording(success: true)
            if let audioURL = audioFileURL,
                let audioName = audioFileName {
                dataManager.uploadAudio(audioURL: audioURL, audioName: audioName, speechText: "") { result in
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
            recordButton.setBackgroundImage(UIImage(named: "stop.png"), for: UIControlState.normal)
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
}


extension RecordTableViewCell: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if !flag {
      finishRecording(success: false)
    }
  }
}
