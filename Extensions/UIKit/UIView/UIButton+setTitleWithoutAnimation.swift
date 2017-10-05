//
//  UIButton+setTitleWithoutAnimation.swift
//  Swift3Project
//
//  Created by Yilei He on 15/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UIButton {
    public func setTitle(_ title: String?, for state: UIControlState, animated: Bool) {
        if !animated {
            UIView.performWithoutAnimation {
                setTitle(title, for: state)
                layoutIfNeeded()
            }
        } else {
            setTitle(title, for: state)
        }
    }

    public func setTitleColor(_ color: UIColor?, for state: UIControlState, animated: Bool) {
        if !animated {
            UIView.performWithoutAnimation {
                setTitleColor(color, for: state)
                layoutIfNeeded()
            }
        } else {
            setTitleColor(color, for: state)
        }
    }
}
