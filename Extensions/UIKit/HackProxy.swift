//
//  Hack.swift
//  Swift3Project
//
//  Created by Yilei He on 24/1/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import UIKit

protocol Hackable {}
extension Hackable {
    var hacked: HackProxy<Self> {
        return HackProxy(base: self)
    }
}

public class HackProxy<T> {
    fileprivate let base: T
    init(base: T) {
        self.base = base
    }
}

extension UIViewController: Hackable {}
extension UISegmentedControl: Hackable {}
extension UITabBar: Hackable {}
extension UIApplication: Hackable {}
extension UISearchBar: Hackable {}
extension UINavigationBar: Hackable {}

// MARK: - UIViewController -
extension HackProxy where T: UIViewController {

    var statusBar: UIView? {
        return UIApplication.shared.value(forKey: "statusBar") as? UIView
    }
}

// MARK: - UISegmentedControl -
extension HackProxy where T: UISegmentedControl {
    var segments: [UIView] {
        return base.subviews.filter { type(of: $0).description() == "UISegment" }.sorted { $0.frame.origin.x < $1.frame.origin.x }
    }
}

// MARK: - UITabBar -
extension HackProxy where T: UITabBar {
    var tabBarButtons: [UIView] {
        return base.subviews.filter { String(reflecting: type(of:$0)) == "UITabBarButton"}.sorted {$0.frame.origin.x < $1.frame.origin.x}
    }
}

// MARK: - UIApplication -
extension HackProxy where T: UIApplication {
    var statusBar: UIView? {
        return base.value(forKey: "statusBar") as? UIView
    }
}

// MARK: - UISearchBar -
extension HackProxy where T: UISearchBar {
    var searchField: UITextField? {
        return base.value(forKey: "searchField") as? UITextField
    }

    var cancelButton: UIButton? {
        return base.value(forKey: "cancelButton") as? UIButton
    }
}

// MARK: - UINavigationBar -
extension HackProxy where T: UINavigationBar {
    var backgroundImageView: UIImageView? {
        return base.subviews.first as? UIImageView
    }

    var backgroundAlpha: CGFloat? {
        get {
            return backgroundImageView?.alpha
        }
        set {
            if let alpha = newValue {
                backgroundImageView?.alpha = alpha
            }
        }
    }

    var titleItemView: UIView? {
        return base.subviews.filter {String(describing: type(of: $0)) == "UINavigationItemView"}.first
    }

    var backIndicatorView: UIView? {
        return base.subviews.filter {String(reflecting:type(of:$0)) == "_UINavigationBarBackIndicatorView"}.first
    }

    var backIndicatorImage: UIImage? {
        return (backIndicatorView as? UIImageView)?.image
    }

    var backIndicatorSize: CGSize? {
        return backIndicatorView?.frame.size
    }
}

// MARK: - UIPageViewController -
extension HackProxy where T: UIPageViewController {
    var scrollView: UIScrollView? {
        return base.view.subviews.filter {$0 is UIScrollView}.first as? UIScrollView
    }
}
