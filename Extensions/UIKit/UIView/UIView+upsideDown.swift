//
//  UIView+FlipOrigin.swift
//  Swift3Project
//
//  Created by Yilei He on 7/12/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

/*
extension UIView {
    
    
    /// convert to macOS coordinate
    func upsideDown() {
        var t = CGAffineTransform(translationX: 0, y: frame.height)
        t = CGAffineTransform(scaleX: 1.0, y: -1.0).concatenating(t)
        self.transform = t
    }
}
*/

extension UIView {
    func makeUpsideDown() {
        self.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
    }
}
