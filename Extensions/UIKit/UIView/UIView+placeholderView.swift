//
//  UIView+placeholderView.swift
//
//
//  Created by Yilei on 15/3/17.
//  Copyright © 2017 Quest Payment Systems Pty Ltd. All rights reserved.
//

import UIKit
import ObjectiveC

private var _placeholderViewAssociationKey: UInt8 = 0

extension UIView {
    private var _placeholderView: PlaceholderView? {
        get {
            return objc_getAssociatedObject(self, &_placeholderViewAssociationKey) as? PlaceholderView
        }

        set {
            objc_setAssociatedObject(self, &_placeholderViewAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @discardableResult
    public func showPlaceholderView(widthMultiplier: CGFloat, image: UIImage?, title: String?, subtitle: String?, tintColor: UIColor) -> PlaceholderView {
        let placeholderView: PlaceholderView
        if let view = _placeholderView {
            placeholderView = view
        } else {
            placeholderView = PlaceholderView()
            _placeholderView = placeholderView
            addSubview(placeholderView)
            placeholderView.translatesAutoresizingMaskIntoConstraints = false
            let constraints: [NSLayoutConstraint] = [
                NSLayoutConstraint(item: placeholderView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: placeholderView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: placeholderView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: widthMultiplier, constant: 0)
            ]

            NSLayoutConstraint.activate(constraints)
        }

        placeholderView.imageView.image = image
        placeholderView.titleLabel.text = title
        placeholderView.subtitleLabel.text = subtitle
        placeholderView.tintColor = tintColor
        placeholderView.isHidden = false

        return placeholderView
    }

    public func hidePlaceholderView() {
        _placeholderView?.isHidden = true
    }
}

public class PlaceholderView: UIView {
    public let imageView = UIImageView()
    public let titleLabel = UILabel()
    public let subtitleLabel = UILabel()
    public var spacing: CGFloat = 8 {
        didSet {
            imageBottomConstraint.constant = imageView.image == nil ? 0 : spacing
            titleLabelBottomConstraint.constant = (titleLabel.text ?? "").isEmpty ? 0 : spacing
        }
    }
    public override var tintColor: UIColor! {
        didSet {
            titleLabel.textColor = tintColor
            subtitleLabel.textColor = tintColor
        }
    }
    private var imageBottomConstraint: NSLayoutConstraint!
    private var titleLabelBottomConstraint: NSLayoutConstraint!

    private func commonInit() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        var constraints: [NSLayoutConstraint] = []
        imageView.translatesAutoresizingMaskIntoConstraints = false
        constraints += [
            NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        ]

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageBottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: imageView.image == nil ? 0 : spacing)
        constraints += [
            NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            imageBottomConstraint,
            NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        ]

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabelBottomConstraint = NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: (titleLabel.text ?? "").isEmpty ? 0 : spacing)
        constraints += [
            NSLayoutConstraint(item: subtitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            titleLabelBottomConstraint,
            NSLayoutConstraint(item: subtitleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: subtitleLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        ]

        NSLayoutConstraint.activate(constraints)

        tintColor = UIColor.lightGray

        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)

        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)

        imageView.addObserver(self, forKeyPath: "image", options: .new, context: nil)
        titleLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    deinit {
        imageView.removeObserver(self, forKeyPath: "image")
        titleLabel.removeObserver(self, forKeyPath: "text")
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let view = object as? UIView, view == imageView {
            imageBottomConstraint.constant = imageView.image == nil ? 0 : spacing
        } else if let view = object as? UIView, view == titleLabel {
            titleLabelBottomConstraint.constant = (titleLabel.text ?? "").isEmpty ? 0 : spacing
        }
    }
}
