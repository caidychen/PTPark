//
//  CGGeometry+PT.swift
//  PTPark
//
//  Created by soso on 2017/4/13.
//
//

import CoreGraphics

extension Double {
    
    var size: CGSize {
        get {
            return CGSize(width: self, height: self)
        }
    }
    
    var square: CGRect {
        get {
            return CGRect(x: 0, y: 0, width: self, height: self)
        }
    }
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: CGFloat(self), left: CGFloat(self), bottom: CGFloat(self), right: CGFloat(self))
        }
    }
    
}

extension CGFloat {
    
    var ceil: CGFloat {
        get {
            return CGFloat(ceilf(Float(self)))
        }
    }
    
    var floor: CGFloat {
        get {
            return CGFloat(floorf(Float(self)))
        }
    }
    
    var size: CGSize {
        get {
            return CGSize(width: self, height: self)
        }
    }
    
    var square: CGRect {
        get {
            return CGRect(x: 0, y: 0, width: self, height: self)
        }
    }
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: self, left: self, bottom: self, right: self)
        }
    }
    
}

extension CGSize {
    
    var ceil: CGSize {
        get {
            return CGSize(width: CGFloat(ceilf(Float(self.width))), height: CGFloat(ceilf(Float(self.height))))
        }
    }
    
    var floor: CGSize {
        get {
            return CGSize(width: CGFloat(floorf(Float(self.width))), height: CGFloat(floorf(Float(self.height))))
        }
    }
    
    var bounds: CGRect {
        get {
            return CGRect(x: 0, y: 0, width: self.width, height: self.height)
        }
    }
    
}

extension CGRect {
    
    var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            self.origin = CGPoint(x: self.size.width - newValue.x, y: self.size.height - newValue.y)
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.midX
        }
        set {
            self.origin.x = self.size.width - newValue
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.midY
        }
        set {
            self.origin.y = self.size.height - newValue
        }
    }
    
    var top: CGFloat {
        get {
            return self.minY
        }
        set {
            self.origin.y = newValue
        }
    }
    
    var left: CGFloat {
        get {
            return self.minX
        }
        set {
            self.origin.x = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.maxY
        }
        set {
            self.origin.y = newValue - self.size.height
        }
    }
    
    var right: CGFloat {
        get {
            return self.maxX
        }
        set {
            self.origin.x = newValue - self.size.width
        }
    }
    
}
