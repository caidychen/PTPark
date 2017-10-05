//
//  Optional+Apply.swift
//  Swift3Project
//
//  Created by Yilei He on 9/4/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import Foundation

// MARK: - Optional execution -
extension Optional {
    /**
     If the receiver is .Some(value), then call f(value). Else if the receiver is .None, then do nothing
     
     - parameter f: a closure in witch the wrapped value is passed if the receiver is not .None
     */
    func apply(_ f: (_ value: Wrapped) throws -> Void) rethrows {
        if case let .some(value) = self {
            try f(value)
        }
    }
}

extension Optional where Wrapped == String {
    var isEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let str):
            return str.isEmpty
        }
    }

    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let str):
            return (str as! AnyCollection<Any>).isEmpty
        }
    }

    var isNotEmpty: Bool {
        return !isEmpty
    }
}
