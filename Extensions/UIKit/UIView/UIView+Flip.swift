//
//  ViewAnimation.swift
//  RotateMe
//
//  Created by Yilei He on 26/07/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit
extension UIView {
    func flip(vx: CGFloat, vy: CGFloat, vz: CGFloat, clockwise: Bool, duration: TimeInterval = 0.3, completeHalfRotationHandler: ( (UIView) -> Void)? = nil, completion:( (UIView) -> Void)? = nil) {

        let angle = clockwise ? -CGFloat.pi/2 : CGFloat.pi/2
        let distance = sqrt(self.bounds.width*self.bounds.width + self.bounds.height*self.bounds.height) * 2
        self.layer.transform.m34 = -1/distance
        UIView.animate(withDuration: duration/2, animations: {
            self.layer.transform = CATransform3DRotate(self.layer.transform, angle, vx, vy, vz)

        }) { (_) in

            self.layer.transform = CATransform3DRotate(self.layer.transform, 2*angle, vx, vy, vz)

            completeHalfRotationHandler?(self)

            UIView.animate(withDuration: duration/2, animations: {
                self.layer.transform = CATransform3DRotate(self.layer.transform, angle, vx, vy, vz)
                }, completion: {_ in completion?(self)})
        }
    }

    func flipHorizontally(clockwise: Bool, duration: TimeInterval = 0.3, completeHalfRotationHandler: ( (UIView) -> Void)? = nil, completion:( (UIView) -> Void)? = nil) {
        flip(vx: 0, vy: 1.0, vz: 0, clockwise: clockwise, duration: duration, completeHalfRotationHandler: completeHalfRotationHandler, completion: completion)
    }

    func flipVertically(clockwise: Bool, duration: TimeInterval = 0.3, completeHalfRotationHandler: ( (UIView) -> Void)? = nil, completion:( (UIView) -> Void)? = nil) {
        flip(vx: 1.0, vy: 0, vz: 0, clockwise: clockwise, duration: duration, completeHalfRotationHandler: completeHalfRotationHandler, completion: completion)
    }
}
