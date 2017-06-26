//
//  UIView+Animation.swift
//  PTPark
//
//  Created by soso on 2017/4/13.
//
//

import UIKit

extension UIView {
    
    func popup(_ duration: TimeInterval) {
        let key = String(describing: #selector(popup))
        let animate = CAKeyframeAnimation(keyPath: "transform")
        animate.values = [CATransform3DMakeScale(0.5, 0.5, 0.5),
                          CATransform3DMakeScale(1.1, 1.1, 1.0),
                          CATransform3DMakeScale(1.0, 1.0, 1.0)]
        animate.duration = duration
        self.layer.add(animate, forKey:key)
    }
    
}
