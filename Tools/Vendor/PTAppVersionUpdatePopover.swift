//
//  PTAppUpdatePopover.swift
//  PTPark
//
//  Created by CHEN KAIDI on 31/5/2017.
//
//

import UIKit

typealias PTAppVersionUpdateCompletionBlock = () -> ()

class PTAppVersionUpdatePopover: UIView {

    fileprivate var _bgView:UIView?
    fileprivate var _closeButton:UIButton?
    fileprivate var _mainView:UIView?
    fileprivate var _leftCornerIcon:UIImageView?
    fileprivate var _textLabel:UILabel?
    fileprivate var _confirmButton:UIButton?
    fileprivate var appStoreURL:String?
    
    fileprivate var completionBlock:PTAppVersionUpdateCompletionBlock?
    
    class func check(completion:@escaping PTAppVersionUpdateCompletionBlock){
        PTBaseService.sharedInstance.getAppVersion { (result, success, reponseCode) in
            if let url = result?["url"] as? String, let newVersion = result?["versions"] as? String{
                if let text = AppVersion() {
                    if newVersion != text {
                        // Found new version number, Update available
                        let updatePopover = PTAppVersionUpdatePopover(frame: UIScreen.main.bounds)
                        UIApplication.shared.keyWindow?.addSubview(updatePopover)
                        
                        updatePopover.completionBlock = completion
                        updatePopover.appStoreURL = url
                        updatePopover.alpha = 0.0
                        UIView.animate(withDuration: 0.35, animations: { 
                            updatePopover.alpha = 1.0
                        })
                    }else{
                        // No new version, skipping...
                        completion()
                    }
                }
            }else{
                completion()
            }
        }
    }
    
    override init (frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(bgView)
        bgView.addSubview(closeButton)
        self.addSubview(mainView)
        mainView.addSubview(leftCornerIcon)
        mainView.addSubview(textLabel)
        mainView.addSubview(confirmButton)
        self.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bgView.center = CGPoint(x: self.width/2 - 7.5, y: self.height/2)
        self.mainView.center = CGPoint(x: self.width/2 + 7.5, y: self.height/2 - 15 - closeButton.height/2)
        self.textLabel.frame = CGRect(x: 0, y: mainView.height/2 - textLabel.font.lineHeight*2, width: mainView.width - 15, height: textLabel.font.lineHeight*2)
        self.confirmButton.frame = CGRect(x: 15, y: textLabel.bottom + 20, width: confirmButton.width, height: confirmButton.height)
        
    }
    
    @objc func dismissMe(){
        if let a = completionBlock {
            a()
        }
        UIView.animate(withDuration: 0.35, animations: { 
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
        
    }
    
    @objc func gotoAppStore(){
        guard let appStoreURL = self.appStoreURL else {return}
        if let url = URL(string:appStoreURL){
             UIApplication.shared.openURL(url)
        }
       
    }
    
    fileprivate var bgView:UIView{
        if _bgView == nil {
            _bgView = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 180 - 15 + 44))
            _bgView?.backgroundColor = UIColor.colorWithHexSwift(0x52485c)
            _bgView?.applySimpleShadow()
        }
        return _bgView!
    }

    fileprivate var closeButton:UIButton{
        if _closeButton == nil {
            _closeButton = UIButton(frame: CGRect(x: 0, y: self.bgView.height - 44, width: 280, height: 44))
            _closeButton?.setTitle("退出", for: .normal)
            _closeButton?.setTitleColor(.white, for: .normal)
            _closeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            _closeButton?.addTarget(self, action: #selector(dismissMe), for: .touchUpInside)
        }
        return _closeButton!
    }
    
    fileprivate var mainView:UIView{
        if _mainView == nil {
            _mainView = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 180))
            _mainView?.backgroundColor = .white
            _mainView?.applySimpleShadow()
        }
        return _mainView!
    }
    
    fileprivate var leftCornerIcon:UIImageView{
        if _leftCornerIcon == nil {
            _leftCornerIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 80))
            _leftCornerIcon?.image = UIImage(named: "img_modal_update_pic")
        }
        return _leftCornerIcon!
    }
    
    fileprivate var textLabel:UILabel{
        if _textLabel == nil {
            _textLabel = UILabel()
            _textLabel?.textAlignment = .right
            _textLabel?.numberOfLines = 2
            _textLabel?.textColor = .theme
            _textLabel?.text = "火速前往升级版本\n让孩子享受科学的乐趣"
        }
        return _textLabel!
    }
    
    fileprivate var confirmButton:UIButton{
        if _confirmButton == nil {
            _confirmButton = UIButton(frame: CGRect(x: 0, y: 0, width: mainView.width - 30, height: 44))
            _confirmButton?.setTitle("马上升级", for: .normal)
            _confirmButton?.setTitleColor(.white, for: .normal)
            _confirmButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            _confirmButton?.backgroundColor = .theme
            _confirmButton?.addTarget(self, action: #selector(gotoAppStore), for: .touchUpInside)
        }
        return _confirmButton!
    }
}
