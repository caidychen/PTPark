//
//  NumberUtils.swift
//
//
//  Created by Yilei He on 14/04/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

private let numberFormatter = NumberFormatter()

// MARK: - Currency -
extension Double {

    func formattedString(decimals: Int, numberStyle: NumberFormatter.Style, prefixPlusSign: Bool = false, locale: Locale? = nil) -> String? {

        numberFormatter.numberStyle = numberStyle

        numberFormatter.maximumFractionDigits = decimals
        numberFormatter.minimumFractionDigits = decimals

        if numberStyle == .currency {
            numberFormatter.positivePrefix = prefixPlusSign ? "+$" : "$"
        } else {
            numberFormatter.positivePrefix = prefixPlusSign ? "+" : ""
        }

        if let locale = locale {
            numberFormatter.locale = locale
        } else {
            numberFormatter.locale = Locale.current
        }

        return numberFormatter.string(from: NSNumber(value: self))
    }

}

extension Int {

    func formattedString(decimals: Int, numberStyle: NumberFormatter.Style, prefixPlusSign: Bool = false, locale: Locale? = nil) -> String? {
        return Double(self).formattedString(decimals: decimals, numberStyle: numberStyle, prefixPlusSign: prefixPlusSign, locale: locale)
    }

    func ordinal() -> String {
        switch self < 20 ? self : self%10 {
        case 1:
            return "st"
        case 2:
            return "nd"
        case 3:
            return "rd"
        default:
            return "th"
        }
    }
}

extension Int {
    var displayCurrency: String {
        return Double(self).displayCurrency
    }
}

extension Double {
    var displayCurrency: String {
        return (self / 100).formattedString(decimals: 2, numberStyle: .currency)!//This is commentted out because the below line is faster
        //return String(format: "$%.2f", (self / 100))//This is commented out because the above line displays negatives correctly.
    }
    
    var hasDecimal: Bool {
        return (self - floor(self) > 0.000001)  // 0.000001 can be changed depending on the level of precision you need
    }
}

extension Double {
    var smartFormattedString: String {
         let numberFormatter = NumberFormatter()
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
