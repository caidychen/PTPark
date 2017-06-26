//
//  NSObject+Values.swift
//  PTPark
//
//  Created by soso on 2017/4/21.
//
//

import Foundation
import ObjectiveC

fileprivate struct _PTObjectValues {
    static var ptTag    = "ptTag"
    static var ptInfo   = "ptInfo"
}

extension NSObject {
    
    var ptTag: Int {
        get {
            return objc_getAssociatedObject(self, &_PTObjectValues.ptTag) as! Int
        }
        set {
            objc_setAssociatedObject(self, &_PTObjectValues.ptTag, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    var ptInfo: [AnyHashable:Any] {
        get {
            return objc_getAssociatedObject(self, &_PTObjectValues.ptInfo) as! [AnyHashable : Any]
        }
        set {
            objc_setAssociatedObject(self, &_PTObjectValues.ptInfo, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
}

extension NSObject {
    
    func mainDelay(_ second: TimeInterval, _ callback: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.microseconds(Int(1000 * second)), execute: callback)
    }
    
    func globalDelay(_ second: TimeInterval, _ callback: @escaping () -> ()) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.microseconds(Int(1000 * second)), execute: callback)
    }
    
}

extension Int {
    func repeating(_ block: () -> ()) {
        for _ in 0..<self {
            block()
        }
    }
}
