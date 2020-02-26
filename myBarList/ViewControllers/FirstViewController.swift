//
//  ViewController.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/04.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    @IBOutlet weak var freeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            freeButton.isHidden = true
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toSelectionVC" {
//            let nextViewController = segue.destination as! SelectionViewController
//            let user = sender as! User
//            nextViewController.myAccount = AppUser(data: ["userID": user.uid])
//        }
//    }

    
    @IBAction func LoginButtonClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            Auth.auth().currentUser?.reload(completion: { error in
                if error == nil {
                    if Auth.auth().currentUser?.isEmailVerified == true {
                        //メール認証済みの場合、ユーザーの情報を次の画面の変数に渡す。
                        self.performSegue(withIdentifier: "toSelectionVC", sender: Auth.auth().currentUser!)
                    } else {
                        let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        } else {
            // ユーザーがログインしていない場合、Account登録画面に遷移する。
            self.performSegue(withIdentifier: "toAccountVC", sender: nil)
        }
    }
}

