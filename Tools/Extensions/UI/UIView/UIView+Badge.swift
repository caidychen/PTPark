//
//  UIView+Badge.swift
//  PTPark
//
//  Created by soso on 2017/6/7.
//
//

import UIKit

enum PTBadgeValue {
    case none
    case dot
    case text(String?)
}

fileprivate let badgeTag: Int = 0xeeee
fileprivate let dotSize: CGSize = 10.0.size
fileprivate let valueMaxSize: CGSize = CGSize(width: 100, height: 20)

extension UIView {
    
    func setBadge(_ badge: PTBadgeValue, _ offset: CGPoint? = .zero) {
        switch badge {
        case .none:
            self.removeBadge()
            break
        case .dot:
            self.addBadge()
            badgeView.text = nil
            badgeView.size = dotSize
            layout(offset)
            break
        case .text(let value):
            if value == nil {
                self.removeBadge()
            } else {
                self.addBadge()
                badgeView.text = value
                let size = badgeView.sizeThatFits(valueMaxSize).ceil
                badgeView.size = CGSize(width: max(size.width, valueMaxSize.height), height: max(size.height, valueMaxSize.height))
                layout(offset)
            }
            break
        }
    }
    
    fileprivate func addBadge() {
        guard let _ = badgeView.superview else {
            self.addSubview(badgeView)
            badgeView.popup(0.2)
            return
        }
    }
    
    fileprivate func removeBadge() {
        guard let _ = badgeView.superview else {
            return
        }
        badgeView.removeFromSuperview()
    }
    
    fileprivate func layout(_ offset: CGPoint?) {
        badgeView.layer.cornerRadius = badgeView.height / 2.0
        badgeView.center = CGPoint(x: self.width + (offset?.x ?? 0), y: offset?.y ?? 0)
    }
    
    fileprivate var badgeView: UILabel {
        get {
            if let l = self.viewWithTag(badgeTag) as? UILabel {
                return l
            }
            let label = UILabel(frame: valueMaxSize.bounds)
            label.tag = badgeTag
            label.backgroundColor = .red
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .center
            label.clipsToBounds = true
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1.0
            return label
        }
    }
    
}
