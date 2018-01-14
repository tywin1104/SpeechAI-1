//
//  FeedsViewController.swift
//  
//
//  Created by Tianyi Zhang on 2018-01-14.
//

import UIKit
import AVFoundation

class FeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()

    @IBAction func playAudio(_ sender: Any) {
        let path = Bundle.main.path(forResource: "example.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error!!!")
        }
        
    }
    @IBAction func commentPressed(_ sender: Any) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" ) as! CustomTableViewCell
        cell.textLabel?.text = posts[indexPath.row].userName
        
        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let fmanager = FirebaseManager()
        
        fmanager.retrievePosts { (result) in
            switch result {
            case .success(let post):
                self.posts.append(post)
                self.tableView.reloadData()
                return
            case .failure(let message):
                print(message)
                return
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
