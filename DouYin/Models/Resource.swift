//
//  Avatar.swift
//  DonYin
//
//  Created by chinaxxren 2019/5/27.
//  Copyright © 2019 WaQu. All rights reserved.
//

import Foundation

struct Resource: Codable {
    var uri: String
    var urlList: [String]
    var width: Int?
    var height: Int?

    enum CodingKeys: String, CodingKey {
        case uri
        case urlList = "url_list"
        case width
        case height
    }
}
