//
//  UIView+convertConstraintsToAnotherView.swift
//  Swift3Project
//
//  Created by Yilei He on 7/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

/* Tested: Xcode 9 beta, Swift 4 */
import UIKit

extension UIView {
    public func transferConstraint(_ original: NSLayoutConstraint, to substitude: UIView, excludingDescendantConstraints: Bool = true) -> NSLayoutConstraint? {

        var firstItem: AnyObject? = nil

        if  let originalFirstItem = original.firstItem as? NSObject,
            let originalSecondItem = original.secondItem as? UIView,
            originalFirstItem == self {

            let situation1 = (excludingDescendantConstraints && (!originalSecondItem.isDescendant(of: self) || originalSecondItem == self))//second item is: a sibling/super view/itself while the first item is itself
            let situation2 = !excludingDescendantConstraints

            if situation1 || situation2 {
                firstItem = substitude
            }
        }

        var secondItem: AnyObject? = nil

        if  let originalSecondItem = original.secondItem as? NSObject,
            let originalFirstItem = original.firstItem as? UIView,
            originalSecondItem == self {

            let situation1 = (excludingDescendantConstraints && (!originalFirstItem.isDescendant(of: self) || originalFirstItem == self))
            let situation2 = !excludingDescendantConstraints

            if situation1 || situation2 {
                secondItem = substitude
            }
        }

        if firstItem == nil && secondItem == nil {
            return nil
        }

        return NSLayoutConstraint(item: firstItem ?? original.firstItem as Any,
                                  attribute: original.firstAttribute,
                                  relatedBy: original.relation,
                                  toItem: secondItem ?? original.secondItem,
                                  attribute: original.secondAttribute,
                                  multiplier: original.multiplier,
                                  constant: original.constant)

    }

    public func transferConstraints(to substitude: UIView, excludingDescendantConstraints: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("The view \(self.debugDescription) is not added to view hierarchy yet!")
        }

        return (constraints + superview.constraints).flatMap {
            transferConstraint($0,
                               to: substitude,
                               excludingDescendantConstraints: excludingDescendantConstraints)
        }
    }
}
