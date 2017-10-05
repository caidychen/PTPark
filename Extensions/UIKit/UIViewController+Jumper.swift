//
//  ViewController+Jumper.swift
//  AirPay
//
//  Created by KD Chen on 8/9/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func goToCardPaymentsViewController() {
        let index = tabBarController!.viewControllers!.count - 1
        tabBarController?.selectedIndex = index
        guard let navVC = tabBarController?.viewControllers?[index] as? UINavigationController else {
            return
        }
        navVC.popToRootViewController(animated: false)
        let vc = UIViewController.viewController(inStoryboard: "CloudEftpos", withIdentifier: "CloudEftpos_dashboard") as! CloudEftposDashboardViewController
        navVC.pushViewController(vc, animated: true)
    }
}

