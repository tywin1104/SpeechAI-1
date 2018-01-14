
//
//  ChatOptionsTableCell.swift
//  SpeechAI
//
//  Created by Milton Leung on 2018-01-14.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit

protocol ChatOptionsTableCellDelegate: class {
  func optionPressed(optionNumber: Int)
}

class ChatOptionsTableCell: UITableViewCell {

  @IBOutlet weak var optionsLabel: UILabel!
  @IBOutlet weak var option1Button: UIButton!
  @IBOutlet weak var option2Button: UIButton!

  @IBAction func buttonOnePress() {
    delegate?.optionPressed(optionNumber: 0)
  }
  @IBAction func buttonTwoPress() {
    delegate?.optionPressed(optionNumber: 1)
  }
  @IBOutlet weak var bubbleView: UIView!

  weak var delegate: ChatOptionsTableCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()
    bubbleView.layer.cornerRadius = 21
    bubbleView.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
    bubbleView.layer.borderWidth = 0.5
    backgroundColor = UIColor.clear
    option1Button.layer.borderColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    option2Button.layer.borderColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    option1Button.layer.borderWidth = 1
    option2Button.layer.borderWidth = 1
    option1Button.layer.cornerRadius = 17
    option2Button.layer.cornerRadius = 17
  }

  func configure(text: String, options: [String]) {
    optionsLabel.text = text
    option1Button.setTitle(options[0], for: .normal)
    option2Button.setTitle(options[1], for: .normal)
  }
}
