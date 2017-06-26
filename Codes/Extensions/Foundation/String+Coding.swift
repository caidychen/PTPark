//
//  String+Coding.swift
//  PTPark
//
//  Created by soso on 2017/4/14.
//
//

import Foundation

public extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
