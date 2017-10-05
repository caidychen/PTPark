//
//  String Convenience Extensions.swift
//  Swift3Project
//
//  Created by Yilei He on 7/11/16.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

// MARK: - Objective-C Style API -
extension String {
    /**
     Migrate the method of NSString.length to String in swift.
     
     It just returns self.characters.count
     */
    public var length: Int {return self.characters.count}

    /**
     Get the character at specific position in the receiver
     
     - parameter i: index of the character
     
     - returns: An instance of Character
     */
    public subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }

    /**
     Get the string at specific position in the receiver
     
     - parameter i: index of the string
     
     - returns: A string with only one character
     */
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    /**
     Get the string in the range
     
     - parameter r: The range used to retrieve string
     
     - returns: The result string
     */
    public subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(startIndex, offsetBy: r.upperBound)
        return self[start ..< end]
    }

    /// First Character of string
    public var initial: String {
        return isEmpty ? "" : String(characters.first!)
    }

    /// Capitalize first character
    public var withInitialCapitalized: String {
        if characters.count <= 1 {
            return initial.uppercased()
        } else {
            return initial.uppercased() + substring(from: index(after: startIndex))
        }
    }

    public func substring(from offset: String.IndexDistance) -> String {
        if self.characters.count < offset { return "" }
        return substring(from: index(startIndex, offsetBy: offset))
    }

    public func substring(to offset: String.IndexDistance) -> String {
        if self.characters.count < offset { return self }
        return substring(to: index(startIndex, offsetBy: offset))
    }

    public func substring(with aRange: Range<String.IndexDistance>) -> String {
        let start = index(startIndex, offsetBy: aRange.lowerBound)
        let end = index(startIndex, offsetBy: aRange.upperBound)
        let range = start..<end
        return substring(with: range)
    }

}

// MARK: - Bridging to NSRange -
extension String {

    public var fullRange: Range<Index> {
        return startIndex ..< endIndex
    }

    public func nsRange(for range: Range<String.Index>) -> NSRange {
        let location = distance(from: startIndex, to: range.lowerBound)
        let length = distance(from: range.lowerBound, to: range.upperBound)
        return NSRange(location: location, length: length)
    }

    public func range(for nsRange: NSRange) -> Range<String.Index> {
        return index(startIndex, offsetBy: nsRange.location) ..< index(startIndex, offsetBy: nsRange.location + nsRange.length)
    }

}

// MARK: - Enumeration -
extension String {

    public func composedCharacters() -> [String] {
        var results: [String] = []
        enumerateSubstrings(in: fullRange, options: [.byComposedCharacterSequences]) { (substring, _, _, _) in
            if let substring = substring {
                results.append(substring)
            }
        }
        return results
    }

    public func words() -> [String] {
        var results: [String] = []
        enumerateSubstrings(in: fullRange, options: [.byWords]) { (substring, _, _, _) in
            if let substring = substring {
                results.append(substring)
            }
        }
        return results
    }

    public func lines() -> [String] {
        var results: [String] = []
        enumerateSubstrings(in: fullRange, options: .byLines) { (substring, _, _, _) in
            if let substring = substring {
                results.append(substring)
            }
        }
        return results
    }

}

// MARK: - Trim -
extension String {

    /**
     Removing the white space and new line characters at the start and end of the string
     */
    public mutating func trim() {
        self = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /**
     Return a string that the  white space and new line characters at the start and end of the string are removed
     
     - returns: trimmed string
     */
    public func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /**
     Removing all the white spaces from a string
     */
    public func collapse() -> String {
        let string = self as NSString
        return string.replacingOccurrences(of: " ", with: "") as String
    }

}

// MARK: - Not Empty -
extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }

}

// MARK: - Attributed -
extension String {
    public func underLined(style: NSUnderlineStyle = .styleSingle, color: UIColor? = nil) -> NSAttributedString {
        return NSAttributedString(string: self).underLinedString(style: style, color: color)
    }

    public func attributed(_ attributes: [String: Any]?) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: attributes)
    }

    public func toSuperscript(font: UIFont = UIFont.systemFont(ofSize: UIFont.labelFontSize), color: UIColor = UIColor.darkText) -> NSAttributedString {
        return attributed([NSBaselineOffsetAttributeName: (font.pointSize - font.pointSize / 1.5) / 2.0, NSFontAttributeName: font.withSize(font.pointSize/1.5), NSForegroundColorAttributeName: color])
    }

}

// MARK: - BoundingRect -

extension String {
    func boundingRect(with size: CGSize, attributes: [String: Any]? = nil) -> CGRect {
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        return attributedString.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
    }

    func boundingRect(with size: CGSize, font: UIFont) -> CGRect {
        return boundingRect(with: size, attributes: [NSFontAttributeName: font])
    }
}

extension CGSize {
    func ceiled() -> CGSize {
        return CGSize(width: ceil(width), height: ceil(height))
    }

    static var infinite: CGSize {
        return CGRect.infinite.size
    }
}

