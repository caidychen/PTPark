//
//  Collection+elementForIndex.swift
//  Swift3Project
//
//  Created by Yilei on 22/5/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import Foundation

extension Collection {
    subscript(basePosition: Self.Index, offset: Self.IndexDistance) -> Self.Iterator.Element {
        get {
            return self[index(basePosition, offsetBy: offset)]
        }
    }

    func first(offset: Self.IndexDistance) -> Self.Iterator.Element {
        return self[index(startIndex, offsetBy: offset)]
    }

    func last(offset: Self.IndexDistance) -> Self.Iterator.Element {
        return self[index(endIndex, offsetBy: offset - 1)]
    }
}
