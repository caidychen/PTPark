//
//  UITabBar+BarItemViews.swift
//  AirPay
//
//  Created by Yilei on 20/1/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import UIKit

extension UITabBar {
    var tabBarButtons: [UIView] {
        let views = subviews.filter { String(reflecting: type(of:$0)) == "UITabBarButton"}
        return views.sorted {$0.frame.origin.x < $1.frame.origin.x}
    }
}
