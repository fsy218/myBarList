//
//  BarCell.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/06.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit
import Firebase

class RestCell: UITableViewCell {
    
    @IBOutlet weak var barNameLabel: UILabel!
    @IBOutlet weak var barImageView1: UIImageView!
    @IBOutlet weak var barImageView2: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var imageTextField1: UITextField!
    @IBOutlet weak var imageTextField2: UITextField!

    let vc = UIApplication.topViewController()
    let restRef = Firestore.firestore().collection("BarList").document(Auth.auth().currentUser!.uid).collection("rest")

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addressLabel.isHidden = true
        self.urlTextField.isHidden = true
        self.idLabel.isHidden = true
        self.imageTextField1.isHidden = true
        self.imageTextField2.isHidden = true
    }
    
    @IBAction func writeButtonClicked(_ sender: UIButton) {
        if vc?.restorationIdentifier == "searchVC" {
            addAction()
        } else if vc?.restorationIdentifier == "myBarListVC" {
            deleteAction()
        }
    }
    
    func addAction() {
        let alert = UIAlertController(title: "確認", message: "リストに追加しますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.addList()
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        self.vc?.present(alert, animated: true, completion: nil)
    }
    
    func deleteAction() {
        let alert = UIAlertController(title: "確認", message: "リストから削除しますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteList()
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        self.vc?.present(alert, animated: true, completion: nil)
    }
    
    func addList() {
        let id = idLabel.text!
        let name = barNameLabel.text!
        let shop_image1 = imageTextField1.text!
        let shop_image2 = imageTextField2.text!
        let category = genreLabel.text!
        let url_mobile = urlTextField.text!
        let budget = budgetLabel.text!
        let access = accessLabel.text!
        let pr_short = prLabel.text!
        let address = addressLabel.text!
        
        let saveDocument = restRef.document()
            saveDocument.setData([
                "documentID": saveDocument.documentID,
                "id": id,
                "name": name,
                "shop_image1": shop_image1,
                "shop_image2": shop_image2,
                "category": category,
                "url_mobile": url_mobile,
                "budget": Int(budget)!,
                "barAccess": access,
                "pr_short": pr_short,
                "address": address
            ], merge: true) { (error) in
                if error == nil {
                    self.vc!.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func deleteList() {
        restRef.whereField("id", isEqualTo: idLabel.text!).getDocuments() { (querySnapshot, error) in
           if let error = error {
               print("Error removing document: \(error)")
           } else {
                for document in querySnapshot!.documents {
                    self.restRef.document(document.documentID).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            self.vc!.loadView()
                            self.vc!.viewDidLoad()
                        }
                    }
                }
           }
        }
    }

}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController) -> UIViewController? {
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}

