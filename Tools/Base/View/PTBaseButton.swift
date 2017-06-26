//
//  PTBaseButton.swift
//  PTPark
//
//  Created by soso on 2017/5/12.
//
//

import UIKit

class PTBaseButton: UIButton {
    
    override var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            super.isEnabled = newValue
            self.setBackgroundColor(backgroundColor(for: newValue), for: newValue)
            super.backgroundColor = newValue ? enabledBackgroundColor : disabledBackgroundColor
        }
    }
    
    fileprivate var enabledBackgroundColor: UIColor? = .clear
    fileprivate var disabledBackgroundColor: UIColor? = UIColor(hexValue: 0xe1e1e1)
    func backgroundColor(for abled: Bool) -> UIColor? {
        return abled ? enabledBackgroundColor : disabledBackgroundColor
    }
    
    func setBackgroundColor(_ color: UIColor?, for abled: Bool) {
        if abled {
            enabledBackgroundColor = color
        } else {
            disabledBackgroundColor = color
        }
    }

}
