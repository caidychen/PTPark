//
//  UIViewControllerExtension.swift
//  PTPark
//
//  Created by Chunlin on 2017/5/6.
//
//

import UIKit
import PKHUD

extension UIViewController {
    class func initWithClass<T: UIViewController>(_ className: T.Type) -> T {
        return T(nibName: String(describing: className), bundle: nil)
    }
}
