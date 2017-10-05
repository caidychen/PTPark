//
//  UIView+CornerRadiusAndShadow.swift
//  
//
//  Created by Yilei He on 29/08/2016.
//  Copyright © 2016 lionhylra.com. All rights reserved.
//

/* Tested: Xcode 9 beta, Swift 4 */
import UIKit

extension UIView {

    private func _setIdenticalFrameConstraints(parentView: UIView, childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutAttribute] = [.leading, .trailing, .top, .bottom]
        let constraints: [NSLayoutConstraint] = attributes.map {
            NSLayoutConstraint(item: childView, attribute: $0, relatedBy: .equal, toItem: parentView, attribute: $0, multiplier: 1, constant: 0)
        }
        NSLayoutConstraint.activate(constraints)
    }

    /// This method will not modify layer of the view. Instead, it creates two wrapper view: shadowView and roundedCornerView. The caller on the view hierarchy will be replaced with shadowView and all the layout constraints related to caller will be transfered to the shadowView. Then the roundedCornerView will be installed into the shadowView and the caller will be installed into the roundedCornerView.The shadow view observes 'isHidden' property of caller and synchronizes its own 'isHidden' property from caller's. If the caller is removed from view hierarchy, the shadow view is also removed from view hierarchy.
    ///
    /// **Note**: Before calling this method, the view must have been added to the view hierarchy with constraints set. After calling this method, the view hierarchy is modified. So the superview property of caller will be different. You can get the original superview from shadowView, which is the first value in the returned tuple.
    ///
    /// - Parameters:
    ///   - cornerRadius:
    ///   - shadowOpacity:
    ///   - shadowOffset:
    ///   - shaodwRadius:
    ///   - shadowColor:
    /// - Returns: A tuple contains two wrapper view. The first view's layer is configured to display shadow, and the second view's layer is configured to display cornerRadius, and cut off any subview who exceeds the bound of the view.
    ///
    /// **Note:** If a view is dynamicly added and removed from view hierarchy, you need to remove the shadowView manually from superview.
    ///
    /// Example:
    /// ```
    ///     class MyBaseViewController: UIViewController {
    ///         var shadowView: UIView?
    ///         override func didMove(toParentViewController parent: UIViewController?) {
    ///             super.didMove(toParentViewController: parent)
    ///             guard view.superview != nil else {
    ///                 shadowView?.removeFromSuperview()
    ///                 return
    ///             }
    ///             shadowView = view.setCornerRadiusAndShadow_iOS10(cornerRadius: 10).0
    ///         }
    ///
    ///     }
    /// ```
    @discardableResult
    public func setCornerRadiusAndShadow_iOS10(cornerRadius: CGFloat,
                                               shadowOpacity: Float = 0.5,
                                               shadowOffset: CGSize = CGSize(width: 0, height: 3),
                                               shaodwRadius: CGFloat = 2,
                                               shadowColor: CGColor = UIColor.black.cgColor) -> (UIView, UIView) {

        guard let superview = self.superview else {
            fatalError("The view \(self.debugDescription) is not added to view hierarchy yet!")
        }

        let roundedCornerView: UIView = {
            class _RoundedCornerView: UIView {
                var originalView: UIView?

                override func willRemoveSubview(_ subview: UIView) {
                    super.willRemoveSubview(subview)
                    if subview == originalView {
                        originalView = nil
                        removeFromSuperview()
                    }
                }
            }
            let v = _RoundedCornerView(frame: self.bounds)
            v.originalView = self
            v.layer.cornerRadius = cornerRadius
            v.layer.masksToBounds = true
            return v
        }()

        let shadowView: UIView = {
            class _ShadowView: UIView {
                var roundedCornerView: UIView?
                var originalView: UIView? {
                    didSet {
                        guard let originalView = originalView else {
                            return
                        }

                        originalView.addObserver(self, forKeyPath: #keyPath(UIView.isHidden), options: .initial, context: nil)
                    }
                }

                override func willRemoveSubview(_ subview: UIView) {
                    super.willRemoveSubview(subview)
                    if subview == roundedCornerView {
                        originalView?.removeObserver(self, forKeyPath: #keyPath(UIView.isHidden))
                        roundedCornerView = nil
                        originalView = nil
                        removeFromSuperview()
                    }
                }

                override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                    if let view = object as? UIView, keyPath == #keyPath(UIView.isHidden), view == originalView {
                        self.isHidden = view.isHidden
                    }
                }
            }
            let v = _ShadowView(frame: self.frame)
            v.originalView = self
            v.roundedCornerView = roundedCornerView
            v.clipsToBounds = false
            v.layer.cornerRadius = cornerRadius
            v.layer.shadowOpacity = shadowOpacity
            v.layer.shadowOffset = shadowOffset
            v.layer.shadowRadius = shaodwRadius
            v.layer.shadowColor = shadowColor
            return v
        }()

        //Add shadow view
        if  let stackView = superview as? UIStackView,
            let index = stackView.arrangedSubviews.index(of: self) {
            stackView.insertArrangedSubview(shadowView, at: index)
        } else {
            superview.addSubview(shadowView)
            shadowView.translatesAutoresizingMaskIntoConstraints = false
            let shadowViewConstraints = transferConstraints(to: shadowView)
            NSLayoutConstraint.activate(shadowViewConstraints)
        }

        //Add rounded corner view
        shadowView.addSubview(roundedCornerView)
        _setIdenticalFrameConstraints(parentView: shadowView, childView: roundedCornerView)

        //Add self to container view
        if let stackView = superview as? UIStackView {
            stackView.removeArrangedSubview(self)
        }
        self.removeFromSuperview()
        self.frame = roundedCornerView.bounds
        roundedCornerView.addSubview(self)
        _setIdenticalFrameConstraints(parentView: roundedCornerView, childView: self)

        return (shadowView, roundedCornerView)
    }
}
