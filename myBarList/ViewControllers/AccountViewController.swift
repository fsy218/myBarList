//
//  AccountViewController.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/15.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "example@mail.com"
        passwordTextField.placeholder = "6文字以上の半角英数字を入力してください"
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let nextViewController = segue.destination as! SelectionViewController
//        let user = sender as! User
//        nextViewController.myAccount = AppUser(data: ["userID": user.uid])
//    }
    
    @IBAction func registerAccount(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil, let result = result {
                result.user.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        let alert = UIAlertController(title: "仮登録を行いました", message: "入力したメールアドレス宛に確認メールを送信しました。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.performSegue(withIdentifier: "toHome1", sender: Auth.auth().currentUser!)
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
