//
//  UIView+shake.swift
//  Swift3Project
//
//  Created by Yilei He on 20/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit
import AudioToolbox

extension UIView {
    func shake(withVibration: Bool) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -18.0, 18.0, -13.0, 13.0, -8.0, 8.0, -3.0, 3.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        if(withVibration) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}
