//
//  UITextField+Done.swift
//  Swift3Project
//
//  Created by Yilei on 31/3/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import UIKit

extension UITextField {
    public func attachDoneButtonToKeyboard() {
        inputAccessoryView = accessoryViewWithDoneButton(for: self)
    }
}

extension UITextView {
    public func attachDoneButtonToKeyboard() {
        inputAccessoryView = accessoryViewWithDoneButton(for: self)
    }
}

extension UISearchBar {
    public func attachDoneButtonToKeyboard() {
        inputAccessoryView = accessoryViewWithDoneButton(for: self)
        self.responds(to: #selector(setter: inputAccessoryView))
    }
}

private func accessoryViewWithDoneButton(for target: UIView) -> UIView {
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    toolBar.items = [
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(UIResponder.resignFirstResponder))
    ]
    return toolBar
}
