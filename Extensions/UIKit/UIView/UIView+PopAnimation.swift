//
//  UIView+PopAnimation.swift
//  Swift3Project
//
//  Created by Yilei on 30/3/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import UIKit

extension UIView {
    func pop(scale: CGFloat, completion: (() -> Void)?) {
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: 0.05, curve: .easeIn, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            })
            animator.addCompletion({ (_) in
                let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.3, animations: {
                    self.transform = CGAffineTransform.identity
                })
                animator.addCompletion({ (_) in
                    completion?()
                })
                animator.startAnimation()
            })
            animator.startAnimation()

        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            let startTime = CACurrentMediaTime()

            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = scale
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animation.duration = 0.1
            animation.beginTime = startTime

            let spring = CASpringAnimation(keyPath: "transform.scale")
            spring.beginTime = startTime + 0.1
            spring.toValue = 1.0
            spring.fromValue = scale
            spring.duration = spring.settlingDuration

            spring.initialVelocity = 15
            spring.damping = 15

            self.layer.add(animation, forKey: "scaleUp")
            self.layer.add(spring, forKey: "scaleDown")

            CATransaction.commit()
        }
    }
}
