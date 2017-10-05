//
//  Algorithm.swift
//
//
//  Created by Yilei He on 14/04/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension Comparable {
    /**
     If self is greater than max, then self is equal to max
     
     - parameter max: maximum value
     */
    mutating func restrictValueToMaximum(_ max: Self) {
        self = min(self, max)
    }

    /**
     If self is smaller than min, then self is equal to min
     
     - parameter min: minimum value
     */
    mutating func restrictValueToMinimum(_ min: Self) {
        self = max(self, min)
    }

    /**
     If the receiver < right and reciver >= left, return true, else false
     
     - parameter left:  left boundary
     - parameter right: right boundary(not included)
     */
    func isBetween(_ left: Self, _ right: Self) -> Bool {
        return self < right && self >= left
    }

}

extension Bool {

    /// equivalent to: `flag = !flag`
    mutating func toggle() {
        self = !self
    }
}

// MARK: - Optional Assignment -

infix operator =? : AssignmentPrecedence
/**
 *  The optional assignment. If the right hand side value is nil, do nothing, else do assignment.
 */
func =?<T>(lhs:inout T, rhs: T?) {
    if let value = rhs {
        lhs = value
    }
}

/**
 *  The optional assignment. If the right hand side value is nil, do nothing, else do assignment.
 */
func =?<T>(lhs:inout T?, rhs: T?) {
    if let newValue = rhs {
        lhs = newValue
    }
}

// MARK: - Optional execution -
extension Optional {
    /**
     If the receiver is .Some(value), then call f(value). Else if the receiver is .None, then do nothing
    
     - parameter f: a closure in witch the wrapped value is passed if the receiver is not .None
     */
    func then(_ f: (_ value: Wrapped) throws -> Void) rethrows {
        if case let .some(value) = self {
            try f(value)
        }
    }
}

//// MARK: - enumerate enum Type -
///**
// This Generate a enumerate sequence for a enum Type
// Example:
// ```
// enum Suit:String {
// case Spades = "♠"
// case Hearts = "♥"
// case Diamonds = "♦"
// case Clubs = "♣"
// }
// for f in iterateEnum(Suit.self) {
// print(f.rawValue)
// }
// ```
// */
//func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
//    var i = 0
//    return AnyIterator {
//        defer { i += 1 }
//        let next = withUnsafePointer(to: &i) { UnsafeRawPointer($0).assumingMemoryBound(to: T.self).pointee }
//        return next.hashValue == i ? next : nil
//    }
//}

// MARK: - Random number -
extension UInt32 {
    static var random: UInt32 {
        return arc4random()
    }

    static func random(range: Range<UInt32>) -> UInt32 {
        return arc4random_uniform(range.upperBound - range.lowerBound) + range.lowerBound
    }
}

extension Int {
    static var random: Int {
        return Int(UInt32.random)
    }

    static func random(range: Range<UInt32>) -> Int {
        return Int(UInt32.random(range: range))
    }
}

struct Random {

    static func randomBytes(numberOfBytes: Int) -> [UInt8] {
        var randomBytes = [UInt8](repeating: 0, count: numberOfBytes) // array to hold randoms bytes
        _ = SecRandomCopyBytes(kSecRandomDefault, numberOfBytes, &randomBytes)
        return randomBytes

    }
    static func numberToRandom<T: ExpressibleByIntegerLiteral>(num: T) -> T {

        var num = num
        let randomBytes = Random.randomBytes(numberOfBytes: MemoryLayout<T>.size)
        // Turn bytes into data and pass data bytes into int
        NSData(bytes: randomBytes, length: MemoryLayout<T>.size).getBytes(&num, length: MemoryLayout<T>.size)
        return num
    }
    static func number64bit() -> UInt64 {

        return Random.numberToRandom(num: UInt64())  // variable for random unsigned 64
    }

    static func number32bit() -> UInt32 {
        return Random.numberToRandom(num: UInt32())  // variable for random unsigned 32
    }

    static func number16bit() -> UInt16 {

        return Random.numberToRandom(num: UInt16())  // variable for random unsigned 16
    }

