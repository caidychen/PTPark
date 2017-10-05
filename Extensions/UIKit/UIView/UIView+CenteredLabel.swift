//
//  UIView + CenteredLabel.swift
//  CenterLabelDemo
//
//  Created by Yilei He on 18/05/2016.
//  Copyright © 2016 Omni Martet Tide. All rights reserved.
//

import UIKit
import ObjectiveC

private var _centeredLabelAssociationKey: Int = 0
extension UIView {
    private var _centeredLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &_centeredLabelAssociationKey) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &_centeredLabelAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func showCenteredLabel(text: String?, configuration: (UILabel) -> Void = { _ in }) {
        if _centeredLabel == nil {
            _centeredLabel = UILabel()
        }
        let label = self._centeredLabel!
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        configuration(label)

        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 0.95, constant: 0))
        NSLayoutConstraint.activate(constraints)
    }

    func hideCenteredLabel() {
        _centeredLabel?.removeFromSuperview()
        _centeredLabel = nil
    }

}
