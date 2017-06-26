//
//  PTBaseViewController.swift
//  PTPark
//
//  Created by soso on 2017/4/11.
//
//

import UIKit
import PKHUD
import ObjectMapper

protocol PTKeyboardObserverSupport {
    func removeKeyboardObserver()
    func addKeyboardObserver()
    func keyboardWillShow(_ keyboardFrame: CGRect?)
    func keyboardWillHide(_ keyboardFrame: CGRect?)
    func keyboardWillChangeFrame(_ keyboardFrame: CGRect?)
}

protocol PTNetworkStatusSupport {
    func addNetworkStatusObserver()
    func removeNetworkStatusObserver()
    func networkStatus(_ status: PTReachableStatus)
}

protocol PTApplicationStateSupport {
    func applicationDidBecomeActive()
    func applicationDidEnterBackground()
}

protocol PTRouteSupport {
    var parameters: [String:Any]? { get set }
}

protocol PTSingleSignSupport {
    func singleSignIsNeedCheck() -> Bool
    func singleSignOberverAdd()
    func singleSignOberverRemove()
    func singleSignDidLogout(_ item: PTSingleSignItem)
    func singleSignDidLogin()
    func singleSignCancelLogin()
}


class PTBaseViewController: UIViewController, PTApplicationStateSupport, PTKeyboardObserverSupport, PTNetworkStatusSupport, PTRouteSupport, PTSingleSignSupport {
    
    var firstWillAppear: (() -> Void)?
    var notFirstWillAppear: (() -> Void)?
    
    var backgroundImageLayer: CALayer?
    
    var loadingView:UIActivityIndicatorView?
    
