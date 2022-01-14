//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import UIKit

/// Phantom type for `vv_left`, `vv_right`, `vv_centerX` relations.

public protocol HorizontalRelation {
}

/// Phantom type for `vv_top`, `vv_bottom`, `vv_centerY` relations.

public protocol VerticalRelation {
}

/// Phantom type for `vv_height`, `vv_width` relations.

public protocol SizeRelation {
}

public final class RelationView<Relation> {

    var element: ElementType
    var relationType: RelationType

    init(element: ElementType, relation: RelationType) {
        self.element = element
        self.relationType = relation
    }
}

enum SafeAreaType {
    case top
    case left
    case right
    case bottom
}

enum RelationType {
    case bottom
    case top
    case left
    case right
    case width
    case widthTo
    case height
    case heightTo
    case centerX
    case centerY
    case safeArea(SafeAreaType)
}

extension RelationType {
    var isSizeType: Bool {
        switch self {
        case .width, .widthTo, .height, .heightTo:
            return true
        default:
            return false
        }
    }
}

public enum ContainerRelation {
    case width(Number)
    case height(Number)
    case horizontal(_ left: Number,_ right: Number)
    case vertical(_ top: Number,_ bottom: Number)
}

public class EdgeRelationCollection {
    var element: ElementType

    public lazy var top: RelationView<VerticalRelation> = .init(element: element, relation: .top)
    public lazy var left: RelationView<HorizontalRelation> = .init(element: element, relation: .left)
    public lazy var right: RelationView<HorizontalRelation> = .init(element: element, relation: .right)
    public lazy var bottom: RelationView<VerticalRelation> = .init(element: element, relation: .bottom)

    init(element: ElementType) {
        self.element = element
    }
}
