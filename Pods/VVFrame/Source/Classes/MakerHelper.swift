//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import Foundation
import UIKit

extension Maker {

    func convertedValue(for type: RelationType, with element: ElementType) -> CGFloat {
        var rect: CGRect {
            if let superelement = self.element.superelement, superelement === element {
                return CGRect(origin: .zero, size: superelement.frame.size)
            }

            if let superelement = self.element.superelement {
                return superelement.convert(element.frame, from: element.superelement)
            }
            assertionFailure("Can't configure a frame for view: \(self.element) without superview.")
            return .zero
        }

        var convertedRect = rect
        if let superelement = self.element.superelement as? ViewType,
           let view = element as? ViewType,
           let superScrollView = superelement.view as? UIScrollView,
           view.view is UIScrollView,
           superScrollView.contentSize != .zero {
            convertedRect.size.width = superScrollView.contentSize.width
            convertedRect.size.height = superScrollView.contentSize.height
        }

        return value(for: type, with: element, in: convertedRect)
    }

    func value(for type: RelationType, with element: ElementType, in rect: CGRect) -> CGFloat {
        switch type {
        case .top:
            return rect.minY
        case .bottom:
            return rect.maxY
        case .centerY:
            return element.contains(self.element) ? rect.height / 2 : rect.midY
        case .centerX:
            return element.contains(self.element) ? rect.width / 2 : rect.midX
        case .right:
            return rect.maxX
        case .left:
            return rect.minX
        case .safeArea(.top):
            if let view = element as? ViewType {
                return rect.minY + view.safeAreaInsets.top
            }
            return rect.minY
        case .safeArea(.left):
            if let view = element as? ViewType {
                return rect.minX + view.safeAreaInsets.left
            }
            return rect.minX
        case .safeArea(.right):
            if let view = element as? ViewType {
                return rect.maxX - view.safeAreaInsets.right
            }
            return rect.maxX
        case .safeArea(.bottom):
            if let view = element as? ViewType {
                return rect.maxY - view.safeAreaInsets.bottom
            }
            return rect.maxY
        default:
            return 0
        }
    }

    func relationSize(element: ElementType, for type: RelationType) -> CGFloat {
        switch type {
        case .width:  return element.bounds.width
        case .height: return element.bounds.height
        default:      return 0
        }
    }
}

extension CGRect {

    mutating func setValue(_ value: CGFloat, for type: RelationType) {
        var frame = self
        switch type {
        case .width:   frame.size.width = value
        case .height:  frame.size.height = value
        case .left:    frame.origin.x = value
        case .top:     frame.origin.y = value
        case .centerX: frame.origin.x = value - width / 2
        case .centerY: frame.origin.y = value - height / 2
        default: break
        }
        self = frame
    }
}
