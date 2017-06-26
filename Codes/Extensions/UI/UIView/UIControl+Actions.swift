//
//  UIControl+Actions.swift
//  PTPark
//
//  Created by soso on 2017/4/21.
//
//

import UIKit
import ObjectiveC

/*
 Support:
    touchDown
    touchDownRepeat
    touchUpInside
    touchUpOutside
    touchCancel
    valueChanged
    editingDidBegin
    editingChanged
    editingDidEnd
    editingDidEndOnExit
 */

typealias PTControlBlock = () -> Void

extension UIControl {
    
    // MARK: Public
    func bind(_ block: @escaping PTControlBlock, for event:UIControlEvents) -> UIControl {
        self._add(block, for: event)
        return self
    }
    
    func unBind(for event:UIControlEvents) -> UIControl {
        self._remove(for: event)
        return self
    }
    
    func end() {  }
    
    // MARK: Private
    fileprivate func _add(_ block: @escaping PTControlBlock, for event:UIControlEvents) {
        guard let action = self.action(for: event) else {
            return
        }
        var s = self._EventsBlocks
        s[event.rawValue] = block
        self._EventsBlocks = s
        self.addTarget(self, action: action, for: event)
    }
    
    fileprivate func _remove(for event:UIControlEvents) {
        guard let action = self.action(for: event) else {
            return
        }
        var s = self._EventsBlocks
        s.removeValue(forKey: event.rawValue)
        self._EventsBlocks = s
        self.removeTarget(self, action: action, for: event)
    }
    
    fileprivate static var _eventsBlocksKey = "_eventsBlocksKey"
    fileprivate var _EventsBlocks: [AnyHashable:Any] {
        get {
            guard let s = objc_getAssociatedObject(self, &UIControl._eventsBlocksKey) else {
                let result = [AnyHashable:Any]()
                objc_setAssociatedObject(self, &UIControl._eventsBlocksKey, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return result
            }
            return s as! [AnyHashable : Any]
        }
        set {
            objc_setAssociatedObject(self, &UIControl._eventsBlocksKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func action(for event: UIControlEvents) -> Selector? {
        switch event {
        case UIControlEvents.touchDown: return #selector(_touchDown)
        case UIControlEvents.touchDownRepeat: return #selector(_touchDownRepeat)
        case UIControlEvents.touchUpInside: return #selector(_touchUpInside)
        case UIControlEvents.touchUpOutside: return #selector(_touchUpOutside)
        case UIControlEvents.touchCancel: return #selector(_touchCancel)
        case UIControlEvents.valueChanged: return #selector(_valueChanged)
        case UIControlEvents.editingDidBegin: return #selector(_editingDidBegin)
        case UIControlEvents.editingChanged: return #selector(_editingChanged)
        case UIControlEvents.editingDidEnd: return #selector(_editingDidEnd)
        case UIControlEvents.editingDidEndOnExit: return #selector(_editingDidEndOnExit)
        default: return .none
        }
    }
    
    @objc fileprivate func _touchDown() {
        if let block = _EventsBlocks[UIControlEvents.touchDown.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _touchDownRepeat() {
        if let block = _EventsBlocks[UIControlEvents.touchDownRepeat.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _touchUpInside() {
        if let block = _EventsBlocks[UIControlEvents.touchUpInside.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _touchUpOutside() {
        if let block = _EventsBlocks[UIControlEvents.touchUpOutside.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _touchCancel() {
        if let block = _EventsBlocks[UIControlEvents.touchCancel.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _valueChanged() {
        if let block = _EventsBlocks[UIControlEvents.valueChanged.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _editingDidBegin() {
        if let block = _EventsBlocks[UIControlEvents.editingDidBegin.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _editingChanged() {
        if let block = _EventsBlocks[UIControlEvents.editingChanged.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _editingDidEnd() {
        if let block = _EventsBlocks[UIControlEvents.editingDidEnd.rawValue] as? PTControlBlock {
            block()
        }
    }
    
    @objc fileprivate func _editingDidEndOnExit() {
        if let block = _EventsBlocks[UIControlEvents.editingDidEndOnExit.rawValue] as? PTControlBlock {
            block()
        }
    }
    
}
