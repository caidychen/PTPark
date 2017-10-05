//
//  UIView+Loading.swift
//
//  Created by Yilei He on 2/05/2016.
//  Copyright © lionhylra.com. All rights reserved.
//

import UIKit
import ObjectiveC

private var _indicatorContainerAssociationKey: Int8 = 0
private var _cachedButtonTitleAssociationKey: Int8 = 0
private var _cachedButtonImageAssociationKey: Int8 = 0
extension UIView {

    private var _activityIndicatorContainer: IndicatorTextView? {
        get {
            return objc_getAssociatedObject(self, &_indicatorContainerAssociationKey) as? IndicatorTextView
        }
        set {
            objc_setAssociatedObject(self, &_indicatorContainerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func showLoadingIndicator(style: UIActivityIndicatorViewStyle = .gray, text: String? = nil, color: UIColor? = nil, blockUserInteraction: Bool = false) {
        if _activityIndicatorContainer == nil {
            _activityIndicatorContainer = IndicatorTextView()
        }
        let indicatorContainer = _activityIndicatorContainer!
        indicatorContainer.activityIndicator.activityIndicatorViewStyle = style
        indicatorContainer.activityIndicator.startAnimating()
        indicatorContainer.activityIndicator.hidesWhenStopped = true
        indicatorContainer.activityIndicator.color = color

        indicatorContainer.textLabel.text = text
        if let color = color {
            indicatorContainer.textLabel.textColor = color
        } else {
            switch style {
            case .gray:
                indicatorContainer.textLabel.textColor = UIColor.gray
            case .white, .whiteLarge:
                indicatorContainer.textLabel.textColor = UIColor.white
            }
        }

        self.addSubview(indicatorContainer)
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: indicatorContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: indicatorContainer, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: indicatorContainer, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 0.8, constant: 0))
        NSLayoutConstraint.activate(constraints)

        if blockUserInteraction {
            self.isUserInteractionEnabled = false
        }
    }

    public func hideLoadingIndicator() {
        _activityIndicatorContainer?.activityIndicator.stopAnimating()
        _activityIndicatorContainer?.removeFromSuperview()
        _activityIndicatorContainer = nil
        self.isUserInteractionEnabled = true
    }

}

extension UIButton {
    private var _cachedButtonTitle: String? {
        get {
            return objc_getAssociatedObject(self, &_cachedButtonTitleAssociationKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &_cachedButtonTitleAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var _cachedButtonImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &_cachedButtonImageAssociationKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &_cachedButtonImageAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public override func showLoadingIndicator(style: UIActivityIndicatorViewStyle = .gray, text: String? = nil, color: UIColor? = nil, blockUserInteraction: Bool = true) {
        super.showLoadingIndicator(style: style, text: text, color: color, blockUserInteraction: blockUserInteraction)
        _cachedButtonImage = image(for: .normal)
        _cachedButtonTitle = title(for: .normal)
        setTitle(nil, for: .normal)
        setImage(nil, for: .normal)

    }

    public override func hideLoadingIndicator() {
        super.hideLoadingIndicator()
        setTitle(_cachedButtonTitle, for: .normal)
        setImage(_cachedButtonImage, for: .normal)
        _cachedButtonTitle = nil
        _cachedButtonImage = nil
    }

}

extension UIBarButtonItem {
    var _loadingIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &_indicatorContainerAssociationKey) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &_indicatorContainerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func showLoadingIndicator(style: UIActivityIndicatorViewStyle = .gray, blockUserInteraction: Bool = false) {
        if _loadingIndicator == nil {
            _loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
        }
        let indicator = _loadingIndicator!
        indicator.activityIndicatorViewStyle = style
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        self.customView = indicator

        if blockUserInteraction {
            self.isEnabled = false
        }
    }

    public func hideLoadingIndicator() {
        _loadingIndicator?.stopAnimating()
        _loadingIndicator?.removeFromSuperview()
        self.customView = nil
        _loadingIndicator = nil
        self.isEnabled = true
    }
}

private class IndicatorTextView: UIView {
    fileprivate let textLabel: UILabel = UILabel()
    fileprivate let activityIndicator = UIActivityIndicatorView()
    private let stackView = UIStackView()
    private func commonInit() {
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(textLabel)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 8

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutAttribute] = [.leading, .top, .bottom, .trailing]
        let constraints: [NSLayoutConstraint] = attributes.map {
            NSLayoutConstraint(item: stackView, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0)
        }
        NSLayoutConstraint.activate(constraints)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
