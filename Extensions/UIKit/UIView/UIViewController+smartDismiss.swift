//
//  UIViewController+smartDismiss.swift
//  Swift3Project
//
//  Created by Yilei on 11/4/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import UIKit

extension UIViewController {
    open func smartDismiss(animated: Bool, completion: (() -> Void)? = nil) {
        if let navigationController = navigationController, let lastVC = navigationController.viewControllers.last, lastVC == self {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: animated)
            } else {
                navigationController.dismiss(animated: animated, completion: completion)
            }
        } else {
            self.dismiss(animated: animated, completion: completion)
        }
    }
}
