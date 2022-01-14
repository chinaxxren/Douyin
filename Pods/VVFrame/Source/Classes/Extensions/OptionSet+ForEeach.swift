//
//  Copyright © 2021 chinaxxren. All rights reserved.
//

extension OptionSet where RawValue: BinaryInteger, Element == Self {
    public func forEach(_ body: (Self) -> Void) {
        var i = 0
        while i < rawValue.bitWidth {
            let option = Self.init(rawValue: 1 << i)
            if contains(option) {
                body(option)
            }
            i += 1
        }
    }
}
