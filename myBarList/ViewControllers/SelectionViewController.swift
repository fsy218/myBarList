//
//  TimelineViewController.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/15.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit
import Firebase

class SelectionViewController: UIViewController {

    var myAccount: AppUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func BarSearchButtonClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toSearchVC", sender: Auth.auth().currentUser!)
        }
    }
    
    @IBAction func MyBarListButtonClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toMyBarListVC", sender: Auth.auth().currentUser!)
        } else {
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "AccountViewController")
            self.navigationController?.pushViewController(nextView, animated: true)
        }
    }
}



