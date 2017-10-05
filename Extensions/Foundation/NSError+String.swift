//
//  NSError+String.swift
//  Swift3Project
//
//  Created by Yilei on 14/6/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import Foundation

extension NSError {
    convenience init(description: String) {
        let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as! String
        self.init(domain: bundleIdentifier, code: 0, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
