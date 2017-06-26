//
//  PTBaseTableViewHeaderFooterView.swift
//  PTPark
//
//  Created by soso on 2017/5/5.
//
//

import UIKit

class PTBaseTableViewHeaderFooterView: UITableViewHeaderFooterView {

    var contentInsets: UIEdgeInsets = UIEdgeInsets.zero
    var gap: CGSize = CGSize.zero
    var topLineInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    var bottomLineInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    var isTopLineHidden: Bool {
        get {
            return self.topLine.isHidden
        }
        set {
            self.topLine.isHidden = newValue
        }
    }
    var isBottomLineHidden: Bool {
        get {
            return self.bottomLine.isHidden
        }
        set {
            self.bottomLine.isHidden = newValue
        }
    }
    
    lazy var topLine: UIView = {
        let l = UIView()
        l.backgroundColor = UIColor(hexValue: 0xe1e1e1)
        l.height = 1.0 / UIScreen.main.scale
        self.addSubview(l)
        return l
    }()
    
    lazy var bottomLine: UIView = {
        let l = UIView()
        l.backgroundColor = UIColor(hexValue: 0xe1e1e1)
        l.height = 1.0 / UIScreen.main.scale
        self.addSubview(l)
        return l
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.isTopLineHidden = true
        self.isBottomLineHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.topLine.width = UIEdgeInsetsInsetRect(self.bounds, topLineInsets).width
        self.bottomLine.width = UIEdgeInsetsInsetRect(self.bounds, bottomLineInsets).width
        self.topLine.top = self.top + topLineInsets.top
        self.topLine.left = topLineInsets.left
        self.bottomLine.bottom = self.bottom - bottomLineInsets.bottom
        self.bottomLine.left = bottomLineInsets.left
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bringSubview(toFront: self.topLine)
        self.bringSubview(toFront: self.bottomLine)
    }

}
