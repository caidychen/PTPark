//
//  UIApplication+ViewController.swift
//  PTPark
//
//  Created by soso on 2017/6/13.
//
//

import UIKit

extension UIApplication {
    
    func currentViewController() -> UIViewController? {
        guard let rootVC = self.keyWindow?.rootViewController else {
            return nil
        }
        if let navVC = rootVC as? UINavigationController {
            return navVC.topViewController
        }
        if let tabBarVC = rootVC as? UITabBarController {
            let selectedVC = tabBarVC.selectedViewController
            if let slVC = selectedVC as? UINavigationController {
                return slVC.topViewController
            }
            return selectedVC
        }
        return rootVC
    }
    
}
