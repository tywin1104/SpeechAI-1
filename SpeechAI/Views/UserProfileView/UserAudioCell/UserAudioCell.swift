//
//  UserAudioCell.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-19.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit
import AVFoundation

class UserAudioCell: UITableViewCell, AVAudioPlayerDelegate {

    @IBOutlet weak var posterBackground: UIView!
    @IBOutlet weak var audioName: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var loadingForInfo: UIActivityIndicatorView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var score: UILabel!
    var player: AVAudioPlayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func stopSound() {
        guard let player = player, player.isPlaying else {
            return

        }
        player.stop()
        playButton.setImage(UIImage(named:"whiteplay"), for: UIControlState.normal)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setImage(UIImage(named:"whiteplay"), for: UIControlState.normal)
    }

    @IBAction func playAudio(_ sender: Any) {
        playButton.setImage(UIImage(named:"whitestop"), for: UIControlState.normal)
        guard let player = player, !player.isPlaying else {
            print("Stoping Sound")
            stopSound()
            return

        }
        
        if (!player.isPlaying){
              player.play()
        }
    }
}
