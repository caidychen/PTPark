//
//  NSArray+Safe.swift
//  PTPark
//
//  Created by soso on 2017/4/26.
//
//

import UIKit

extension Array {
    
    func safeObject(at index: Int) -> Any? {
        if index < 0 {
            return .none
        }
        if self.count == 0 {
            return .none
        }
        if index > Swift.max(self.count - 1, 0) {
            return .none
        }
        return self[index]
    }
    
    mutating func safeAdd(_ object: Element?) {
        if let obj = object {
            self.append(obj)
        }
    }
    
    mutating func safeInsert(_ object: Element?, at index: Int) {
        if index < 0 {
            return
        }
        if index > Swift.max(Int(self.count) - 1, 0) {
            return
        }
        if let obj = object {
            self.insert(obj, at: index)
        }
    }
    
    mutating func safeRemove(at index: Int) {
        if index < 0 {
            return
        }
        if index > Swift.max(Int(self.count) - 1, 0) {
            return
        }
        self.remove(at: index)
    }
    
}
