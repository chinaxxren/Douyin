//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import UIKit

public class Keyboard: EdgeRelationCollection {

    public var rect: CGRect {
        return KeyboardRectCloneView.shared.frame
    }

    public var isVisible: Bool {
        guard let window = KeyboardRectCloneView.shared.window else {
            return false
        }

        return KeyboardRectCloneView.shared.frame.intersects(window.frame)
    }

    init() {
        if KeyboardRectCloneView.shared.window == nil {
            Maker.initializeKeyboardTracking()
        }

        super.init(element: .view(KeyboardRectCloneView.shared))
    }
}

public var vv_keyboard: Keyboard {
    return Keyboard()
}
