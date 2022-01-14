//
//  Video.swift
//  DonYin
//
//  Created by chinaxxren 2019/5/27.
//  Copyright © 2019 WaQu. All rights reserved.
//

import Foundation

struct Video: Codable {
    var playAddr: Resource
    var cover: Resource
    var height: Int?
    var width: Int?
    var dynamicCover: Resource
    var originCover: Resource
    var ratio: String
    var downloadAddr: Resource
    var hasWatermark: Bool
    var playAddrLowbr: Resource
    var duration: Int?

    enum CodingKeys: String, CodingKey {
        case playAddr = "play_addr"
        case cover
        case height
        case width
        case dynamicCover = "dynamic_cover"
        case originCover = "origin_cover"
        case ratio
        case downloadAddr = "download_addr"
        case hasWatermark = "has_watermark"
        case playAddrLowbr = "play_addr_lowbr"
        case duration
    }
}
