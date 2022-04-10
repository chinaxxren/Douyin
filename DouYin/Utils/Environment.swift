//
//  Environment.swift
//  DouYin
//
//  Created by 赵江明 on 2022/1/14.
//  Copyright © 2022 zhaofucheng. All rights reserved.
//

import Foundation

var isAppStoreAccount: Bool = false

enum Environment {
    case debug
    case production
    case release
    case overseas
}


extension Environment {
    var url: String {
        return "www.firebullvip.com"
    }
    
    static var current: Environment {
        #if DEBUG
        return .debug
        #elseif PRODUCTION
        return .production
        #elseif RELEASE
        return .release
        #elseif OVERSEA
        return .overseas
        #endif
    }
    
    static var currentUserId: String {
        return ""
    }
    
    /// 融云 APP Key
    var rcKey: String {
        return "pvxdm17jpw7ar"
    }
    
    /// 友盟 Key
    var umengKey: String {
        return ""
    }
    
    /// crash 收集
    var buglyKey: String {
        return ""
    }
    
    /// 如果需要美颜，请再次配置 Key
    static var MHBeautyKey: String {
        return ""
    }
    
    /// 请申请您的 BusinessToken：https://rcrtc-api.rongcloud.net/code
    static var businessToken: String {
        return ""
    }
}
