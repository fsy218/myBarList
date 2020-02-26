//
//  MyBarListViewController.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/16.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit
import Firebase

class MyBarListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var myAccount: AppUser!
    var database: Firestore!
    var restList: [RestGnavi] = []
    var userID = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restList = []
        database = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        let restRef = database.collection("BarList").document(userID).collection("rest")
        tableView.register(UINib(nibName: "RestCell", bundle: nil), forCellReuseIdentifier: "RestCell")

        restRef.getDocuments() { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let rest = RestGnavi(value: data as Any)
                    self.restList.append(rest)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestCell") as! RestCell
        cell.barNameLabel.text = restList[indexPath.row].name
        var image:UIImage = getImageByUrl(url: restList[indexPath.row].shop_image1)
        cell.barImageView1.image = image
        image = getImageByUrl(url: restList[indexPath.row].shop_image2)
        cell.barImageView2.image = image
        cell.genreLabel.text = restList[indexPath.row].category
        cell.budgetLabel.text = restList[indexPath.row].budget.description
        cell.accessLabel.text = restList[indexPath.row].barAccess
        cell.prLabel.text = restList[indexPath.row].pr_short
        cell.addressLabel.text = restList[indexPath.row].address
        cell.writeButton.tag = indexPath.row
        cell.writeButton.setTitle("リストから削除する", for: .normal)
        cell.writeButton.setTitleColor(UIColor.red, for: .normal)
        cell.idLabel.text = restList[indexPath.row].id
        return cell
    }

    func getImageByUrl(url: String) -> UIImage{
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)!
            } catch let err {
                print("Error : \(err.localizedDescription)")
            }
        }
        return UIImage()
    }
    
    

}
