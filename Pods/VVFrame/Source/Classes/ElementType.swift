//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import UIKit

public class ElementType {
    static func view(_ view: UIView) -> ElementType {
        return ViewType(view: view)
    }

    static func layer(_ layer: CALayer) -> ElementType {
        return .init(layer: layer)
    }

    unowned let layer: CALayer

    var superelement: ElementType? {
        guard let superlayer = layer.superlayer else {
            return nil
        }
        return .layer(superlayer)
    }

    var subelements: [ElementType] {
        layer.sublayers?.map { layer in
            .layer(layer)
        } ?? []
    }

    var frame: CGRect {
        get {
            layer.frame
        }
        set {
            layer.frame = newValue
        }
    }

    var bounds: CGRect {
        get {
            layer.bounds
        }
        set {
            layer.bounds = newValue
        }
    }

    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    init(layer: CALayer) {
        self.layer = layer
    }

    func contains(_ element: ElementType) -> Bool {
        let isSubelement = subelements.contains { subelement in
            subelement == element
        }
        guard !isSubelement else {
            return true
        }
        for subelement in subelements {
            if subelement.contains(element) {
                return true
            }
        }
        return false
    }

    func convert(_ rect: CGRect, from element: ElementType?) -> CGRect {
        guard let element = element else {
            return self.layer.convert(rect, from: nil)
        }
        return layer.convert(rect, from: element.layer)
    }

    static func ==(lhs: ElementType, rhs: ElementType) -> Bool {
        lhs.layer == rhs.layer
    }

    static func !=(lhs: ElementType, rhs: ElementType) -> Bool {
        lhs.layer != rhs.layer
    }

    static func ===(lhs: ElementType, rhs: ElementType) -> Bool {
        type(of: lhs) == type(of: rhs) && lhs.layer === rhs.layer
    }
}

public class ViewType: ElementType {
    unowned let view: UIView

    var nx_state: AnyHashable {
        get {
            view.nx_state
        }
        set {
            view.nx_state = newValue
        }
    }

    override var superelement: ElementType? {
        guard let superview = view.superview else {
            return nil
        }
        return .view(superview)
    }

    override var subelements: [ElementType] {
        view.subviews.map { view in
            .view(view)
        }
    }

    override var frame: CGRect {
        get {
            view.frame
        }
        set {
            view.frame = newValue
        }
    }

    override var bounds: CGRect {
        get {
            view.bounds
        }
        set {
            view.bounds = newValue
        }
    }

    var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        }
        return .zero
    }

    init(view: UIView) {
        self.view = view
        super.init(layer: view.layer)
    }

    func sizeToFit() {
        view.sizeToFit()
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        view.sizeThatFits(size)
    }
}
