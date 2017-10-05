//
//  NSLayoutConstraints.ext.swift
//  Swift3Project
//
//  Created by Yilei He on 15/12/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    static func equivalentFrame(parentView: UIView, childView: UIView) -> [NSLayoutConstraint] {
        precondition(childView.isDescendant(of: parentView) && childView !== parentView, "childe view is not subview of parent view")
        childView.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: childView, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: childView, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0))
        return constraints
    }
}
