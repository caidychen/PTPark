//
//  UIApplication+firstResponder.swift
//  Swift3Project
//
//  Created by Yilei on 15/5/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import UIKit

private class FirstResponderFetcherEvent: UIEvent {
    fileprivate weak var firstResponder: UIResponder?
}

extension UIResponder {
    @objc fileprivate func fetchFirstResponder(sender: Any?, event: FirstResponderFetcherEvent) {
        event.firstResponder = self
    }
}

extension UIApplication {
    var firstResponder: UIResponder? {
        let event = FirstResponderFetcherEvent()
        UIApplication.shared.sendAction(#selector(UIResponder.fetchFirstResponder(sender:event:)), to: nil, from: nil, for: event)
        return event.firstResponder
    }
}
