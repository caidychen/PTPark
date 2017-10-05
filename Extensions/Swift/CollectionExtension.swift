//
//  CollectionExtension.swift
//  AirPay
//
//  Created by KD Chen on 8/8/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    // Returns the element at the specified index iff it is within bounds, otherwise nil.
    // Reference: https://stackoverflow.com/a/30593673/1586277
    // Note this can be updated to the Swift 3.2 and 4.0 method once they are officially released.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
