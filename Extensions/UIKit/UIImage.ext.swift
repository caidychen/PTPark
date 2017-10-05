//
//  ImageColorUtils.swift
//
//
//  Created by Yilei He on 14/04/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

import UIKit

// MARK: - UIImage -
struct DividerOptions: OptionSet {
    let rawValue: Int
    static let left = DividerOptions(rawValue: 1 << 0)
    static let right = DividerOptions(rawValue: 1 << 1)
    static let top = DividerOptions(rawValue: 1 << 2)
    static let bottom = DividerOptions(rawValue: 1 << 3)
    static let all: DividerOptions = [.left, .right, .top, .bottom]
}

extension UIImage {

    class func divider(with size: CGSize, color: UIColor, lineWidth: CGFloat = 1, options: DividerOptions) -> UIImage? {
        guard size.width > 0 && size.height > 0 else {return nil}
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {UIGraphicsEndImageContext()}

        guard let context = UIGraphicsGetCurrentContext() else {return nil}

        color.setFill()

        if options.contains(.left) {
            context.fill(CGRect(x: 0, y: 0, width: lineWidth, height: size.height))
        }

        if options.contains(.right) {
            context.fill(CGRect(x: size.width - lineWidth, y: 0, width: lineWidth, height: size.height))
        }

        if options.contains(.top) {
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: lineWidth))
        }

        if options.contains(.bottom) {
            context.fill(CGRect(x: 0, y: size.height - lineWidth, width: size.width, height: lineWidth))
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    /**
     This method generate a line graph based on the data input. The line graph
     
     - parameter data:         A set of double value
     - parameter szie:         The size of the image
     - parameter color:        The color that used to draw. Black, by default.
     - parameter padding:      The padding is used to make inset of the line graph.
     - parameter drawZeroLine: A flag indicate whether to draw the dash line at zero xAxis. By default, true.
     - parameter drawFrame:    A flag indicate whether to draw a frame. By default, false.
     
     - returns: An image that contains the line graph. If the rect's size is 0, this method returns nil
     */
    static func pulseGraph(data: [Double], size: CGSize, lineWidth: CGFloat = 0.5, color: UIColor = UIColor.black, padding: CGFloat = 5, drawZeroLine: Bool = true, drawFrame: Bool = false) -> UIImage? {

        let canvas = CGRect(origin: CGPoint.zero, size: size).insetBy(dx: padding, dy: padding)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }

        /* start drawing */
        let maxValue = data.max() ?? 0
        let minValue = data.min() ?? 0
        let yStep: CGFloat = canvas.height / CGFloat(maxValue - minValue)
        let xStep: CGFloat = canvas.width / CGFloat(data.count - 1)

        /* configuration */
        guard let context = UIGraphicsGetCurrentContext() else {return nil}

        context.setStrokeColor(color.cgColor)
        context.setShouldAntialias(true)
        context.setLineWidth(lineWidth)

        if data.count == 0 {
            /* Draw a straight line */
            context.saveGState()
            context.setStrokeColor(color.cgColor)
            let yPos = canvas.height * 0.85
            context.move(to: CGPoint(x: canvas.minX, y: canvas.minY + yPos))
            context.addLine(to: CGPoint(x: canvas.maxX, y: canvas.minY + yPos))
            context.strokePath()

            /* Draw text */
            let p = NSMutableParagraphStyle()
            p.alignment = .center
            let fontSize = UIFont.smallSystemFontSize * 0.6
            let attr = [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
                        NSForegroundColorAttributeName: color,
                        NSParagraphStyleAttributeName: p]

            var textRect = canvas
            textRect.origin.y = yPos - fontSize
            NSString(string:"No data available.".uppercased()).draw(in: textRect, withAttributes: attr)
            context.restoreGState()
        } else {
            /* Draw lines */
            context.saveGState()
            // transform coordinate: Flip Y axis.
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)

            let points = data.enumerated().map { (index, value) -> CGPoint in
                let transformedValue = value - minValue
                return CGPoint(x: canvas.minX + CGFloat(index) * xStep, y: canvas.minY + CGFloat(transformedValue) * yStep)
            }
            context.addLines(between: points)
            context.strokePath()
            context.restoreGState()

        }

        /* Draw frame */
        if drawFrame {
            UIRectFrame(canvas)
        }

        /* Draw zero line */

        if drawZeroLine && minValue < 0 && maxValue > 0 {
            context.saveGState()
            context.setLineDash(phase: 0, lengths: [3])

            context.setStrokeColor(color.withAlphaComponent(0.5).cgColor)
            // transform coordinate: Flip Y axis.
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)

            let zeroValue = -minValue
            context.move(to:CGPoint(x: canvas.minX, y: canvas.minY + CGFloat(zeroValue) * yStep))
            context.addLine(to:CGPoint(x: canvas.maxX, y: canvas.minY + CGFloat(zeroValue) * yStep))
            context.strokePath()
            context.restoreGState()
        }

        /* end drawing */
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

    enum AvatarStyle {
        case rectangle, ellipse
    }
    /// This function takes a sting and converts it to an avatar-like round/square image. Only the first letter of the string is used.
    ///
    /// - Parameters:
    ///   - name: The text used to generate image
    ///   - size: The size of rectangle that defines the area for the ellipse to fit in.
    ///   - backgroundColor: the color of the filled circle
    ///   - foregroundColor: the color of text
    ///   - font: the font of text
    ///   - forceUppercased: If true, text will be uppercased. By defaut, true
    ///   - limit: The maximum count of letters in the result. By default the value is 1. If the value is 0, the count of letters in the result is unlimited.
    /// - Returns: An image contains the first letter of text with a filled circle as background
    static func avatarImage(with name: String, size: CGSize, style: AvatarStyle, backgroundColor: UIColor, foregroundColor: UIColor, font: UIFont? = nil, forceUppercased: Bool = true, initialsCountLimit limit: Int = 1) -> UIImage? {
        precondition(limit >= 0, "initials count limit can't be a negative number.")

        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {return nil}

        /* draw circle */
        context.setFillColor(backgroundColor.cgColor)
        switch style {
        case .ellipse:
            context.fillEllipse(in: rect)
        case .rectangle:
            context.fill(rect)
        }

        /* draw font */
        
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        var initialsComponents = name.components(separatedBy: CharacterSet.whitespacesAndNewlines)// "Jim Green" -> ["Jim", "Green"]
        let upperBound = min(initialsComponents.count, limit)

        var initials = (limit == 0 ? initialsComponents : Array(initialsComponents[0 ..< upperBound]).map {$0.substring(to: $0.index(after: $0.startIndex))}).joined()// ["Jim", "Green"] -> ["J", "G"] -> "JG"
        initials = forceUppercased ? initials.uppercased() : initials
        initials = initials.characters.count >= 3 ? initials.substring(to: 3) : initials
        let attributedText = NSAttributedString(
            string: initials,
            attributes: [NSFontAttributeName: font ?? UIFont.systemFont(ofSize: min(size.height, size.width) / (CGFloat(initials.characters.count) + 0.2)),
                         NSForegroundColorAttributeName: foregroundColor])
        let textSize = attributedText.boundingRect(with: size, options: [], context: nil).size
        attributedText.draw(at: CGPoint(x: rect.midX - textSize.width / 2, y: rect.midY - textSize.height / 2))

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIImage {
    /**
     Crop the image using a given CGRect
     
     - parameter rect: the rect is used in the image bounds to get the sub image view
     
     - returns: An sub image view
     */
    func crop(_ rect: CGRect) -> UIImage? {
        let imageRef = self.cgImage
        let resultRef = imageRef?.cropping(to: rect)
        return resultRef.flatMap {UIImage(cgImage: $0)}
    }

    /// This function removes the orientation info from UIImage and rotate it to normal orientation
    ///
    /// - Returns: A image that can be used without orientation information
    func normalized() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {UIGraphicsEndImageContext()}

        draw(at: CGPoint.zero)
        return UIGraphicsGetImageFromCurrentImageContext() ?? self//in case image.size is 0
    }

    func resized(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {

        guard size.height > 0 && size.width > 0 else { return self }
        guard maxWidth > 0 || maxHeight > 0 else { return self }

        var actualHeight = size.height
        var actualWidth = size.width
        var maxWidth = maxWidth
        var maxHeight = maxHeight

        if maxHeight == 0 {
            maxHeight = maxWidth * actualHeight / actualWidth
        } else if maxWidth == 0 {
            maxWidth = maxHeight * actualWidth / actualHeight
        }

        var imgRatio = actualWidth / actualHeight
        let maxRatio = maxWidth / maxHeight

        if actualHeight > maxHeight || actualWidth > maxWidth {

            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }

        let canvasSize = CGSize(width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0)
        defer { UIGraphicsEndImageContext() }

        draw(in: CGRect(origin: CGPoint.zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension UIImage {
    
    class func imageWithColor(color:UIColor, size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if context == nil {
            return nil
        }
        color.set()
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    
    class func verticalAppendedTotalImageSizeFromImagesArray(imagesArray:[UIImage]) -> CGSize {
        var totalSize = CGSize.zero
        for im in imagesArray {
            let imSize = im.size
            totalSize.height += imSize.height
            totalSize.width = max(totalSize.width, imSize.width)
        }
        return totalSize
    }
    
    
    class func verticalImageFromArray(imagesArray:[UIImage]) -> UIImage? {
        
        var unifiedImage:UIImage?
        let totalImageSize = self.verticalAppendedTotalImageSizeFromImagesArray(imagesArray: imagesArray)
        
        UIGraphicsBeginImageContextWithOptions(totalImageSize,false, 0)
        
        var imageOffsetFactor:CGFloat = 0
        
        for img in imagesArray {
            img.draw(at: CGPoint(x: 0, y: imageOffsetFactor))
            imageOffsetFactor += img.size.height;
        }
        unifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return unifiedImage
    }
}

