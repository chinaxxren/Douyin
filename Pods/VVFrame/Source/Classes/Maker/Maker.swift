//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import Foundation
import UIKit

public enum Size {
    case width
    case height
}

enum HandlerPriority: Int {
    case high
    case middle
    case low
}

/// Used for choosing which side should be used for frame configuration from UIEdgeInsets.

public struct Sides: OptionSet {
    public let rawValue: Int

    public static let top: Sides = .init(rawValue: 1 << 0)
    public static let bottom: Sides = .init(rawValue: 1 << 1)
    public static let left: Sides = .init(rawValue: 1 << 2)
    public static let right: Sides = .init(rawValue: 1 << 3)

    public static let vertical: Sides = [.top, .bottom]
    public static let horizontal: Sides = [.left, .right]

    public static let all: Sides = [.vertical, .horizontal]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public class Maker {

    typealias HandlerType = () -> Void

    var element: ElementType

    var handlers = ContiguousArray<(priority: HandlerPriority, handler: HandlerType)>()
    var newRect: CGRect

    var widthParameter: ValueParameter?
    var widthToParameter: SideParameter?

    var heightParameter: ValueParameter?
    var heightToParameter: SideParameter?

    var leftParameter: SideParameter?
    var topParameter: SideParameter?
    var bottomParameter: SideParameter?
    var rightParameter: SideParameter?

    public func SafeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    public static func initializeKeyboardTracking(with window: UIWindow? = nil) {
        guard let window = window ?? UIApplication.shared.windows.first else {
            assertionFailure("No window to attach to.")
            return
        }

        KeyboardRectCloneView.shared.use(window)
    }

    init(element: ElementType) {
        self.element = element
        self.newRect = element.frame
    }

    // MARK: Additions

    ///    Optional semantic property for improvements readability.
    ///
    /// - returns: `Maker` instance for chaining relations.

    public var and: Self {
        return self
    }

    /// Creates сontainer relation.
    ///
    /// Use this method when you want to set `width` and `height` by wrapping all subviews.
    ///
    /// - note: First, you should configure all subviews and then call this method for `container view`.
    /// - note: Also important to understand, that it's not correct to call 'left' and 'right' relations together by subview, because
    ///         `container` sets width relatively width of subview and here is some ambiguous.
    ///
    /// - warning: Please make note that there is a more flexible container method:
    ///
    ///  ```
    ///  let container = [view1, view2].container(in: view) {}
    ///  ```
    ///
    /// - returns: `Maker` instance for chaining relations.

    @available(*, deprecated, message: "there is a more flexible container method - сheck the method description.")
    @discardableResult public func container() -> Self {
        return _container()
    }

    @discardableResult func _container() -> Self {
        var frame = CGRect.zero

        var minX: CGFloat = 0
        var minY: CGFloat = 0

        for subelement in element.subelements {
            if subelement.frame.origin.x < 0 {
                subelement.frame.origin.x = 0
            }

            if subelement.frame.origin.y < 0 {
                subelement.frame.origin.y = 0
            }

            if subelement.frame.origin.x < minX {
                minX = subelement.frame.origin.x
            }
            if subelement.frame.origin.y < minY {
                minY = subelement.frame.origin.y
            }
        }

        for subelement in element.subelements {
            subelement.frame.origin.x -= minX
            subelement.frame.origin.y -= minY

            frame = frame.union(subelement.frame)
        }

        setHighPriorityValue(frame.width, for: .width)
        setHighPriorityValue(frame.height, for: .height)
        return self
    }

    // MARK: Low priority

    /// Set up the corner radius value.
    ///
    /// - returns: `Maker` instance for chaining relations.

    @discardableResult public func cornerRadius(_ cornerRadius: Number) -> Self {
        let handler = { [unowned self] in
            self.element.cornerRadius = cornerRadius.value
        }
        handlers.append((.low, handler))
        return self
    }

    /// Set up the corner radius value as either a half-width or half-height.
    ///
    /// - returns: `Maker` instance for chaining relations.

    @discardableResult public func cornerRadius(byHalf type: Size) -> Self {
        let handler = { [unowned self] in
            if case Size.width = type {
                self.element.cornerRadius = self.newRect.width / 2
            } else {
                self.element.cornerRadius = self.newRect.height / 2
            }
        }
        handlers.append((.low, handler))
        return self
    }

    func apply(_ f: ((Number) -> Self), _ inset: Number?) {
        if let inset = inset {
            _ = f(inset)
        }
    }

    func setHighPriorityValue(_ value: CGFloat, for relationType: RelationType) {
        let handler = { [unowned self] in
            self.newRect.setValue(value, for: relationType)
        }
        handlers.append((.high, handler))

        switch relationType {
        case .width:  widthParameter = ValueParameter(value: value)
        case .height: heightParameter = ValueParameter(value: value)
        default: break
        }
    }
}
