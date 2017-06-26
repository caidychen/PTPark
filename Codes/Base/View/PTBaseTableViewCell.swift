//
//  PTBaseTableViewCell.swift
//  PTPark
//
//  Created by soso on 2017/4/20.
//
//

import UIKit

class PTBaseTableViewCell: UITableViewCell {
    
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
        self.contentView.addSubview(l)
        return l
    }()
    
    lazy var bottomLine: UIView = {
        let l = UIView()
        l.backgroundColor = UIColor(hexValue: 0xe1e1e1)
        l.height = 1.0 / UIScreen.main.scale
        self.contentView.addSubview(l)
        return l
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        topLine.isHidden = true
        bottomLine.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !topLine.isHidden {
            topLine.width = UIEdgeInsetsInsetRect(self.bounds, topLineInsets).width
            topLine.top = self.bounds.top + topLineInsets.top
            topLine.left = topLineInsets.left
        }
        
        if !bottomLine.isHidden {
            bottomLine.width = UIEdgeInsetsInsetRect(self.bounds, bottomLineInsets).width
            bottomLine.bottom = self.bounds.bottom - bottomLineInsets.bottom
            bottomLine.left = bottomLineInsets.left
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.bringSubview(toFront: self.topLine)
        self.contentView.bringSubview(toFront: self.bottomLine)
    }
    
}
