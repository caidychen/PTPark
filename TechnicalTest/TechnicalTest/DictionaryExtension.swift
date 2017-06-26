//
//  DictionaryExtension.swift
//  PTLatitude
//
//  Created by CHEN KAIDI on 2016/12/29.
//

import Foundation

extension Dictionary {
    
    mutating func append(_ dictionary: [Key: Value?]?) {
        guard let dictionary = dictionary else {
            return
        }
        for (key, value) in dictionary {
            if let value = value {
                updateValue(value, forKey: key)
            }
        }
    }
}
