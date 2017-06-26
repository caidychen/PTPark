//
//  PTScheduleManager.swift
//  PTPark
//
//  Created by soso on 2017/4/21.
//
//

import UIKit

fileprivate class PTScheduleItem {
    var interval: Int
    var action: (Int) -> Void
    var totalTimes: Int = 0
    var current: Int = Int.max
    init(_ current: Int, _ interval: Int, _ action: @escaping (Int) -> Void) {
        self.current = current
        self.interval = interval
        self.action = action
    }
}

class PTScheduleManager {
    
    static let manager = PTScheduleManager()
    
    init() {
        self.timer = Timer(fireAt: Date.distantFuture, interval: 1.0, target: self, selector: #selector(timerScheduled), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: .commonModes)
    }
    
    // MARK: Public
    public func removeAll() {
        self.queue.async {
            self.timer.fireDate = Date.distantFuture
            self.values.removeAll()
        }
    }
    
    public func remove(forKey key: AnyHashable) {
        self.queue.async {
            self.values.removeValue(forKey: key)
            if self.values.count == 0 {
                self.timer.fireDate = Date.distantFuture
            }
        }
    }
    
    public func add(_ block: @escaping (_ current: Int) -> Void, _ interval: Int, forKey key: AnyHashable) {
        self.add(block, Int.max, interval, forKey: key, false)
    }
    
    public func add(_ block: @escaping (_ current: Int) -> Void, _ current: Int, _ interval: Int, forKey key: AnyHashable) {
        self.add(block, current, interval, forKey: key, false)
    }
    
    public func add(_ block: @escaping (_ current: Int) -> Void, _ current: Int, _ interval: Int, forKey key: AnyHashable, _ fireNow: Bool = false) {
        self.queue.async {
            let item = PTScheduleItem(current, interval, block)
            if fireNow {
                item.action(item.current)
                item.totalTimes += 1
            }
            self.values[key] = item
            if self.timer.isValid {
                self.timer.fireDate = Date()
            }
        }
    }
    
    // MARK: Private
    fileprivate var values = [AnyHashable : PTScheduleItem]()
    fileprivate var timer: Timer!
    fileprivate var queue = DispatchQueue(label: "com.putao.store.timeschedule.queue")
    
    @objc fileprivate func timerScheduled() {
        self.queue.async {
            var removeKeys = [AnyHashable]()
            self.values.forEach({ (key, value) in
                if value.current < 1 {
                    removeKeys.append(key)
                } else {
                    value.totalTimes += 1
                    value.current -= 1
                    if value.totalTimes % value.interval == 0 {
                        value.action(value.current)
                    }
                }
            })
            removeKeys.forEach({ (key) in
                self.remove(forKey: key)
            })
        }
    }
    
}
