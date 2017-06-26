//
//  PTAttributeTextTool.swift
//  PTPlanet
//
//  Created by CHEN KAIDI on 20/2/2017.
//  Copyright © 2017 putao. All rights reserved.
//

import UIKit

class PTAttributeTextTool: NSObject {

    class func initAttributeText(text:String, lineSpacing:CGFloat, font:UIFont, textAlignment:NSTextAlignment) -> NSAttributedString{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAlignment
        let attrString = NSMutableAttributedString(string:text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, attrString.length))
        return attrString
    }
    
}
