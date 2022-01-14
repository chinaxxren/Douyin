//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import UIKit

public struct VVZoom {

    /// 设置转换闭包
    ///
    /// - Parameter conversion: 转换闭包
    public static func set(conversion: @escaping (Double) -> Double) {
        conversionClosure = conversion
    }

    /// 转换 用于数值的等比例计算 如需自定义可重新设置
    public static var conversionClosure: (Double) -> Double = { (origin) in
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return origin
        }

        let base = 375.0
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let width = min(screenWidth, screenHeight)
        let result = origin * (width / base)
        let scale = Double(UIScreen.main.scale)
        return (result * scale).rounded(.up) / scale
    }
}

public extension VVZoom {

    static func conversion(_ value: Double) -> Double {
        return conversionClosure(value)
    }
}
