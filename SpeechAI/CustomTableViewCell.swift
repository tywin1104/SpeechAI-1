//
//  CustomTableViewCell.swift
//  SpeechAI
//
//  Created by Tianyi Zhang on 2018-01-14.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
