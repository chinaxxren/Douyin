//
//  DebugModule.swift
//  DouYin
//
//  Created by 赵江明 on 2022/1/14.
//  Copyright © 2022 zhaofucheng. All rights reserved.
//

import UIKit
import SwiftyBeaver

public let log = SwiftyBeaver.self

class DebugModule: NSObject, Module {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // SwiftBeaver 添加输出到 console
        let console = ConsoleDestination()
        log.addDestination(console)

        log.info("Log Print")
        
        return true
    }
}
