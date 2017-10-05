//
//  UIView+Frame.swift
//  AirPay
//
//  Created by KD Chen on 22/8/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import Foundation

extension UIView {

    var left:CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = left
            self.frame = frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var top:CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = top
            self.frame = frame
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var right:CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = right - frame.width
            self.frame = frame
        }
        get{
            return self.frame.origin.x + self.frame.width
        }
    }
    
    var bottom:CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = bottom - frame.height
            self.frame = frame
        }
        get{
            return self.frame.origin.y + self.frame.height
        }
    }
    
    var width:CGFloat {
        set{
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
        get{
            return self.frame.width
        }
    }
    
    var height:CGFloat {
        set{
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
        get{
            return self.frame.height
        }
    }
}
