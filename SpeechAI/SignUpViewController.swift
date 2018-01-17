//
//  SignUpViewController.swift
//  SpeechAI
//
//  Created by Avinash Jain on 1/16/18.
//  Copyright © 2018 Speak. All rights reserved.
//

import UIKit
import ChameleonFramework

class SignUpViewController: UIViewController {
    
    static func viewController() -> SignUpViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? SignUpViewController else { fatalError() }
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: [#colorLiteral(red: 0.1647058824, green: 0.9607843137, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.6823529412, blue: 0.9176470588, alpha: 1)])
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