// MARK: - Draw in center -
extension String {
    func drawCentered(in rect: CGRect, withAttributes attrs: [String : Any]? = nil) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        drawCentered(at: center, withAttributes: attrs)
    }

    func drawCentered(at point: CGPoint, withAttributes attrs: [String : Any]? = nil) {
        let stringRectSize = self.boundingRect(with: CGSize.infinite, attributes: attrs).size
        let drawingOrigin = CGPoint(x: point.x - stringRectSize.width / 2, y: point.y - stringRectSize.height / 2)
        let drawingRect = CGRect(origin: drawingOrigin, size: stringRectSize)
        (self as NSString).draw(with: drawingRect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
}

// MARK: - RegularExpression -
extension String {
    public func range(ofRegularExpression regex: String) -> Range<String.Index>? {
        return range(of: regex, options: .regularExpression)
    }

    public func replacing(regularExpression regex: String, with replacement: String) -> String {
        return replacingOccurrences(of: regex, with: replacement, options: .regularExpression)
    }

    public func replacing(regularExpression regex: String, withTemplate template: String) throws -> String {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        return regex.stringByReplacingMatches(in: self, options: [], range: nsRange(for: fullRange), withTemplate: template)
    }

    public func passTest(withRegularExpression regex: String) -> Bool {
        return range(ofRegularExpression: regex) != nil
    }

    // Allow matches anywhere in the string (supporting skipping letters)
    // i.e. Keyword: "amacm" --matches-->  "Apple Mac Mini"
    // Return an array of matching indecies
    func smartlyContains(_ keyword: String) -> [Int]? {
        if keyword.isEmpty {
            return nil
        }

        let keywordChars = Array(keyword.lowercased().characters)
        let orginalChars = Array(self.lowercased().characters)

        let indecies = keywordChars.reduce([], {prevIndecies, character in
            let lastIndex = prevIndecies.last as? Int ?? 0

            //If the last index was -1 the seatch has failed, we don't want to continue.
            guard lastIndex != -1 else { return prevIndecies }

            //Find the index of the next character of the keywordChars array within the original string.
            let startOfSearchString = lastIndex == 0 ? 0 : lastIndex + 1
            
            let restOfOriginal = orginalChars.suffix(from:startOfSearchString)
            let nextIndex = restOfOriginal.index(of:character)

            //Reduce to return a list of all indexes we found.
            return prevIndecies + [nextIndex ?? -1]
        }) as? [Int]

        //If the search failed, return nil, else return the list of indecies.
        return indecies!.contains(-1) ? nil : indecies
    }
}

// MARK: - base64 -
extension String {
    init?(base64Encoded base64: String) {
        guard let data = Data(base64Encoded: base64) else {return nil}
        self.init(data: data, encoding: .utf8)
    }

    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

}

// MARK: - String & URL -
extension String {
    /**
     Check if the receiver is a valid url string
     */
    public var isValidURL: Bool {
        guard let url = URL(string: self) else {return false}
        return UIApplication.shared.canOpenURL(url)
    }

    /**
     Get a NSURL instance created from the receiver
     */
    public var url: URL? {
        return URL(string: self)
    }

    public var validURL: URL? {
        guard let url = URL(string: self) else {return nil}
        if UIApplication.shared.canOpenURL(url) {
            return url
        }
        return nil
    }

    public var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
}

// MARK: - NSAttributedString -
extension NSAttributedString {
    func underLinedString(style: NSUnderlineStyle = .styleSingle, color: UIColor? = nil) -> NSMutableAttributedString {
        let temp = NSMutableAttributedString(attributedString: self)
        temp.underLine(style: style, color: color)
        return temp
    }
}

extension NSMutableAttributedString {
    @discardableResult
    func appendText(_ text: String, style: UIFontTextStyle, size: CGFloat = 0, color: UIColor = UIColor.darkText, paragrapthSpacing: CGFloat = 8, lineBreakMode: NSLineBreakMode = .byWordWrapping, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = paragrapthSpacing
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        let font = size == 0 ? UIFont.preferredFont(forTextStyle: style) : UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: style), size: size)
        self.append(NSAttributedString(string: text, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle]))
        return self
    }

    @discardableResult
    func breakLine() -> NSMutableAttributedString {
        self.append(NSAttributedString(string: "\n"))
        return self
    }

    func highlightSubstring(substring: String, color: UIColor, caseSensitive: Bool = true) {
        let options: NSString.CompareOptions = caseSensitive ? [] : [.caseInsensitive]
        let range = (self.string as NSString).range(of: substring, options: options)
        if range.location == NSNotFound {return}
        addAttribute(NSForegroundColorAttributeName, value: color, range: range)
    }

    func underLine(style: NSUnderlineStyle = .styleSingle, color: UIColor? = nil) {
        addAttribute(NSUnderlineStyleAttributeName, value: style.rawValue, range: NSRange(location: 0, length: self.string.characters.count))
        if let color = color {
            addAttribute(NSUnderlineColorAttributeName, value: color, range: NSRange(location: 0, length: self.string.characters.count))
        }
    }
}

func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let temp = NSMutableAttributedString(attributedString: lhs)
    temp.append(rhs)
    return temp
}

func +=(lhs: NSMutableAttributedString, rhs: NSAttributedString) {
    lhs.append(rhs)
}

// MARK: - Dynamic height -
extension String {

    /**
     Calculate the height of the string based on given bounding width and font
     
     - parameter width: The bounding rect for the text
     - parameter font:  The font used to display the string
     
     - returns: The expected height
     */
    func heightWithWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return CGFloat(ceilf(Float(boundingBox.height)))
    }
}

extension NSAttributedString {

    /**
     Calculate the height of the attributed string based on given bounding width and font
     
     - parameter width: The bounding rect for the text
     
     - returns: The expected height
     */
    func heightWithWidth(_ width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return ceil(actualSize.height)
    }
}
