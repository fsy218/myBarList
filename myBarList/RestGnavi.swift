//
//  RestGnavi.swift
//  myBarList
//
//  Created by 山岡峻輔 on 2020/02/07.
//  Copyright © 2020 山岡峻輔. All rights reserved.
//

import Foundation
import RealmSwift

class RestGnavi: Object, Codable {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var url_mobile: String = ""
    @objc dynamic var shop_image1: String = ""
    @objc dynamic var shop_image2: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var tel: String = ""
    @objc dynamic var line: String = ""
    @objc dynamic var station: String = ""
    @objc dynamic var walk: String = ""
    @objc dynamic var pr_short: String = ""
    @objc dynamic var pr_long: String = ""
    @objc dynamic var areaname: String = ""
    @objc dynamic var prefname: String = ""
    @objc dynamic var areaname_s: String = ""
    var category_name_l = List<StringObject>()
    @objc dynamic var budget: Int = 0
    @objc dynamic var barAccess: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case url_mobile
        case image_url
        case address
        case tel
        case access
        case pr
        case code
        case budget
    }
    
    private enum ImageUrlKeys: String, CodingKey {
        case shop_image1
        case shop_image2
    }
    private enum AccessKeys: String, CodingKey {
        case line
        case station
        case walk
    }
    private enum PrKeys: String, CodingKey {
        case pr_short
        case pr_long
    }
    private enum CodeKeys: String, CodingKey {
        case areaname
        case prefname
        case areaname_s
        case category_name_l
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        url_mobile = try container.decode(String.self, forKey: .url_mobile)
        address = try container.decode(String.self, forKey: .address)
        tel = try container.decode(String.self, forKey: .tel)
        budget = try container.decode(Int.self, forKey: .budget)
        
        let image_url = try container.nestedContainer(keyedBy: ImageUrlKeys.self, forKey: .image_url)
        shop_image1 = try image_url.decode(String.self, forKey: .shop_image1)
        shop_image2 = try image_url.decode(String.self, forKey: .shop_image2)
        
        let access = try container.nestedContainer(keyedBy: AccessKeys.self, forKey: .access)
        line = try access.decode(String.self, forKey: .line)
        station = try access.decode(String.self, forKey: .station)
        walk = try access.decode(String.self, forKey: .walk)
        
        let pr = try container.nestedContainer(keyedBy: PrKeys.self, forKey: .pr)
        pr_short = try pr.decode(String.self, forKey: .pr_short)
        pr_long = try pr.decode(String.self, forKey: .pr_long)
        
        let code = try container.nestedContainer(keyedBy: CodeKeys.self, forKey: .code)
        areaname = try code.decode(String.self, forKey: .areaname)
        prefname = try code.decode(String.self, forKey: .prefname)
        areaname_s = try code.decode(String.self, forKey: .areaname_s)
        let categoryNameArray = try code.decode([String].self, forKey: .category_name_l)
        category_name_l = categoryNameArray.reduce(List<StringObject>()) {$0.append(StringObject(value: $1)); return $0}
    }
    
    func encode(to encoder: Encoder) throws {
        var container =  encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(url_mobile, forKey: .url_mobile)
        try container.encode(address, forKey: .address)
        try container.encode(tel, forKey: .tel)
        try container.encode(budget, forKey: .budget)
        
        var image_url = container.nestedContainer(keyedBy: ImageUrlKeys.self, forKey: .image_url)
        try image_url.encode(shop_image1, forKey: .shop_image1)
        try image_url.encode(shop_image2, forKey: .shop_image2)
        
        var access = container.nestedContainer(keyedBy: AccessKeys.self, forKey: .access)
        try access.encode(line, forKey: .line)
        try access.encode(station, forKey: .station)
        try access.encode(walk, forKey: .walk)
        
        var pr = container.nestedContainer(keyedBy: PrKeys.self, forKey: .pr)
        try pr.encode(pr_short, forKey: .pr_short)
        try pr.encode(pr_long, forKey: .pr_long)
        
        var code = container.nestedContainer(keyedBy: CodeKeys.self, forKey: .code)
        try code.encode(areaname, forKey: .areaname)
        try code.encode(prefname, forKey: .prefname)
        try code.encode(areaname_s, forKey: .areaname_s)
        try code.encode(category_name_l, forKey: .category_name_l)
    }
    
}

class ResultJson: Codable {
    let rest: [RestGnavi]?
}

class StringObject: Object, Codable{
    @objc dynamic var value: String = ""
    convenience init(value: String) {
        self.init()
        self.value = value
    }
}


