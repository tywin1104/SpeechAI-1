//
//  UserAudioCell.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-19.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit

class UserAudioCell: UITableViewCell {


    @IBOutlet weak var audioName: UILabel!

    @IBOutlet weak var playStopButton: UIButton!

    @IBOutlet weak var numOfLikes: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
