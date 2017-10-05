//
//  UIView+getUIViewController.swift
//  Swift3Project
//
//  Created by Yilei He on 12/12/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder = next
        while let next = nextResponder {
            if let vc = next as? UIViewController {
                return vc
            }
            nextResponder = next.next
        }
        return nil
    }
}
