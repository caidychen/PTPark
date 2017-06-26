//
//  NSAttributedString+Attributes.swift
//  PTPark
//
//  Created by soso on 2017/5/8.
//
//

import Foundation

extension String {
    
    func setFont(_ font: UIFont, for range: NSRange?) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: self)
        guard let r = range else {
            return text
        }
        text.addAttributes([NSFontAttributeName:font], range: r)
        return text
    }
    
    func setTextColor(_ color: UIColor, for range: NSRange?) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: self)
        guard let r = range else {
            return text
        }
        text.addAttributes([NSForegroundColorAttributeName:color], range: r)
        return text
    }
    
    func setStyle(_ alignment: NSTextAlignment, _ lineSpacing: CGFloat?, for range: NSRange?) ->
        NSMutableAttributedString {
            let text = NSMutableAttributedString(string: self)
            guard let r = range else {
                return text
            }
            let style = NSMutableParagraphStyle()
            style.alignment = alignment
            if let sp = lineSpacing {
                style.lineSpacing = sp
            }
            text.addAttributes([NSParagraphStyleAttributeName:style], range: r)
            return text
    }
    
}

public extension NSAttributedString {
    
    func attributedString(alignment: NSTextAlignment, for range: NSRange?) -> NSMutableAttributedString {
        let mAttString = NSMutableAttributedString(attributedString: self)
        guard let `range` = range else {
            mAttString.setAlignment(alignment, for: NSRange(location: 0, length: self.length))
            return mAttString
        }
        mAttString.setAlignment(alignment, for: range)
        return mAttString
    }
    
    func attributedString(lineSpacing: CGFloat, for range: NSRange?) -> NSMutableAttributedString {
        let mAttString = NSMutableAttributedString(attributedString: self)
        guard let `range` = range else {
            mAttString.setLineSpace(lineSpacing, for: NSRange(location: 0, length: self.length))
            return mAttString
        }
        mAttString.setLineSpace(lineSpacing, for: range)
        return mAttString
    }
    
    func attributedString(alignment: NSTextAlignment, lineSpacing: CGFloat, for range: NSRange?) -> NSMutableAttributedString {
        let mAttString = NSMutableAttributedString(attributedString: self)
        guard let `range` = range else {
            mAttString.setAlignment(alignment, for: NSRange(location: 0, length: self.length))
            mAttString.setLineSpace(lineSpacing, for: NSRange(location: 0, length: self.length))
            return mAttString
        }
        mAttString.setAlignment(alignment, for: range)
        mAttString.setLineSpace(lineSpacing, for: range)
        return mAttString
    }
    
    func attributedString(textColor: UIColor, for range: NSRange?) -> NSMutableAttributedString {
        let mAttString = NSMutableAttributedString(attributedString: self)
        guard let `range` = range else {
            mAttString.setTextColor(textColor, for: NSRange(location: 0, length: self.length))
            return mAttString
        }
        mAttString.setTextColor(textColor, for: range)
        return mAttString
    }
    
}

public extension NSMutableAttributedString {
    
    func setAlignment(_ alignment: NSTextAlignment, for range: NSRange?) {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        let att = [NSParagraphStyleAttributeName:style]
        guard let r = range else {
            self.addAttributes(att, range: NSRange(location: 0, length: self.length))
            return
        }
        self.addAttributes(att, range: r)
    }
    
    func setLineSpace(_ lineSpacing: CGFloat, for range: NSRange?) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        let att = [NSParagraphStyleAttributeName:style]
        guard let r = range else {
            self.addAttributes(att, range: NSRange(location: 0, length: self.length))
            return
        }
        self.addAttributes(att, range: r)
    }
    
    func setAlignment(_ alignment: NSTextAlignment, _ lineSpacing: CGFloat, for range: NSRange?) {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineSpacing = lineSpacing
        let att = [NSParagraphStyleAttributeName:style]
        guard let r = range else {
            self.addAttributes(att, range: NSRange(location: 0, length: self.length))
            return
        }
        self.addAttributes(att, range: r)
    }
    
    func setTextColor(_ color: UIColor, for range: NSRange?) {
        let att = [NSForegroundColorAttributeName:color]
        guard let r = range else {
            self.addAttributes(att, range: NSRange(location: 0, length: self.length))
            return
        }
        self.addAttributes(att, range: r)
    }
    
}
