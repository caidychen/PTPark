//
//  AutorisizingMask+All.swift
//  AirPay
//
//  Created by Yilei on 16/1/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import UIKit
extension UIViewAutoresizing {
    static let fixedAllMarginFlexibleSize: UIViewAutoresizing = [.flexibleWidth, .flexibleHeight]
    static let flexibleAllMarginFixedSize: UIViewAutoresizing = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
    static let pinToCenter: UIViewAutoresizing = .flexibleAllMarginFixedSize
    static let flexibleAll: UIViewAutoresizing = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
}
