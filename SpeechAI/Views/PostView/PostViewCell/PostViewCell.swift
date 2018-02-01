//
//  PostViewCell.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-14.
//  Copyright © 2018 Speak. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class PostViewCell: UITableViewCell {

    @IBOutlet weak var postBackground: UIView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var posterName: UILabel!
    var player: AVAudioPlayer?
    var speechID = "" {
        didSet {
            let fmanager = FirebaseManager()

            fmanager.observeChangedLikes(from: self.speechID) { (result) in
                switch result {
                case .success(let likes):
                      DispatchQueue.main.async {
                        self.numOfLikes.text = String(likes)
                      }
                    return
                case .failure(let message):
                    print(message)
                    return
                }
            }
        }
    }

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var numOfLikes: UILabel!

    @IBAction func playSound(_ sender: Any) {
        playButton.setImage(UIImage(named:"whitestop"), for: UIControlState.normal)
        guard let player = player, !player.isPlaying else {
            print("Hello")
            stopSound()
            return
            
        }
        if (player.isPlaying){
            
        } else {
        player.play()
        }
}

    @IBAction func like(_ sender: Any) {
        
        likeButton.setBackgroundImage(UIImage(named:"likefill"), for: UIControlState.normal)
            likeButton.isEnabled = false
        let firebaseManager = FirebaseManager()
        firebaseManager.addALike(to: speechID) { (result) in
            switch result {
            case .success(let num):
                DispatchQueue.main.async {
                    self.numOfLikes.text = String(num)
                }
                break
            default:
                return
            }
        }
    }

    func stopSound() {
        guard let player = player, player.isPlaying else {
            return

        }
        player.stop()
        playButton.setImage(UIImage(named:"whiteplay"), for: UIControlState.normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()


        // Initialization code
        
    }
}
