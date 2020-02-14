//
//  PrefCodeGnavi.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/13.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import Foundation
import RealmSwift

class PrefCodeGnavi: Object, Decodable {
    @objc dynamic var pref_code: String = ""
    @objc dynamic var pref_name: String = ""
    @objc dynamic var area_code: String = ""
}
