//
//  CGRect+center.swift
//  Swift3Project
//
//  Created by Yilei He on 7/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import CoreGraphics

extension CGRect {
    var centerX: CGFloat {
        get {
            return (maxX + minX) / 2
        }
        set {
            origin.x = newValue - size.width / 2
        }
    }

    var centerY: CGFloat {
        get {
            return (maxY + minY) / 2
        }
        set {
            origin.y = newValue - size.height / 2
        }
    }

    var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
    }
}
