//
//  UIView+hideKeyboard.swift
//  Swift3Project
//
//  Created by Yilei He on 6/12/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UIView {
    public func addTapToHideKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(private_viewDidTapped(tap:)))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc private func private_viewDidTapped(tap: UITapGestureRecognizer) {
        endEditing(false)
    }
}
