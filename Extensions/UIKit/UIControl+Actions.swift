//
//  UIControl+Actions.swift
//  AirPay
//
//  Created by KD Chen on 28/8/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import UIKit
import ObjectiveC

typealias PTControlBlock = () -> Void

extension UIControl {

    // The extension provides shortcut functions for addTarget() method to all UIControl based components
 
    // MARK: Public
    @discardableResult func bind(_ block: @escaping PTControlBlock, for event: UIControlEvents) -> UIControl {
        self.add(block, for: event)
        return self
    }

    @discardableResult func unBind(for event: UIControlEvents) -> UIControl {
        self.remove(for: event)
        return self
    }

    // MARK: Private
    fileprivate func add(_ block: @escaping PTControlBlock, for event: UIControlEvents) {
        guard let action = self.action(for: event) else {
            return
        }
        var s = self.EventsBlocks
        s[event.rawValue] = block
        self.EventsBlocks = s
        self.addTarget(self, action: action, for: event)
    }

    fileprivate func remove(for event: UIControlEvents) {
        guard let action = self.action(for: event) else {
            return
        }
        var s = self.EventsBlocks
        s.removeValue(forKey: event.rawValue)
        self.EventsBlocks = s
        self.removeTarget(self, action: action, for: event)
    }

    fileprivate static var eventsBlocksKey = "eventsBlocksKey"
    fileprivate var EventsBlocks: [AnyHashable:Any] {
        get {
            guard let s = objc_getAssociatedObject(self, &UIControl.eventsBlocksKey) else {
                let result = [AnyHashable: Any]()
                objc_setAssociatedObject(self, &UIControl.eventsBlocksKey, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return result
            }
            return s as! [AnyHashable : Any]
        }
        set {
            objc_setAssociatedObject(self, &UIControl.eventsBlocksKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    fileprivate func action(for event: UIControlEvents) -> Selector? {
        switch event {
        case UIControlEvents.touchDown: return #selector(touchDown)
        case UIControlEvents.touchDownRepeat: return #selector(touchDownRepeat)
        case UIControlEvents.touchUpInside: return #selector(touchUpInside)
        case UIControlEvents.touchUpOutside: return #selector(touchUpOutside)
        case UIControlEvents.touchCancel: return #selector(touchCancel)
        case UIControlEvents.valueChanged: return #selector(valueChanged)
        case UIControlEvents.editingDidBegin: return #selector(editingDidBegin)
        case UIControlEvents.editingChanged: return #selector(editingChanged)
        case UIControlEvents.editingDidEnd: return #selector(editingDidEnd)
        case UIControlEvents.editingDidEndOnExit: return #selector(editingDidEndOnExit)
        default: return .none
        }
    }

    @objc fileprivate func touchDown() {
        if let block = EventsBlocks[UIControlEvents.touchDown.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func touchDownRepeat() {
        if let block = EventsBlocks[UIControlEvents.touchDownRepeat.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func touchUpInside() {
        if let block = EventsBlocks[UIControlEvents.touchUpInside.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func touchUpOutside() {
        if let block = EventsBlocks[UIControlEvents.touchUpOutside.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func touchCancel() {
        if let block = EventsBlocks[UIControlEvents.touchCancel.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func valueChanged() {
        if let block = EventsBlocks[UIControlEvents.valueChanged.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func editingDidBegin() {
        if let block = EventsBlocks[UIControlEvents.editingDidBegin.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func editingChanged() {
        if let block = EventsBlocks[UIControlEvents.editingChanged.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func editingDidEnd() {
        if let block = EventsBlocks[UIControlEvents.editingDidEnd.rawValue] as? PTControlBlock {
            block()
        }
    }

    @objc fileprivate func editingDidEndOnExit() {
        if let block = EventsBlocks[UIControlEvents.editingDidEndOnExit.rawValue] as? PTControlBlock {
            block()
        }
    }

}
