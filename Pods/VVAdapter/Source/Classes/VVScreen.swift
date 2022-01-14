//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import Foundation
import UIKit

// https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
public struct VVScreen {

    public static var size: CGSize {
        UIScreen.main.bounds.size
    }
    public static var nativeSize: CGSize {
        UIScreen.main.nativeBounds.size
    }
    public static var scale: CGFloat {
        UIScreen.main.scale
    }
    public static var nativeScale: CGFloat {
        UIScreen.main.nativeScale
    }
}

public extension VVScreen {

    static var isZoomedMode: Bool {
        UIScreen.main.scale != UIScreen.main.nativeScale
    }

    enum Width: CGFloat {
        case unknown = -1
        case w320 = 320
        case w375 = 375
        case w390 = 390
        case w414 = 414
        case w428 = 428

        public static var current: Width {
            return Width(rawValue: nativeSize.width / scale) ?? .unknown
        }
    }

    enum Height: CGFloat {
        case unknown = -1
        case h480 = 480
        case h568 = 568
        case h667 = 667
        case h736 = 736
        case h812 = 812
        case h844 = 844
        case h896 = 896
        case h926 = 926

        public static var current: Height {
            return Height(rawValue: nativeSize.height / scale) ?? .unknown
        }
    }

    enum Inch: Double {
        case unknown = -1
        case i35 = 3.5
        case i40 = 4.0
        case i47 = 4.7
        case i54 = 5.4
        case i55 = 5.5
        case i58 = 5.8
        case i61 = 6.1
        case i65 = 6.5
        case i67 = 6.7

        public static var current: Inch {
            switch (nativeSize.width / scale, nativeSize.height / scale, scale) {
            case (320, 480, 2):
                return .i35

            case (320, 568, 2):
                return .i40

            case (375, 667, 2):
                return .i47

            case (375, 812, 3) where UIDevice.iPhoneMini:
                return .i54

            case (414, 736, 3):
                return .i55

            case (375, 812, 3):
                return .i58

            case (414, 896, 2), (390, 844, 3):
                return .i61

            case (414, 896, 3):
                return .i65

            case (428, 926, 3):
                return .i67

            default:
                return .unknown
            }
        }
    }

    enum Level: Int {
        case unknown = -1
        /// 3: 2
        case compact
        /// 16: 9
        case regular
        /// 19.5: 9
        case full

        public static var current: Level {
            switch (nativeSize.width / scale, nativeSize.height / scale) {
            case (320, 480):
                return .compact

            case (320, 568), (375, 667), (414, 736):
                return .regular

            case (375, 812), (414, 896), (390, 844), (428, 926):
                return .full

            default:
                return .unknown
            }
        }
    }
}

extension VVScreen {

    public static var isCompact: Bool {
        return Level.current == .compact
    }

    public static var isRegular: Bool {
        return Level.current == .regular
    }

    public static var isFull: Bool {
        return Level.current == .full
    }
}

fileprivate extension UIDevice {

    static var iPhoneMini: Bool {
        switch identifier {
        case "iPhone13,1", "iPhone14,4":
            return true

        case "i386", "x86_64", "arm64":
            return ["iPhone13,1", "iPhone14,4"].contains(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "")

        default:
            return false
        }
    }

    private static let identifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)

        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
}
