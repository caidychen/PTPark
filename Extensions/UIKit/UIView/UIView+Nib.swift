//
//  UIView+Nib.swift
//  AirPay
//
//  Created by Yilei on 16/1/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import UIKit

extension UIView {
    static func view(fromNib nibName: String) -> UIView? {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }
}
