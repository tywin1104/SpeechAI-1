//
//  EllipsesTableCell.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-14.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit

class EllipsesTableCell: UITableViewCell {

  @IBOutlet weak var bubbleView: UIView!

  weak var delegate: ChatInputTableCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    bubbleView.layer.cornerRadius = 21
    bubbleView.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
    bubbleView.layer.borderWidth = 0.5
    backgroundColor = UIColor.clear
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
