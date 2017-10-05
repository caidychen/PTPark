//
//  ChainingAnimations
//
//  Created by HeYilei on 20/03/2016.
//  Copyright © 2016 lionhylra. All rights reserved.
//

import Foundation
import QuartzCore

class ChainingAnimations {
    private var beginTime = CACurrentMediaTime()
    private(set) var totalDuration: CFTimeInterval = 0

    /**
     Call this method after specifying the duration of the animation and before adding the animation to target layer
     */
    func addAnimation(_ animation: CAAnimation) {
        animation.beginTime = beginTime + totalDuration
        totalDuration += animation.duration
    }
}
