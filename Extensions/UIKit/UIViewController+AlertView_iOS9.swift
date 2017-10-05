//
//  UIViewController+AlertView.swift
//  Swift3Project
//
//  Created by Yilei on 28/4/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import Foundation
private var alertViewHandlerAssociationKey: UInt8 = 0
extension UIViewController: UIAlertViewDelegate {
    @available(iOS, deprecated: 10, message: "This method is deprecated, use showAlert() instead")
    func showAlertView(title: String, message: String, cancelButtonTitle: String, actionTitle: String, actionHandler: ((UIAlertView, Int) -> Void)? = nil) {
        let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelButtonTitle)
        alertView.addButton(withTitle: actionTitle)
        alertView.show()
        guard let actionHandler = actionHandler else {
            return
        }

        objc_setAssociatedObject(self, &alertViewHandlerAssociationKey, _HandlerWrapper(closure: actionHandler), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if let handlerWrapper = objc_getAssociatedObject(self, &alertViewHandlerAssociationKey) as? _HandlerWrapper {
            handlerWrapper.closure(alertView, buttonIndex)
            objc_setAssociatedObject(self, &alertViewHandlerAssociationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private class _HandlerWrapper {
    let closure: (UIAlertView, Int) -> Void
    init(closure: @escaping (UIAlertView, Int) -> Void) {
        self.closure = closure
    }
}
