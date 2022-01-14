//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import UIKit

extension Maker {

    /// Creates equal relations.
    ///
    /// - parameter view:   The view, against which sets relations.
    /// - parameter insets: The insets for setting relations with `view`. Default value: `UIEdgeInsets.zero`.
    ///
    /// - returns: `UIViewMaker` instance for chaining relations.
    @discardableResult public func equal(_ view: UIView,_ insets: UIEdgeInsets = .zero) -> Self {
        return equal(.view(view),insets)
    }

    /// Creates equal relations.
    ///
    /// - parameter layer:   The layer, against which sets relations.
    /// - parameter insets: The insets for setting relations with `layer`. Default value: `UIEdgeInsets.zero`.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func equal(_ layer: CALayer,_ insets: UIEdgeInsets = .zero) -> Self {
        return equal(.layer(layer),insets)
    }

    private func equal(_ element: ElementType,_ insets: UIEdgeInsets = .zero) -> Self {
        let topView = RelationView<VerticalRelation>(element: element, relation: .top)
        let leftView = RelationView<HorizontalRelation>(element: element, relation: .left)
        let bottomView = RelationView<VerticalRelation>(element: element, relation: .bottom)
        let rightView = RelationView<HorizontalRelation>(element: element, relation: .right)

        return top(topView, insets.top)
                .left(leftView, insets.left)
                .bottom(bottomView, insets.bottom)
                .right(rightView, insets.right)
    }
}
