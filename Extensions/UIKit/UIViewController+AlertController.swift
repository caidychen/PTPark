//
//  UIViewController+AlertController.swift
//
//
//  Created by HeYilei on 23/09/2015.
//  Copyright © 2015 HeYilei. All rights reserved.
//

import UIKit

extension UIViewController {

    /**
     Shows an alert view displaying title and message
     */
    func showAlert(title: String?, message: String?, actionTitle: String? = "OK") {
        if #available(iOS 10.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: actionTitle)
            alertView.show()
        }
    }

    /**
     Shows an alert view displaying the loaclized description of a NSError object
     
     - parameter title: title used for alert view
     - parameter error: NSError object
     */
    func showAlert(title: String?, error: Error?) {
        showAlert(title: title, message: error?.localizedDescription)
    }

    func showConfirmAlert(title: String?, message: String?, cancelButtonTitle: String? = "Cancel", confirmButtonTitle: String? = "OK", reverseButtonOrder: Bool = false, cancelActionHandler: ((UIAlertAction) -> Void)?, confirmActionHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel, handler: cancelActionHandler)
        let confirmAction = UIAlertAction(title: confirmButtonTitle, style: UIAlertActionStyle.default, handler: confirmActionHandler)
        if reverseButtonOrder {
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
        } else {
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Another Design -
extension UIViewController {
    func showConfirmAlert(title: String?, message: String?) -> ConfirmAlertControllerSetter {
        return ConfirmAlertControllerSetter(viewController:self, title: title, message: message)
    }
}

class ConfirmAlertControllerSetter: NSObject {
    enum ActionType {
        case confirm
        case cancel
    }
    private let viewController: UIViewController
    private var title: String?
    private var message: String?
    private var cancelButtonTitle: String? = "Cancel"
    private var confirmButtonTitle: String? = "OK"
    private var cancelActionHandler: ((UIAlertAction) -> Void)?
    private var confirmActionHandler: ((UIAlertAction) -> Void)?
    private var preferredAction: ActionType = .cancel
    private var confirmActionStyle: UIAlertActionStyle = .default

    fileprivate init(viewController: UIViewController, title: String?, message: String?) {
        self.viewController = viewController
        self.title = title
        self.message = message
    }

    @discardableResult
    func setButtonTitle(cancelButtonTitle: String?, confirmButtonTitle: String?) -> ConfirmAlertControllerSetter {
        self.cancelButtonTitle = cancelButtonTitle
        self.confirmButtonTitle = confirmButtonTitle
        return self
    }

    @discardableResult
    func setCancelActionHandler(_ cancelActionHandler: ((UIAlertAction) -> Void)?) -> ConfirmAlertControllerSetter {
        self.cancelActionHandler = cancelActionHandler
        return self
    }

    @discardableResult
    func setConfirmActionHandler(_ confirmActionHandler: ((UIAlertAction) -> Void)?) -> ConfirmAlertControllerSetter {
        self.confirmActionHandler = confirmActionHandler
        return self
    }

    @discardableResult
    func setPreferredAction(_ action: ActionType) -> ConfirmAlertControllerSetter {
        self.preferredAction = action
        return self
    }

    @discardableResult
    func setConfirmActionStyle(_ style: UIAlertActionStyle) -> ConfirmAlertControllerSetter {
        self.confirmActionStyle = style
        return self
    }

    deinit {
        if #available(iOS 10.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel, handler: cancelActionHandler)
            let confirmAction = UIAlertAction(title: confirmButtonTitle, style: confirmActionStyle, handler: confirmActionHandler)
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            switch preferredAction {
            case .cancel:
                alertController.preferredAction = cancelAction
            case .confirm:
                alertController.preferredAction = confirmAction
            }
            viewController.present(alertController, animated: true, completion: nil)
        } else {
            let confirmHandler = self.confirmActionHandler
            let cancelHandler = self.cancelActionHandler
            viewController.showAlertView(title: title ?? "", message: message ?? "", cancelButtonTitle: cancelButtonTitle ?? "", actionTitle: confirmButtonTitle ?? "", actionHandler: { (alertView, index) in
                if index == 1 {
                    confirmHandler?(UIAlertAction(title: "", style: .default, handler: nil))
                } else if index == alertView.cancelButtonIndex {
                    cancelHandler?(UIAlertAction(title: "", style: .cancel, handler: nil))
                }
            })
        }
    }
}
