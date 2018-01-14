//
//  PostView.swift
//  SpeechAI
//
//  Created by James Park on 2018-01-14.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit
import AVFoundation
import ChameleonFramework

class PostView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!

    var listOfPosts = [Post]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib_name = UINib(nibName: "PostViewCell", bundle:nil)
        tableView.register(nib_name, forCellReuseIdentifier: "PostViewCell")
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
        cell.postBackground.layer.cornerRadius = 10.0
        cell.posterName.text = listOfPosts[indexPath.row].userName
        cell.speechID = listOfPosts[indexPath.row].speechID
        cell.numOfLikes.text = String(listOfPosts[indexPath.row].numOfLikes)
        let url = URL.init(string: listOfPosts[indexPath.row].audioURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let err = error {
                print("\(err)")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    cell.player = try AVAudioPlayer(data: data!)
                } catch let error {
                    print(error.localizedDescription)
                }
            }

            }.resume()

        return cell
    }


    class func instanceFromNib(frame: CGRect) -> PostView {
        let view = UINib(nibName: "PostView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PostView
        view.frame = frame
        view.tableview.delegate = view
        view.tableview.dataSource = view
        view.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: view.frame, andColors: [#colorLiteral(red: 0.1647058824, green: 0.9607843137, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.6823529412, blue: 0.9176470588, alpha: 1)])
        
        return view
    }



}
