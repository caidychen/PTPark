//
//  PTAlertView.swift
//  PTPark
//
//  Created by soso on 2017/4/12.
//
//

import UIKit

fileprivate let PTAlertInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

public enum PTAlertActionStyle : Int {
    case `default`
    case destructive
}

public enum PTAlertActionColor : Int {
    case white
    case green
    case red
}

class PTAlertItem {
    
    typealias PTAlertBlock = (_ alertView: PTAlertView) -> Void
    var style: PTAlertActionStyle = .default
    var color: PTAlertActionColor = .white
    var title: String?
    var action: PTAlertBlock?
    
    init(title: String?, style: PTAlertActionStyle, color: PTAlertActionColor, action: PTAlertBlock?) {
        self.title = title
        self.style = style
        self.color = color
        if let `action` = action {
            self.action = action
        }
    }
    
}

class PTAlertButton: UIButton {
    var item: PTAlertItem? {
        didSet {
            guard let `item` = self.item else {
                return
            }
            if let `title` = item.title {
                self.setTitle(title, for: .normal)
            }
            
            switch item.style {
            case .destructive:
                switch item.color {
                case .red:
                    self.setTitleColor(.white, for: .normal)
                    self.backgroundColor = .red
                    self.layer.borderWidth = 0
                    break
                case .green:
                    self.setTitleColor(.white, for: .normal)
                    self.backgroundColor = .green
                    self.layer.borderWidth = 0
                    break
                case .white:
                    self.setTitleColor(.white, for: .normal)
                    self.backgroundColor = .gray
                    self.layer.borderWidth = 0
                    break
                }
            case .default:
                switch item.color {
                case .red:
                    self.setTitleColor(.red, for: .normal)
                    self.backgroundColor = .white
                    self.layer.borderWidth = 1
                    self.layer.borderColor = UIColor.red.cgColor
                    break
                case .green:
                    self.setTitleColor(.green, for: .normal)
                    self.backgroundColor = .white
                    self.layer.borderWidth = 1
                    self.layer.borderColor = UIColor.green.cgColor
                    break
                case .white:
                    self.setTitleColor(.white, for: .normal)
                    self.backgroundColor = .gray
                    self.layer.borderWidth = 1
                    self.layer.borderColor = UIColor.white.cgColor
                    break
                }
            }
            
        }
    }
}

extension UIView {
    
    func PTAlertAddSubview(_ view: UIView?) {
        guard let `view` = view else {
            return
        }
        if view.superview == self {
            return
        }
        self.addSubview(view)
    }
    
    func PTAlertRemoveFromSuperview() {
        guard let _ = self.superview else {
            return
        }
        self.removeFromSuperview()
    }
    
    func alertPopup(_ duration: TimeInterval) {
        let key = String(describing: #selector(alertPopup))
        let animate = CAKeyframeAnimation(keyPath: "transform")
        animate.values = [CATransform3DMakeScale(0.5, 0.5, 0.5),
                          CATransform3DMakeScale(1.1, 1.1, 1.0),
                          CATransform3DMakeScale(1.0, 1.0, 1.0)]
        animate.duration = duration
        self.layer.add(animate, forKey:key)
    }
    
}

fileprivate let alertAnimateDuration: TimeInterval = 0.2
fileprivate let alertDefaultHeight: CGFloat = 40
fileprivate let defaultCancelTitle = "取消"
fileprivate let defaultSureTitle = "确定"

class PTAlertContentView: UIView {
    
    var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var gap: CGSize = CGSize(width: 20, height: 20)
    
    lazy fileprivate var defaultAttributes: [String:Any] = {
        var attributes = [String:Any]()
        attributes[NSForegroundColorAttributeName] = UIColor.black
        attributes[NSFontAttributeName] = UIFont.systemFont(ofSize: 14)
        return attributes
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
        let _titleLabel = UILabel()
        self.addSubview(_titleLabel)
        return _titleLabel
    }()
    
    fileprivate var contentView: UIView?
    
