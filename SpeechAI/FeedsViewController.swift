//
//  FeedsViewController.swift
//  
//
//  Created by Tianyi Zhang on 2018-01-14.
//

import UIKit
import AVFoundation

class FeedsViewController: UIViewController{
    var container: PostView?


    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContainerToViewController()
        let fmanager = FirebaseManager()
        fmanager.retrievePosts { (result) in
            switch result {
            case .success(let post):
                self.container?.listOfPosts.append(post)
                self.container?.tableview.reloadData()
                return
            case .failure(let message):
                print(message)
                return
            }
        }

        // Do any additional setup after loading the view.
    }

    func addContainerToViewController() {
        container = PostView.instanceFromNib(frame: CGRect(x:0,y:0,  width:view.bounds.width, height:view.bounds.height))
        self.view.addSubview(container!)
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
