//
//  UIApplication+TopMostViewController.swift
//  AirPay
//
//  Created by KD Chen on 5/9/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import UIKit

extension UIApplication {
    static var topViewController: UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
