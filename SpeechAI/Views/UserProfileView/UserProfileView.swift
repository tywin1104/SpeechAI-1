//
//  UserProfileView.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-19.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit
import ChameleonFramework

class UserProfileView: UIView, UITableViewDelegate, UITableViewDataSource {

    class func instanceFromNib(frame: CGRect) -> UserProfileView {
        let view = UINib(nibName: "UserProfileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UserProfileView
        view.frame = frame
        view.tableview.delegate = view
        view.tableview.dataSource = view
        view.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: view.frame, andColors: [#colorLiteral(red: 0.1647058824, green: 0.9607843137, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.6823529412, blue: 0.9176470588, alpha: 1)])

        return view
    }

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableview: UITableView!

    
    @IBAction func goBack(_ sender: Any) {
    }


    @IBAction func logout(_ sender: Any) {
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 28
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib_name = UINib(nibName: "useraudiocell", bundle:nil)
        tableView.register(nib_name, forCellReuseIdentifier: "useraudiocell")
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "useraudiocell", for: indexPath) as! UserAudioCell
        
        return cell
    }
}
