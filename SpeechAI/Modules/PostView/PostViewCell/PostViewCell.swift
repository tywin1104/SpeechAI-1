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


    @IBOutlet weak var posterName: UILabel!
    var player: AVAudioPlayer?


    var speechID = ""

    @IBOutlet weak var numOfLikes: UILabel!

    @IBAction func playSound(_ sender: Any) {
        guard let player = player, !player.isPlaying else {
            return
        }
        
        player.play()
    }

    @IBAction func like(_ sender: Any) {
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

    @IBAction func stopSound(_ sender: Any) {
        guard let player = player, player.isPlaying else {
            return

        }
        player.stop()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
