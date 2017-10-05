//
//  UIViewController+Storyboard.swift
//  Swift3Project
//
//  Created by Yilei He on 15/12/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Convenience function for Instantiating view controller in the "Main" storyboard
     */
    static func viewControllerInMainStoryboard(withIdentifier identifier: String?) -> UIViewController {
        return UIViewController.viewController(inStoryboard: "Main", withIdentifier: identifier)
    }

    /**
     Instantiate a instance of UIViewController in the storyboard
     */
    static func viewController(inStoryboard storyboard: String, withIdentifier identifier: String?) -> UIViewController {
        if let identifier = identifier {
            return UIStoryboard(name:storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        } else {
            let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateInitialViewController()
            precondition(vc != nil, "Can't find initial view controller in the \"\(storyboard)\" storyboard.")
            return vc!
        }
    }
}
