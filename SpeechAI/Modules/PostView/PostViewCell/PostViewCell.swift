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


    @IBAction func playSound(_ sender: Any) {
        guard let player = player, !player.isPlaying else {
            return
        }
        
        player.play()
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
