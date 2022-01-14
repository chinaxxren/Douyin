//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    func listenForKeyboardEvents() {
        KeyboardRectCloneView.shared.subscribe(self)
    }

    func stopListeningForKeyboardEvents() {
        KeyboardRectCloneView.shared.unsubscribe(self)
    }
}
