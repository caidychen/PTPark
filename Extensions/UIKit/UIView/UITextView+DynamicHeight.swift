//
//  UITextView + DynamicHeight.swift
//
//
//  Created by Yilei He on 15/04/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UITextView {

    func heightWithWidth(_ width: CGFloat) -> CGFloat {
        return self.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }

    var dynamicHeight: CGFloat {
        return self.sizeThatFits(self.frame.size).height
    }

}
