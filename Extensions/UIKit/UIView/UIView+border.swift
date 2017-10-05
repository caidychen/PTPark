//
//  UIView+border.swift
//  Swift3Project
//
//  Created by Yilei on 13/1/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import UIKit

extension UIColor {
    static var tableViewSeperatorColor: UIColor {
        return UIColor(colorLiteralRed: 0.78, green: 0.78, blue: 0.8, alpha: 1)
    }
}

extension UIView {

    @discardableResult
    func addBorder(borderColor: UIColor, lineWidth: CGFloat, options: BorderView.BorderOptions) -> BorderView {
        let borderView = BorderView(frame: bounds, borderColor: borderColor, lineWidth: lineWidth, options: options)
        if self is UIScrollView {
            if let superview = self.superview {
                borderView.frame = self.frame
                superview.insertSubview(borderView, aboveSubview: self)
                borderView.translatesAutoresizingMaskIntoConstraints = false
                var constraints: [NSLayoutConstraint] = []
                constraints.append(NSLayoutConstraint(item: borderView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: borderView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: borderView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: borderView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
                NSLayoutConstraint.activate(constraints)
            }
        } else {
            addSubview(borderView)
            borderView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        return borderView
    }

}

open class BorderView: UIView {

    public struct BorderOptions: OptionSet {
        public let rawValue: Int
        static let left = BorderOptions(rawValue: 1 << 0)
        static let right = BorderOptions(rawValue: 1 << 1)
        static let top = BorderOptions(rawValue: 1 << 2)
        static let bottom = BorderOptions(rawValue: 1 << 3)
        static let all: BorderOptions = [.left, .right, .top, .bottom]

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    open var borderColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    open var lineWidth: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    open var options: BorderOptions {
        didSet {
            setNeedsDisplay()
        }
    }

    public init(frame: CGRect, borderColor: UIColor, lineWidth: CGFloat, options: BorderOptions) {
        self.borderColor = borderColor
        self.lineWidth = lineWidth
        self.options = options
        super.init(frame: frame)
        isOpaque = false
        isUserInteractionEnabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}

        borderColor.setFill()

        if options.contains(.left) {
            context.fill(CGRect(x: 0, y: 0, width: lineWidth, height: bounds.size.height))
        }

        if options.contains(.right) {
            context.fill(CGRect(x: bounds.size.width - lineWidth, y: 0, width: lineWidth, height: bounds.size.height))
        }

        if options.contains(.top) {
            context.fill(CGRect(x: 0, y: 0, width: bounds.size.width, height: lineWidth))
        }

        if options.contains(.bottom) {
            context.fill(CGRect(x: 0, y: bounds.size.height - lineWidth, width: bounds.size.width, height: lineWidth))
        }

    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}
