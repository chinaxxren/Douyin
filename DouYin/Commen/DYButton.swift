//
//  DYButton.swift
//  DouYin
//
//  Created by 赵江明 on 2021/12/23.
//  Copyright © 2021 zhaofucheng. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class DYButton : UIButton {
    
    func setImageNormalURL(_ urlString: String) {
        let url = URL(string:urlString)
        self.kf.setImage(with: url,for: .normal)
    }
    
    func setImageHighlightedURL(_ urlString: String) {
        let url = URL(string:urlString)
        self.kf.setImage(with: url,for: .highlighted)
    }
}
