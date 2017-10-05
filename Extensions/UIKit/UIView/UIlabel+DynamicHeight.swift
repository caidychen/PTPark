//
//  UIlabel+DynamicHeight.swift
//
//  Created by HeYilei on 27/01/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UILabel {

    /**
     Calculate the height of lable based on given width and text
     
     - parameter width: The width of label
     
     - returns: The expected height of the label
     */
    func heightWithWidth(_ width: CGFloat) -> CGFloat {
        guard let text = text else {
            return 0
        }
        return text.heightWithWidth(width, font: font)
    }

    /**
     Calculate the height of the label based on given width and attributed text
     
     - parameter width: The width of label
     
     - returns: The expected height of label
     */
    func heightWithAttributedWidth(_ width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.heightWithWidth(width)
    }

}
