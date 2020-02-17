//
//  AppUser.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/15.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import Foundation

struct AppUser {
    let userID: String
//    let userName: String
    
    init(data: [String: Any]) {
        userID = data["userID"] as! String
//        userName = data["userName"] as! String
    }
}
