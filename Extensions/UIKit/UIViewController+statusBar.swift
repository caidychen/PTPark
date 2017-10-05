//
//  UIViewController+statusBar.swift
//  Swift3Project
//
//  Created by Yilei He on 7/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UIViewController {
    var navigationBarHeight: CGFloat {
        return navigationController?.navigationBar.frame.height ?? 0
    }

    var statusBarHeight: CGFloat {
        return UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
    }

    var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.height ?? 0
    }

    var navigationBarItemTitleView: UIView? {
        return navigationController?.navigationBar.subviews.filter {String(describing: type(of: $0)) == "UINavigationItemView"}.first
    }

    var statusBar: UIView? {
        return UIApplication.shared.statusBarView
    }
}
