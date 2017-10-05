//
//  UIColor.ext.swift
//  Swift3Project
//
//  Created by Yilei He on 13/12/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

extension UIColor {
    /* From https://github.com/hyperoslo/Hue */
    convenience init?(hex string: String) {
        var hex = string.hasPrefix("#")
            ? String(string.characters.dropFirst())
            : string
        guard hex.characters.count == 3 || hex.characters.count == 6 else {return nil}

        if hex.characters.count == 3 {
            for (index, char) in hex.characters.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }

        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
    }

    /* From https://github.com/hyperoslo/Hue */
    public func hex(withPrefix: Bool = true) -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)

        let prefix = withPrefix ? "#" : ""

        return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    /// A convenience initializer that uses a value out of 255
    ///
    /// - Parameters:
    ///   - r: A value between [0, 255]
    ///   - g: A value between [0, 255]
    ///   - b: A value between [0, 255]
    ///   - a: A value between [0, 1]
    static func rgbaBytes(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    /// Make a brighter color. The new color's brightness is calculated by oldBrightness * (1 + percentage)
    ///
    /// - Parameter percentage: this value should be in the range [0, 1.0]
    /// - Returns: a brighter color
    func brightened(by percentage: CGFloat) -> UIColor? {
        guard let (hue, saturation, brightness, alpha) = getHueSaturationBrightnessAlpha() else {
            return nil
        }

        return UIColor(hue: hue, saturation: saturation, brightness: brightness * (1 + percentage), alpha: alpha)
    }

    /// Make a darker color. The new color's brightness is calculated by oldBrightness * (1 - percentage)
    ///
    /// - Parameter percentage: this value should be in the range [0, 1.0]
    /// - Returns: a darker color
    func darkened(by percentage: CGFloat) -> UIColor? {
        return brightened(by: -percentage)
    }

    func getHueSaturationBrightnessAlpha() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return (hue, saturation, brightness, alpha)
        }
        return nil
    }

    /// This method adjust the hue value of a color
    ///
    /// - Parameter offset: The offset value could be any between -1.0 and 1.0
    /// - Returns: A new color
    func withHueAdjusted(offset: CGFloat) -> UIColor? {
        guard let (hue, saturation, brightness, alpha) = getHueSaturationBrightnessAlpha() else {
            return nil
        }

        return UIColor(hue: hue + offset, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}


