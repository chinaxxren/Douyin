//
//  DYLabel.swift
//  DouYin
//
//  Created by 赵江明 on 2021/12/23.
//  Copyright © 2021 zhaofucheng. All rights reserved.
//

import Foundation
import UIKit

class DYLabel : UILabel {
    
    // 1.定义一个接受间距的属性
    var padding = UIEdgeInsets.zero

    // 2. 返回 label 重新计算过 text 的 rectangle
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard text != nil else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }

        let insetRect = bounds.inset(by: padding)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -padding.top,
                                          left: -padding.left,
                                          bottom: -padding.bottom,
                                          right: -padding.right)
        return textRect.inset(by: invertedInsets)
    }

    // 3. 绘制文本时，对当前 rectangle 添加间距
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
