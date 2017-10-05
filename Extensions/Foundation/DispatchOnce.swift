//
//  DispatchOnce.swift
//  AirPay
//
//  Created by Geoff Speirs on 27/7/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import Foundation

/**
 Referecnce: https://stackoverflow.com/a/39983813/1586277
 */
public extension DispatchQueue {

    private static var _onceTracker = [String]()

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    @discardableResult
    public class func once(token: String, block:() -> Void) -> Bool {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return false
        }

        _onceTracker.append(token)
        block()
        return true
    }

    @discardableResult
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:() -> Void) -> Bool {
        let token = file + ":" + function + ":" + String(line)
        return once(token: token, block: block)
    }
}
