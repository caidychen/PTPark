//
//  CAAnimation+Closure.swift
//  AnimationDemo
//
//  Created by HeYilei on 2/04/2016.
//  Copyright © 2016 lionhylra. All rights reserved.
//

import QuartzCore

extension CAAnimation {
    /**
     This method is equivalent to setting a delegate object to the animation. Setting delegate to the animation after calling this method will invalidate this function.
     - important: The two closures are retained by the animation.
     
     #### discussion:
     You can use either this method or CATransaction to set completion block.
     
     Example:
     ```
     CATransaction.begin()
     CATransaction.setCompletionBlock {
        print("completion block", CACurrentMediaTime())
     }
     CATransaction.commit()
     ```
     The completion block will be also called after animation completes, but it is invoked before the animationDidStop closure is invoked on delegate.
     
     
     - parameter animationDidStartClosure: The closure that is invoked when animation starts
     - parameter animationDidStopClosure:  The closure that is invoked when animation stops
     */
    func setClosure(animationDidStartClosure: ((_ anim: CAAnimation) -> Void)?, animationDidStopClosure:((_ anim: CAAnimation, _ finished: Bool) -> Void)?) {
        self.delegate = {
            class AnimationDelegate: NSObject, CAAnimationDelegate {
                let startClosure:((_ anim: CAAnimation) -> Void)?
                let stopClosure:((_ anim: CAAnimation, _ finished: Bool) -> Void)?
                init(animationDidStartClosure:((_ anim: CAAnimation) -> Void)?, animationDidStopClosure:((_ anim: CAAnimation, _ finished: Bool) -> Void)?) {
                    startClosure = animationDidStartClosure
                    stopClosure = animationDidStopClosure
                }

                func animationDidStart(_ anim: CAAnimation) {
                    startClosure?(anim)
                }

                func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
                    stopClosure?(anim, flag)
                }
            }
            return AnimationDelegate(animationDidStartClosure: animationDidStartClosure, animationDidStopClosure: animationDidStopClosure)
            }()
    }
}