    fileprivate lazy var cancelButton: PTAlertButton = {
        let _cancelButton = PTAlertButton(frame: CGRect(x: 0, y: 0, width: alertDefaultHeight * 4, height: alertDefaultHeight))
        _cancelButton.setTitle(defaultCancelTitle, for: .normal)
        _cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        _cancelButton.layer.cornerRadius = _cancelButton.height / 2.0
        return _cancelButton
    }()
    
    fileprivate lazy var sureButton: PTAlertButton = {
        let _sureButton = PTAlertButton(frame: CGRect(x: 0, y: 0, width: alertDefaultHeight * 4, height: alertDefaultHeight))
        _sureButton.setTitle(defaultSureTitle, for: .normal)
        _sureButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        _sureButton.layer.cornerRadius = _sureButton.height / 2.0
        return _sureButton
    }()
    
    // MARK: - life cycle
    deinit {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, message: String?) {
        super.init(frame:CGRect())
        var attributedTitle: NSAttributedString?
        if let `title` = title {
            attributedTitle = NSAttributedString(string: title, attributes: defaultAttributes)
        }
        var contentView: UILabel?
        if let `message` = message {
            contentView = UILabel()
            contentView?.attributedText = NSAttributedString(string: message, attributes: defaultAttributes)
        }
        setUp(title: attributedTitle, contentView: contentView, cancel: nil, sure: nil)
    }
    
    init(title: String?, message: String?, cancel: PTAlertItem?, sure: PTAlertItem?) {
        super.init(frame:CGRect())
        var attributedTitle: NSAttributedString?
        if let `title` = title {
            attributedTitle = NSAttributedString(string: title, attributes: defaultAttributes)
        }
        var contentView: UILabel?
        if let `message` = message {
            contentView = UILabel()
            contentView?.attributedText = NSAttributedString(string: message, attributes: defaultAttributes)
        }
        setUp(title: attributedTitle, contentView: contentView, cancel: cancel, sure: sure)
    }
    
    init(title: NSAttributedString?, contentView: UIView?, cancel: PTAlertItem?, sure: PTAlertItem?) {
        super.init(frame:CGRect())
        setUp(title: title, contentView: contentView, cancel: cancel, sure: sure)
    }
    
    private func setUp(title: NSAttributedString?, contentView: UIView?, cancel: PTAlertItem?, sure: PTAlertItem?) {
        self.titleLabel.attributedText = title
        self.contentView = contentView
        if let `contentView` = self.contentView {
            self.PTAlertAddSubview(contentView)
        }
        if let _ = sure {
            self.addSubview(self.sureButton)
            self.sureButton.item = sure
        }
        var `cancel` = cancel
        if cancel == nil && sure == nil {
            cancel = PTAlertItem(title: defaultCancelTitle, style: .default, color: .white, action: nil)
        }
        if let _ = cancel {
            self.addSubview(self.cancelButton)
            self.cancelButton.item = cancel
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets)
        var y = self.contentInsets.top
        if let _ = self.titleLabel.superview {
            self.titleLabel.top = y
            self.titleLabel.centerX = inFrame.centerX
            y += (self.titleLabel.height + self.gap.height)
        }
        if let _ = self.contentView?.superview {
            self.contentView?.top = y
            self.contentView?.centerX = inFrame.centerX
        }
        if self.cancelButton.superview == nil && self.sureButton.superview == nil {
            return
        }
        if self.cancelButton.superview != nil && self.sureButton.superview == nil {
            self.cancelButton.centerX = inFrame.centerX
            self.cancelButton.bottom = inFrame.bottom
        } else if self.cancelButton.superview == nil && self.sureButton.superview != nil {
            self.sureButton.centerX = inFrame.centerX
            self.sureButton.bottom = inFrame.bottom
        } else {
            self.cancelButton.left = inFrame.origin.x
            self.cancelButton.bottom = inFrame.bottom
            self.sureButton.right = inFrame.right
            self.sureButton.bottom = inFrame.bottom
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width: CGFloat = size.width - (self.contentInsets.left + self.contentInsets.right)
        var height: CGFloat = 0
        if let _ = self.titleLabel.superview {
            let titleSize = self.titleLabel.sizeThatFits(CGSize(width: width, height: size.height / 2.0))
            self.titleLabel.size = titleSize.ceil
            height += self.titleLabel.height
            height += self.gap.height
        }
        if self.cancelButton.superview != nil || self.sureButton.superview != nil {
            var buttonWidth = width - self.gap.width
            if let _ = self.cancelButton.superview, let _ = self.sureButton.superview {
                buttonWidth = buttonWidth / 2.0
            }
            self.sureButton.size = CGSize(width: buttonWidth, height: alertDefaultHeight)
            self.cancelButton.size = self.sureButton.size
            height += alertDefaultHeight
            height += self.gap.height
        }
        if self.contentView != nil && self.contentView?.superview != nil {
            var contentViewSize = self.contentView?.size
            if self.contentView?.size == CGSize.zero {
                contentViewSize = self.contentView?.sizeThatFits(CGSize(width: width, height: size.height / 2.0))
            }
            self.contentView?.size = contentViewSize!.ceil
            height += (self.contentView?.height)!
            height += self.gap.height
        }
        return CGSize(width: size.width, height: height + CGFloat(self.contentInsets.top + self.contentInsets.bottom))
    }
    
}

class PTAlertView: UIView {
    