    override var shouldAutorotate: Bool {
        return presentedViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return presentedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return presentedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        
        backgroundImageLayer = UIImageView(image: UIImage(named: "app_bg_01")).layer
        self.view.layer.insertSublayer(backgroundImageLayer!, at: 0)
        
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView?.center = self.view.center
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "btn_24_back_b_nor")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "btn_24_back_w_nor")
    }
    
    fileprivate var viewFirstWillAppear = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MobClick.beginLogPageView(NSStringFromClass(self.classForCoder))
        
        if singleSignIsNeedCheck() {
            singleSignOberverAdd()
        }
        
        if viewFirstWillAppear {
            viewFirstWillAppear = false
            firstWillAppear?()
            return
        }
        notFirstWillAppear?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if singleSignIsNeedCheck() {
            singleSignOberverRemove()
        }
        
        MobClick.endLogPageView(NSStringFromClass(self.classForCoder))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageLayer?.frame = self.view.layer.bounds
    }
    
    func setTitle(text:String, font:UIFont? = nil){
        if let font = font{
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: text.width(withConstrainedWidth: Screenwidth, font: font), height: HEIGHT_NAV))
            titleLabel.text = text
            titleLabel.font = font
            titleLabel.textAlignment = .center
            self.navigationItem.titleView = titleLabel
        }else{
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: text.width(withConstrainedWidth: Screenwidth, font: UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)), height: HEIGHT_NAV))
            titleLabel.text = text
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
            titleLabel.textAlignment = .center
            self.navigationItem.titleView = titleLabel
        }
    }
    
    func startLoadAnimation(){
        self.view.addSubview(loadingView!)
        loadingView?.startAnimating()
    }
    
    func startLoadAnimation(style:UIActivityIndicatorViewStyle){
        loadingView?.activityIndicatorViewStyle = style
        startLoadAnimation()
    }
    
    func stopLoadAnimation(){
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
    }
    
    func keyboardWillShow(_ keyboardFrame: CGRect?) {
        
    }
    
    func keyboardWillHide(_ keyboardFrame: CGRect?) {
        
    }
    
    func keyboardWillChangeFrame(_ keyboardFrame: CGRect?) {
        
    }
    
    func networkStatus(_ status: PTReachableStatus) {
        
    }
    
    func applicationDidBecomeActive() {
        
    }
    
    func applicationDidEnterBackground() {
        
    }
    
    // MARK: PTRouteSupport
    var parameters: [String : Any]? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    // MARK: PTRefreashSupport
    func singleSignDidLogin() {
        // root do nothing
    }
    
    func singleSignCancelLogin() {
        // root do nothing
    }
    
    // MARK: PTSingleSignSupport
    @objc fileprivate func didReceivedSingleSignLogout(_ notification: Notification) {
        guard let json = notification.userInfo as? [String : Any] else {
            return
        }
        guard let item = PTSingleSignItem(map: Map(mappingType: MappingType.fromJSON, JSON: json)) else {
            return
        }
        singleSignDidLogout(item)
    }
    
    func singleSignIsNeedCheck() -> Bool {
        return false
    }
    
    func singleSignOberverAdd() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivedSingleSignLogout(_:)), name: NSNotification.Name.PTSingleSignDidLogout, object: nil)
    }
    
    func singleSignOberverRemove() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.PTSingleSignDidLogout, object: nil)
    }
    
    fileprivate var pre_uid: String = ""
    func singleSignDidLogout(_ item: PTSingleSignItem) {
        if !singleSignIsNeedCheck() {
            return
        }
        guard let sign_uid = item.sign_uid else {
            return
        }
        pre_uid = sign_uid
        showSingleSignLogoutAlert(item)
    }
    
    fileprivate var didShowSingleSignAlert = false
    fileprivate func showSingleSignLogoutAlert(_ item: PTSingleSignItem) {
        if didShowSingleSignAlert {
            return
        }
        didShowSingleSignAlert = true
        let message = item.msg ?? "账号已失效,请重新登录"
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "重新登录", style: UIAlertActionStyle.destructive, handler: { [weak self] (action) in
            self?.showSingleSignLoginMenu(item)
            self?.didShowSingleSignAlert = false
        }))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate var didShowSingleSignMenu = false
    fileprivate func showSingleSignLoginMenu(_ item: PTSingleSignItem) {
        if didShowSingleSignMenu {
            return
        }
        didShowSingleSignMenu = true
        let loginVC = PTLoginViewController.initWithClass(PTLoginViewController.self)
        loginVC.isHiddenCloseButton = true
        loginVC.willDismiss = { [weak self] _ in
            guard let `self` = self else { return }
            self.didShowSingleSignMenu = false
            self.singleSignCancelLogin()
        }
        loginVC.loginSuccess = { [weak self] _ in
            guard let `self` = self else { return }
            self.didShowSingleSignMenu = false
            DispatchQueue.main.async {
                let uid = PTUserManager.share.getUID()
                //登录是同一用户，直接刷新当前页面
                if uid == self.pre_uid {
                    if item.logout_type == .timeout {
                        self.singleSignDidLogin()
                    }
                    return
                }
                //登录的是不同的用户，重置
                if let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as? PTBaseTabBarController {
                    tabBarVC.reset()
                }
            }
        }
        let nav = PTBaseNavigationController(rootViewController: loginVC)
        self.present(nav, animated: true) {
            
        }
    }
    
}

extension PTBaseViewController {
    
    func removeKeyboardObserver() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    func addKeyboardObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ptKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ptKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ptKeyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc fileprivate func ptKeyboardWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        self.keyboardWillShow(userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect)
        
    }
    
    @objc fileprivate func ptKeyboardWillHide(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        self.keyboardWillHide(userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect)
        
    }
    
    @objc fileprivate func ptKeyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        self.keyboardWillChangeFrame(userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect)
    }
    
}

extension PTBaseViewController {
    
    func addAppObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func removeAppObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
}


enum PTReachableStatus: Int {
    case unknow         = 0
    case notReachable   = 1
    case cellular       = 2
    case wifi           = 3
}

fileprivate let reachability = Reachability()!
extension PTBaseViewController {
    
    func addNetworkStatusObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeNetworkStatusObserver() {
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    func reachabilityChanged(note: NSNotification) {
        guard let reachability = note.object as? Reachability else {
            self.mainNetworkStatus(.unknow)
            return
        }
        if !reachability.isReachable {
            self.mainNetworkStatus(.notReachable)
            return
        }
        if reachability.isReachableViaWiFi {
            self.mainNetworkStatus(.wifi)
        } else {
            self.mainNetworkStatus(.cellular)
        }
    }
    
    fileprivate func mainNetworkStatus(_ status: PTReachableStatus) {
        if Thread.isMainThread {
            self.networkStatus(status)
            return
        }
        DispatchQueue.main.async { [weak self] _ in
            self?.networkStatus(status)
        }
    }
    
}
