//
//  Cache+Subscripting.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 12/12/22.
//

import Foundation

extension Cache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }
}
