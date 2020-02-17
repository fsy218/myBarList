//
//  WithdrawViewController.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/15.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit
import Firebase

class WithdrawViewController: UIViewController {

    @IBOutlet weak var currentUserEmail: UITextField!
    @IBOutlet weak var currentUserPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = Auth.auth().currentUser
        currentUserEmail.text = user?.email
        currentUserPassword.placeholder = "6文字以上の半角英数字を入力してください"
    }
    
    @IBAction func WithdrawButtonClicked(_ sender: Any) {
        let user = Auth.auth().currentUser
        let email = currentUserEmail.text!
        let password = currentUserPassword.text!
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        user?.reauthenticate(with: credential) { (result, error) in
            if error == nil {
                accountDelete()
            } else {
                print("エラー：\(String(describing: error?.localizedDescription))")
            }
        }
       
        func accountDelete() {
            Auth.auth().currentUser?.delete { (error) in
                // エラーが無ければ、ログイン画面へ戻る
                if error == nil {
                    let alert = UIAlertController(title: "ユーザーを削除しました", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.performSegue(withIdentifier: "toHome2", sender: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("エラー：\(String(describing: error?.localizedDescription))")
                }
            }
        }
        
    }
}
