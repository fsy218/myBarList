//
//  SearchViewController.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/04.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit
import SafariServices
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    var myAccount: AppUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        searchText.placeholder = "キーワードを入力してください"
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let prefdata = try? getJSONData() else { return }
        guard let prefList = try? JSONDecoder().decode([PrefCodeGnavi].self, from: prefdata) else { return }
        print(prefList[0])

    }

    func getJSONData() throws -> Data? {
        guard let path = Bundle.main.path(forResource: "PrefCodeGnavi", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
    
    
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var restList: [RestGnavi] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchWord = searchBar.text {
            print(searchWord)
            searchRestaurant(keyword: searchWord)
        }
    }
    
    func searchRestaurant(keyword: String) {
    
       guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
           return
       }
       guard let req_url = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=6bf4be830455182560cb7ad8ba817c16&freeword=\(keyword_encode)&hit_per_page=10") else {
           return
       }
       print(req_url)
        
       let req = URLRequest(url: req_url)
       let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
       let task = session.dataTask(with: req, completionHandler: {
           (data, response, error) in
           session.finishTasksAndInvalidate()
           do {
            let json = try? JSONDecoder().decode(ResultJson.self, from: data!)
            

            
            if let restaurants = json?.rest {
                self.restList.removeAll()
                for rest in restaurants {
                    self.restList.append(rest)
                }
                if let restdbg = self.restList.first {
                    print("------------")
                    print("okashiList[0] = \(restdbg)")
                }
                

                
//                    var config = Realm.Configuration()
//                    config.deleteRealmIfMigrationNeeded = true
//                    let realm = try! Realm(configuration: config)
//                    print(Realm.Configuration.defaultConfiguration.fileURL!)
//
//                    try! realm.write {
//                        let restFirst = RestGnavi(value: self.restList[0])
//                        realm.add(restFirst)
//                    }
            
                self.tableView.reloadData()
                
                if let restdbg = self.restList.first {
                   print("------------")
                   print("restList[0] = \(restdbg)")
                }
            }
           } catch {
               print("エラーが発生しました")
           }
       })
       task.resume()
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restList.count
    }

    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestCell") as! RestCell
        cell.barNameLabel.text = restList[indexPath.row].name
        let image:UIImage = getImageByUrl(url: restList[indexPath.row].shop_image1)
        cell.barImageView.image = image
        cell.genreLabel.text = restList[indexPath.row].category
        cell.budgetLabel.text = "平均予算 \(restList[indexPath.row].budget.description)円"
        cell.accessLabel.text = "\(restList[indexPath.row].line)\(restList[indexPath.row].station) 徒歩\(restList[indexPath.row].walk)分"
        cell.prLabel.text = restList[indexPath.row].pr_short
        cell.addressLabel.text = restList[indexPath.row].address
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let link = URL(string: restList[indexPath.row].url_mobile)!
        let safariViewController = SFSafariViewController(url: link)
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}

