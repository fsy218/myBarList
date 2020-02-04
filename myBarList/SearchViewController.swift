//
//  SearchViewController.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/04.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        searchText.placeholder = "キーワードを入力してください"
    }

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var restList : [(id:String, name:String, category:String, url_mobile:String, shop_image1:String, address:String, tel:String, line:String, station:String, walk:String, pr_short:String, areaname:String, prefname:String, areaname_s:String, category_name_l:[String])] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchWord = searchBar.text {
            print(searchWord)
            searchShop(keyword: searchWord)
        }
    }
    
    struct RestJson: Codable {
        let id: String?
        let name: String?
        let category: String?
        let url_mobile: String?
        let image_url: ImageUrl?
        let address: String?
        let tel: String?
        let access: Access?
        let pr: Pr?
        let code: Code?
        
        struct ImageUrl: Codable {
            let shop_image1: String?
        }
        struct Access: Codable {
            let line: String?
            let station: String?
            let walk: String?
        }
        struct Pr: Codable {
            let pr_short: String?
        }
        struct Code: Codable {
            let areaname: String?
            let prefname: String?
            let areaname_s: String?
            let category_name_l: [String]?
        }
    }
    
    struct ResultJson: Codable {
        let rest:[RestJson]?
    }
    
    func searchShop(keyword: String) {
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
                   let decoder = JSONDecoder()
                   let json = try decoder.decode(ResultJson.self, from: data!)
//                   print(json)

                   if let rests = json.rest {
                       self.restList.removeAll()
                       for rest in rests {
                        if let id = rest.id, let name = rest.name, let category = rest.category, let url_mobile = rest.url_mobile, let shop_image1 = rest.image_url?.shop_image1, let adress = rest.address, let tel = rest.tel, let line = rest.access?.line, let station = rest.access?.station, let walk = rest.access?.walk, let pr_short = rest.pr?.pr_short, let areaname = rest.code?.areaname, let prefname = rest.code?.prefname, let areaname_s = rest.code?.areaname_s, let category_name_l = rest.code?.category_name_l  {
                               let shop = (id, name, category, url_mobile, shop_image1, adress, tel, line, station, walk, pr_short, areaname, prefname, areaname_s, category_name_l)
                               self.restList.append(shop)
                           }
                       }

                       self.tableView.reloadData()

                       if let shopdbg = self.restList.first {
                           print("------------")
                           print("restList[0] = \(shopdbg)")
                       }
                   }
               } catch {
                   print("エラーが発生しました")
               }
           })
           task.resume()
    }
    
}
