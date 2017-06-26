//
//  String+Size.swift
//  PTPark
//
//  Created by CHEN KAIDI on 26/4/2017.
//
//

import Foundation

public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return CGFloat(ceilf(Float(boundingBox.height)))
    }
    
    func width(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return CGFloat(ceilf(Float(boundingBox.width)))
    }
    
    func size(withConstrainedWidth width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return CGSize(width: CGFloat(ceilf(Float(boundingBox.width))), height: CGFloat(ceilf(Float(boundingBox.height))))
    }
    
    
}
