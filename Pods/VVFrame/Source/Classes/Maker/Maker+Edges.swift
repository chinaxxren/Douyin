//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import UIKit

extension Maker {

    /// Creates edge relations.
    ///
    /// It's useful method for configure some side relations in short form.
    ///
    /// ```
    /// Instead of writing:
    ///     maker.top(10).bottom(10).and.left(10)
    /// just write:
    ///     maker.edges(top:10, left:10, bottom:10) - it's more elegant.
    /// ```
    ///
    /// - parameter top:    The top inset relation relatively super instance.
    /// - parameter left:   The left inset relation relatively super instance.
    /// - parameter bottom: The bottom inset relation relatively super instance.
    /// - parameter right:  The right inset relation relatively super instance.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func edges(_ top: Number? = nil,_ left: Number? = nil,_ bottom: Number? = nil,_ right: Number? = nil) -> Self {
        _ = apply(self.top, top)
        _ = apply(self.left, left)
        _ = apply(self.bottom, bottom)
        _ = apply(self.right, right)
        return self
    }

    /// Creates edge relations for super instance.
    ///
    /// - parameter insets: The insets for setting relations for super instance.
    ///
    /// - parameter sides: The sides which will inculed from edge insets to setting relations.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func edges(_ insets: UIEdgeInsets,_ sides: Sides = .all) -> Self {
        sides.forEach { side in
            switch side {
            case .bottom:
                bottom(insets.bottom)
            case .left:
                left(insets.left)
            case .right:
                right(insets.right)
            case .top:
                top(insets.top)
            case .horizontal:
                right(insets.right)
                left(insets.left)
            case .vertical:
                top(insets.top)
                bottom(insets.bottom)
            case .all:
                right(insets.right)
                left(insets.left)
                top(insets.top)
                bottom(insets.bottom)
            default:
                return
            }
        }
        return self
    }
}
