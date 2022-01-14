//
//  DYImageView.swift
//  DouYin
//
//  Created by 赵江明 on 2021/12/23.
//  Copyright © 2021 zhaofucheng. All rights reserved.
//


import UIKit
import Kingfisher

class DYImageView: UIImageView {
    func setImageURL(_ urlString: String) {
        let url = URL(string:urlString)
        self.kf.setImage(with: url)
    }
}