    static func number8bit() -> UInt8 {

        return Random.numberToRandom(num: UInt8())  // variable for random unsigned 8
    }

    static func int() -> Int {

        return Random.numberToRandom(num: Int())  // variable for random Int
    }
    static func double() -> Double {

        return Random.numberToRandom(num: Double())  // variable for random Double
    }
    static func float() -> Float {

        return Random.numberToRandom(num: Float())  // variable for random Double
    }

}

// MARK: - power operator -
precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence

/// Exponentiation: return the rhs-th power of lhs
///
/// - parameter lhs: base
/// - parameter rhs: exponent
///
/// - returns: base raised to the power of exponent
func **(lhs: Int, rhs: Int) -> Int {
    return Int(pow(Double(lhs), Double(rhs)))
}

/// Exponentiation: return the rhs-th power of lhs
///
/// - parameter lhs: base
/// - parameter rhs: exponent
///
/// - returns: base raised to the power of exponent
func **(lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}

/// Exponentiation: return the rhs-th power of lhs
///
/// - parameter lhs: base
/// - parameter rhs: exponent
///
/// - returns: base raised to the power of exponent
func **(lhs: Float, rhs: Float) -> Float {
    return pow(lhs, rhs)
}

/// Exponentiation: return the rhs-th power of lhs
///
/// - parameter lhs: base
/// - parameter rhs: exponent
///
/// - returns: base raised to the power of exponent
func **(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
    return pow(lhs, rhs)
}

infix operator **= : AssignmentPrecedence

/// Exponentiation: get the rhs-th power of lhs and assign the value to lhs
///
/// - parameter lhs: base
/// - parameter rhs: exponent
func **=(lhs: inout Int, rhs: Int) {
    lhs = lhs ** rhs
}

/// Exponentiation: get the rhs-th power of lhs and assign the value to lhs
///
/// - parameter lhs: base
/// - parameter rhs: exponent
func **=(lhs: inout Double, rhs: Double) {
    lhs = lhs ** rhs
}

/// Exponentiation: get the rhs-th power of lhs and assign the value to lhs
///
/// - parameter lhs: base
/// - parameter rhs: exponent
func **=(lhs: inout Float, rhs: Float) {
    lhs = lhs ** rhs
}

/// Exponentiation: get the rhs-th power of lhs and assign the value to lhs
///
/// - parameter lhs: base
/// - parameter rhs: exponent
func **=(lhs: inout CGFloat, rhs: CGFloat) {
    lhs = lhs ** rhs
}

/* ************************** */
/* Implementation of power */
/* ************************** */
/*
func myPow(_ x: Double, _ n: Int) -> Double {
    var base = x
    var exp =  abs(n)
    var result = 1.0
    while exp > 0 {
        if exp & 1 > 0 {result *= base}
        exp >>= 1
        base *= base
    }
    return  n < 0 ? 1 / result : result
}
 //TODO: n is 1/3
 */

// MARK: - Binary -

extension Int {
    var binaryString: String {
        return String(self, radix: 2)
    }
}

// MARK: - OptionSet -

extension Int {
    init(bitComponents: [Int]) {
        self = bitComponents.reduce(0, +)
    }

    func bitComponents() -> [Int] {
        return (0 ..< 8*MemoryLayout<Int>.size).map({ 1 << $0 }).filter({ self & $0 != 0 })
    }
}

extension OptionSet where RawValue: UnsignedInteger {
    init(bitIndexes: [Int]) {
        let result = bitIndexes.reduce(UIntMax(0)) {
            $0 | 1 << UIntMax($1)
        }
        self.init(rawValue: RawValue(result))
    }
}

extension OptionSet where RawValue: SignedInteger {
    init(bitIndexes: [Int]) {
        let result = bitIndexes.reduce(IntMax(0)) {
            $0 | 1 << IntMax($1)
        }
        self.init(rawValue: RawValue(result))
    }

}

// MARK: - Type name -
func getTypeName(_ subject: Any) -> String {
    return getName(of: type(of: subject))
}

func getName(of type: Any.Type) -> String {
    return String(describing: type)
}
