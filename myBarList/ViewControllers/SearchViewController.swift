//
//  SearchViewController.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/04.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.placeholder = "フリーワード(例:居酒屋 東京)"
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let prefdata = try? getJSONData() else { return }
        guard let prefList = try? JSONDecoder().decode([PrefCodeGnavi].self, from: prefdata) else { return }
        print(prefList[0])
        
        tableView.register(UINib(nibName: "RestCell", bundle: nil), forCellReuseIdentifier: "RestCell")

    }

    func getJSONData() throws -> Data? {
        guard let path = Bundle.main.path(forResource: "PrefCodeGnavi", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var restList: [RestGnavi] = []
    var myAccount: AppUser!
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
        if let searchWord = searchText.text{
            if numberText.text == "" {
                numberText.text = "10"
            }
            let displayNumber = numberText.text!
            searchRestaurant(keyword: searchWord, number: displayNumber)
        }
    }
    
    func searchRestaurant(keyword: String, number: String) {
    
       guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
           return
       }
       guard let req_url = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=6bf4be830455182560cb7ad8ba817c16&freeword=\(keyword_encode)&hit_per_page=\(number)") else {
           return
       }
       print(req_url)
        
       let req = URLRequest(url: req_url)
       let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
       let task = session.dataTask(with: req, completionHandler: {
           (data, response, error) in
           session.finishTasksAndInvalidate()
           do {
            let json = try JSONDecoder().decode(ResultJson.self, from: data!)
            
            if let restaurants = json.rest {
                self.restList.removeAll()
                for rest in restaurants {
                    self.restList.append(rest)
                }
                if let restdbg = self.restList.first {
                    print("------------")
                    print("okashiList[0] = \(restdbg)")
                }
                self.tableView.reloadData()
            }
           } catch {
               print("\(error)が発生しました")
           }
       })
       task.resume()
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restList.count
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestCell") as! RestCell
        cell.barNameLabel.text = restList[indexPath.row].name
        var image:UIImage = getImageByUrl(url: restList[indexPath.row].shop_image1)
        cell.barImageView1.image = image
        image = getImageByUrl(url: restList[indexPath.row].shop_image2)
        cell.barImageView2.image = image
        cell.genreLabel.text = restList[indexPath.row].category
        cell.budgetLabel.text = restList[indexPath.row].budget.description
        cell.accessLabel.text = "\(restList[indexPath.row].line)\(restList[indexPath.row].station) 徒歩\(restList[indexPath.row].walk)分"
        cell.prLabel.text = restList[indexPath.row].pr_short
        cell.addressLabel.text = restList[indexPath.row].address
        cell.writeButton.tag = indexPath.row
        cell.writeButton.setTitle("リストに追加する", for: .normal)
        cell.urlTextField.text = restList[indexPath.row].url_mobile
        cell.idLabel.text = restList[indexPath.row].id
        cell.imageTextField1.text = restList[indexPath.row].shop_image1
        cell.imageTextField2.text = restList[indexPath.row].shop_image2
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