    var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var gap: CGSize = CGSize(width: 20, height: 20)
    
    public var contentView: PTAlertContentView?
    
    // MARK: - life cycle
    deinit {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, message: String?) {
        super.init(frame:CGRect())
        self.contentView = PTAlertContentView(title: title, message: message)
        self.contentView?.contentInsets = self.contentInsets
        self.contentView?.gap = self.gap
        self.addSubview(self.contentView!)
    }
    
    init(title: String?, message: String?, cancel: PTAlertItem?, sure: PTAlertItem?) {
        super.init(frame:CGRect())
        self.contentView = PTAlertContentView(title: title, message: message, cancel: cancel, sure: sure)
        self.contentView?.contentInsets = self.contentInsets
        self.contentView?.gap = self.gap
        self.addSubview(self.contentView!)
    }
    
    init(title: NSAttributedString?, contentView: UIView?, cancel: PTAlertItem?, sure: PTAlertItem?) {
        super.init(frame:CGRect())
        self.contentView = PTAlertContentView(title: title, contentView: contentView, cancel: cancel, sure: sure)
        self.contentView?.contentInsets = self.contentInsets
        self.contentView?.gap = self.gap
        self.addSubview(self.contentView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let `contentView` = self.contentView else {
            return
        }
        let inFrame = UIEdgeInsetsInsetRect(self.bounds, PTAlertInsets)
        let alertSize = contentView.sizeThatFits(inFrame.size)
        contentView.size = alertSize
        contentView.center = inFrame.center
    }
    
    // MARK: - private
    @objc fileprivate func buttonTouched(sender: PTAlertButton) {
        guard let `action` = sender.item?.action else {
            self.dismiss()
            return
        }
        action(self)
        self.dismiss()
    }
    
    // MARK: - public
    func show() {
        self.show(withAnimate: false)
    }
    
    func show(withAnimate animate: Bool) {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)
        
        if let `button` = self.contentView?.cancelButton {
            button.addTarget(self, action: #selector(PTAlertView.buttonTouched(sender:)), for: .touchUpInside)
        }
        if let `button` = self.contentView?.sureButton {
            button.addTarget(self, action: #selector(PTAlertView.buttonTouched(sender:)), for: .touchUpInside)
        }
        
        self.contentView?.backgroundColor = .white
        self.contentView?.layer.cornerRadius = 5.0
        
        if !animate {
            return
        }
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        UIView.animate(withDuration: alertAnimateDuration) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        self.contentView?.alertPopup(alertAnimateDuration)
        
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    func dismiss(withButtonIndex index: Int) {
        self.removeFromSuperview()
    }
    
}
