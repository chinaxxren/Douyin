//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import Foundation
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize

public protocol Number {
    var value: CGFloat { get }
}

extension CGFloat: Number {
    public var value: CGFloat {
        return self
    }
}

extension Double: Number {
    public var value: CGFloat {
        return CGFloat(self)
    }
}

extension Int: Number {
    public var value: CGFloat {
        return CGFloat(self)
    }
}

public protocol SizeNumber {
    var value: CGSize { get }
}

extension CGSize: SizeNumber {
    public var value: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}