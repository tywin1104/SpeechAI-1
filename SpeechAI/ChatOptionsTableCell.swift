
//
//  ChatOptionsTableCell.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-14.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit

class ChatOptionsTableCell: UITableViewCell {

    @IBOutlet weak var optionsLabel: UILabel!
    
    @IBAction func buttonOnePress(_ sender: Any) {
    }
    
    @IBOutlet weak var buttonTwoPress: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
