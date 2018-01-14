//
//  ChatTextTableCell.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-14.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit

final class ChatTextTableCell: UITableViewCell {
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var bubbleView: UIView!

  override func awakeFromNib() {
    super.awakeFromNib()
    bubbleView.layer.cornerRadius = 21
    bubbleView.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
    bubbleView.layer.borderWidth = 0.5
    backgroundColor = UIColor.clear
  }

  func configure(text: String) {
    messageLabel.text = text
  }
}
