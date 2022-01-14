//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import UIKit

extension Maker {

    /// Creates left relation to super instance.
    ///
    /// Use this method when you want to join left side of current instance with left side of super instance.
    ///
    /// - parameter inset: The inset for additional space between instances. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func left(_ inset: Number = 0.0) -> Self {
        guard let superelement = element.superelement else {
            assertionFailure("Can not configure left relation to superview without super instance.")
            return self
        }
        return left(RelationView(element: superelement, relation: .left), inset)
    }
    
    /// Creates left relation.
    ///
    /// Use this method when you want to join left side of current view with some horizontal side of another view.
    ///
    /// - note: You can not use this method with other relations except for `vv_left`, `vv_centerX` and `vv_right`.
    ///
    /// - parameter relationView:   The view on which you set left relation.
    /// - parameter inset:          The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func left(_ relationView: RelationView<HorizontalRelation>, _ inset: Number = 0.0) -> Self {
        let element = relationView.element
        let relationType = relationView.relationType

        let handler = { [unowned self] in
            let x = self.convertedValue(for: relationType, with: element) + inset.value
            self.newRect.setValue(x, for: .left)
        }
        handlers.append((.high, handler))
        leftParameter = SideParameter(element: element, value: inset.value, relationType: relationType)
        return self
    }

    /// Creates top relation to superview.
    ///
    /// Use this method when you want to join top side of current view with top side of superview.
    ///
    /// - parameter inset: The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func top(_ inset: Number = 0.0) -> Self {
        guard let superelement = element.superelement else {
            assertionFailure("Can not configure a top relation to superview without superview.")
            return self
        }
        return top(RelationView(element: superelement, relation: .top), inset.value)
    }

    /// Creates top relation.
    ///
    /// Use this method when you want to join top side of current instance with some vertical side of another instance.
    ///
    /// - note: You can not use this method with other relations except for `vv_top`, `vv_centerY` and `vv_bottom`.
    ///
    /// - parameter relationView:  The view on which you set top relation.
    /// - parameter inset:         The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func top(_ relationView: RelationView<VerticalRelation>, _ inset: Number = 0.0) -> Self {
        let element = relationView.element
        let relationType = relationView.relationType

        let handler = { [unowned self] in
            let y = self.convertedValue(for: relationType, with: element) + inset.value
            self.newRect.setValue(y, for: .top)
        }
        handlers.append((.high, handler))
        topParameter = SideParameter(element: element, value: inset.value, relationType: relationType)
        return self
    }

    // MARK: Middle priority

    /// Creates margin relation for super instance.
    ///
    /// - parameter inset: The inset for setting top, left, bottom and right relations for supercinstance.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func margin(_ inset: Number) -> Self {
        let inset = inset.value
        return edges(UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    /// Creates bottom relation to super instance.
    ///
    /// Use this method when you want to join bottom side of current instance with bottom side of super instance.
    ///
    /// - parameter inset: The inset for additional space between instances. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func bottom(_ inset: Number = 0.0) -> Self {
        guard let superelement = element.superelement else {
            assertionFailure("Can not configure a bottom relation to superview without superview.")
            return self
        }
        return bottom(RelationView(element: superelement, relation: .bottom), inset)
    }

    /// Creates bottom relation.
    ///
    /// Use this method when you want to join bottom side of current view with some vertical side of another view.
    ///
    /// - note: You can not use this method with other relations except for `vv_top`, `vv_centerY` and `vv_bottom`.
    ///
    /// - parameter relationView:   The view on which you set bottom relation.
    /// - parameter inset:          The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func bottom(_ relationView: RelationView<VerticalRelation>, _ inset: Number = 0.0) -> Self {
        let element = relationView.element
        let relationType = relationView.relationType

        let handler = { [unowned self] in
            if self.topParameter != nil {
                let height = abs(self.newRect.minY - self.convertedValue(for: relationType, with: element)) - inset.value
                self.newRect.setValue(height, for: .height)
            } else {
                let y = self.convertedValue(for: relationType, with: element) - inset.value - self.newRect.height
                self.newRect.setValue(y, for: .top)
            }
        }
        handlers.append((.middle, handler))
        bottomParameter = SideParameter(element: element, value: inset.value, relationType: relationType)
        return self
    }

    /// Creates right relation to super instance.
    ///
    /// Use this method when you want to join right side of current instance  with right side of super instance.
    ///
    /// - parameter inset: The inset for additional space between instances. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func right(_ inset: Number = 0.0) -> Self {
        guard let superelement = element.superelement else {
            assertionFailure("Can not configure a right relation to superview without super instance.")
            return self
        }
        return right(RelationView(element: superelement, relation: .right), inset.value)
    }

    /// Creates right relation.
    ///
    /// Use this method when you want to join right side of current instance with some horizontal side of another instance.
    ///
    /// - note: You can not use this method with other relations except for `vv_left`, `vv_centerX` and `vv_right`.
    ///
    /// - parameter relationView:     The view on which you set right relation.
    /// - parameter inset:            The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func right(_ relationView: RelationView<HorizontalRelation>, _ inset: Number = 0.0) -> Self {
        let element = relationView.element
        let relationType = relationView.relationType

        let handler = { [unowned self] in
            if self.leftParameter != nil {
                let width = abs(self.newRect.minX - self.convertedValue(for: relationType, with: element)) - inset.value
                self.newRect.setValue(width, for: .width)
            } else {
                let x = self.convertedValue(for: relationType, with: element) - inset.value - self.newRect.width
                self.newRect.setValue(x, for: .left)
            }
        }
        handlers.append((.middle, handler))
        rightParameter = SideParameter(element: element, value: inset.value, relationType: relationType)
        return self
    }

    /// Creates center relation to superview.
    ///
    /// Use this method when you want to center view by both axis relativity superview.
    ///
    /// - returns: `Maker` instance for chaining relations.

    @discardableResult public func center() -> Self {
        guard let superelement = element.superelement else {
            assertionFailure("Can not configure a center relation to superview without superview.")
            return self
        }
        if let view = (superelement as? ViewType)?.view {
            return center(to: view)
        }
        return center(to: superelement.layer)
    }

    /// Creates center relation.
    ///
    /// Use this method when you want to center instance by both axis relativity another instance.
    ///
    /// - parameter view: The view on which you set center relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func center(to view: UIView) -> Self {
        return centerX(RelationView<HorizontalRelation>(element: .view(view), relation: .centerX))
                .centerY(RelationView<VerticalRelation>(element: .view(view), relation: .centerY))
    }

    /// Creates center relation.
    ///
    /// Use this method when you want to center view by both axis relativity another layer.
    ///
    /// - parameter layer: The layer on which you set center relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func center(to layer: CALayer) -> Self {
        return centerX(RelationView<HorizontalRelation>(element: .layer(layer), relation: .centerX))
                .centerY(RelationView<VerticalRelation>(element: .layer(layer), relation: .centerY))
    }

    /// Creates center relation rotated around center of a specified view.
    ///
    /// Use this method when you want to center instance by both axis relativity another view.
    ///
    /// - parameter view: The view on which you set center relation.
    /// - parameter radius: Radius of the arc on which center point will be placed.
    /// - parameter angle: Angle at which center point will be placed.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func center(_ view: UIView, radius: CGFloat, _ angle: CGFloat) -> Self {
        let offsetX = -radius * cos(-angle)
        let offsetY = radius * sin(-angle)
        return centerX(RelationView<HorizontalRelation>(element: .view(view), relation: .centerX), offsetX)
                .centerY(RelationView<VerticalRelation>(element: .view(view), relation: .centerY), offsetY)
    }

    /// Creates centerY relation.
    ///
    /// Use this method when you want to join centerY of current instance with centerY of super instance.
    ///
    /// - parameter offset: Additional offset for centerY point. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func centerY(_ offset: Number = 0.0) -> Self {
        guard let superelement = element.superelement else {
            assertionFailure("Can not configure a centerY relation to superview without super instance.")
            return self
        }
        return centerY(RelationView(element: superelement, relation: .centerY), offset.value)
    }

    /// Creates centerY relation.
    ///
    /// Use this method when you want to join centerY of current instance with some vertical side of another instance.
    ///
    /// - note: You can not use this method with other relations except for `vv_top`, `vv_centerY` and `vv_bottom`.
    ///
    /// - parameter relationView:   The view on which you set centerY relation.
    /// - parameter offset:         Additional offset for centerY point. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func centerY(_ relationView: RelationView<VerticalRelation>, _ offset: Number = 0.0) -> Self {
        let view = relationView.element
        let relationType = relationView.relationType

        let handler = { [unowned self] in
            let y = self.convertedValue(for: relationType, with: view) - self.newRect.height / 2 - offset.value
            self.newRect.setValue(y, for: .top)
        }
        handlers.append((.low, handler))
        return self
    }

    /// Creates centerY relation between two views.
    ///
    /// Use this method when you want to configure centerY point between two following views.
    ///
    /// - parameter view1: The first view between which you set `centerY` relation.
    /// - parameter view2: The second view between which you set `centerY` relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func centerY(between view1: UIView, _ view2: UIView) -> Self {
        let topView = view1.frame.maxY > view2.frame.minY ? view2 : view1
        let bottomView = topView === view1 ? view2 : view1
        return centerY(between: topView.vv_bottom, bottomView.vv_top)
    }

    /// Creates centerY relation between two relation views.
    ///
    /// Use this method when you want to configure centerY point between two relations views.
    ///
    /// - parameter relationView1: The first relation view between which you set `centerY` relation.
    /// - parameter relationView2: The second relation view between which you set `centerY` relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func centerY(between relationView1: RelationView<VerticalRelation>,
                                           _ relationView2: RelationView<VerticalRelation>) -> Self {
        let view1 = relationView1.element
        let view2 = relationView2.element

        let relationType1 = relationView1.relationType
        let relationType2 = relationView2.relationType

        let handler = { [unowned self] in
            let y1 = self.convertedValue(for: relationType1, with: view1)
            let y2 = self.convertedValue(for: relationType2, with: view2)

            let topY = y1 < y2 ? y1 : y2
            let bottomY = y1 >= y2 ? y1 : y2

            let y = bottomY - (bottomY - topY) / 2 - self.newRect.height / 2
            self.newRect.setValue(y, for: .top)
        }
        handlers.append((.low, handler))
        return self
    }

    /// Creates centerX relation to super instance.
    ///
    /// Use this method when you want to join centerX of current instance with centerX of super instance.
    ///
    /// - parameter offset: Additional offset for centerX point. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.

    @discardableResult public func centerX(_ offset: Number = 0.0) -> Self {
        guard let superelement = element.superelement else {
            assertionFailure("Can not configure a centerX relation to superview without super instance.")
            return self
        }
        return centerX(RelationView(element: superelement, relation: .centerX), offset.value)
    }

    /// Creates centerX relation.
    ///
    /// Use this method when you want to join centerX of current instance with some horizontal side of another instance.
    ///
    /// - note: You can not use this method with other relations except for `vv_left`, `vv_centerX` and `vv_right`.
    ///
    /// - parameter relationView:   The view on which you set centerX relation.
    /// - parameter offset:         Additional offset for centerX point. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func centerX(_ relationView: RelationView<HorizontalRelation>, _ offset: Number = 0.0) -> Self {
        let view = relationView.element
        let relationType = relationView.relationType

        let handler = { [unowned self] in
            let x = self.convertedValue(for: relationType, with: view) - self.newRect.width / 2 - offset.value
            self.newRect.setValue(x, for: .left)
        }
        handlers.append((.low, handler))
        return self
    }

    /// Creates centerX relation between two views.
    ///
    /// Use this method when you want to configure centerX point between two following views.
    ///
    /// - parameter view1: The first view between which you set `centerX` relation.
    /// - parameter view2: The second view between which you set `centerX` relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func centerX(between view1: UIView, _ view2: UIView) -> Self {

        let leftView = view1.frame.maxX > view2.frame.minX ? view2 : view1
        let rightView = leftView === view1 ? view2 : view1
        return centerX(between: leftView.vv_right, rightView.vv_left)
    }

    /// Creates centerX relation between two relation views.
    ///
    /// Use this method when you want to configure centerX point between two relations views.
    ///
    /// - parameter relationView1: The first relation view between which you set `centerX` relation.
    /// - parameter relationView2: The second relation view between which you set `centerX` relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func centerX(between relationView1: RelationView<HorizontalRelation>,
                                           _ relationView2: RelationView<HorizontalRelation>) -> Self {
        let view1 = relationView1.element
        let view2 = relationView2.element

        let relationType1 = relationView1.relationType
        let relationType2 = relationView2.relationType

        let handler = { [unowned self] in
            let x1 = self.convertedValue(for: relationType1, with: view1)
            let x2 = self.convertedValue(for: relationType2, with: view2)

            let rightX = x1 < x2 ? x1 : x2
            let leftX = x1 >= x2 ? x1 : x2

            let x = rightX - (rightX - leftX) / 2 - self.newRect.width / 2
            self.newRect.setValue(x, for: .left)
        }
        handlers.append((.low, handler))
        return self
    }

    /// Just setting centerX.
    ///
    /// - parameter value: The value for setting centerX.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func setCenterX(_ value: Number) -> Self {
        let handler = { [unowned self] in
            self.newRect.setValue(value.value, for: .centerX)
        }
        handlers.append((.low, handler))
        return self
    }

    /// Just setting centerY.
    ///
    /// - parameter value: The value for setting centerY.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func setCenterY(_ value: Number) -> Self {
        let handler = { [unowned self] in
            self.newRect.setValue(value.value, for: .centerY)
        }
        handlers.append((.low, handler))
        return self
    }
    
    @discardableResult public func safeAreaLeft() -> Self {
        let safeAreaInsets = SafeAreaInsets()
        return left(safeAreaInsets.left)
    }
    
    @discardableResult public func safeAreaTop() -> Self {
        let safeAreaInsets = SafeAreaInsets()
        return top(safeAreaInsets.top)
    }
    
    @discardableResult public func safeAreaRight() -> Self {
        let safeAreaInsets = SafeAreaInsets()
        return right(safeAreaInsets.right)
    }   
    
    @discardableResult public func safeAreaBottom() -> Self {
        let safeAreaInsets = SafeAreaInsets()
        return bottom(safeAreaInsets.bottom)
    }
    
    @discardableResult public func safeArea() -> Self {
        let safeAreaInsets = SafeAreaInsets()
        return edges(safeAreaInsets)
    }
}
