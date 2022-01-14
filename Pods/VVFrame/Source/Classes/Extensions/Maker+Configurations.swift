//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import Foundation
import UIKit

postfix operator <<
postfix operator >>

/// Start frame configuration for `DEFAULT_STATE` state.
///
/// - note: Don't forget to call `>>` operator for ending of configuration.
///
/// - parameter view: The view you are configuring.
///
/// - returns: `Maker` instance for chaining relations.

public postfix func <<(view: UIView) -> Maker {
    let maker = Maker(element: .view(view))
    maker.newRect = view.frame
    return maker
}

/// Start frame configuration for `DEFAULT_STATE` state.
///
/// - note: Don't forget to call `>>` operator for ending of configuration.
///
/// - parameter layer: The layer you are configuring.
///
/// - returns: `Maker` instance for chaining relations.

public postfix func <<(layer: CALayer) -> Maker {
    let maker = Maker(element: .layer(layer))
    maker.newRect = layer.frame
    return maker
}

/// End frame configuration.

public postfix func >>(maker: Maker) {
    maker.configureFrame()
}

public typealias ViewInstallerBlock = (ViewMaker) -> Void
public typealias InstallerBlock = (Maker) -> Void

extension Maker {
    class func configure(view: UIView, for state: AnyHashable, installerBlock: ViewInstallerBlock) {
        if view.nx_state == state {
            let maker = ViewMaker(view: view)

            maker.newRect = view.frame
            installerBlock(maker)

            maker.configureFrame()
        }
    }

    class func configure(layer: CALayer, installerBlock: InstallerBlock) {
        let maker = Maker(element: .layer(layer))

        maker.newRect = layer.frame
        installerBlock(maker)

        maker.configureFrame()
    }

    fileprivate func configureFrame() {
        handlers.sorted {
            $0.priority.rawValue <= $1.priority.rawValue
        }.forEach {
            $0.handler()
        }

        element.frame = newRect
    }
}
