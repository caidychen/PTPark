//
//  NSTimer+Weak.swift
//  PTPark
//
//  Created by soso on 2017/4/21.
//
//

import Foundation

typealias PTTimerAction = ((Void) -> Void)
extension Timer {
    
    class func ptScheuled(_ interval: TimeInterval, _ action:PTTimerAction, _ repeats: Bool) -> Timer {
        return Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(_pt_timerBlockInvoke), userInfo: nil, repeats: repeats)
    }
    
    @objc fileprivate func _pt_timerBlockInvoke(_ timer: Timer) {
        let action = timer.userInfo as? PTTimerAction
        action?()
    }
    
}
