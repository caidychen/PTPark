//
//  PTPay.swift
//  PTPark
//
//  Created by soso on 2017/4/24.
//
//

import Foundation
import ObjectMapper
import PKHUD

struct PTAlipayPayItem: Mappable {
    var code: String = ""
    
    // MARK: Mappable
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
    }
}

struct PTWeChatPayItem: Mappable {
    
    var appid: String = ""
    var noncestr: String = ""
    var package: String = ""
    var partnerid: String = ""
    var prepayid: String = ""
    var timestamp: String = ""
    var sign: String = ""
    
    // MARK: Mappable
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        appid <- map["appid"]
        noncestr <- map["noncestr"]
        package <- map["package"]
        partnerid <- map["partnerid"]
        prepayid <- map["prepayid"]
        timestamp <- map["timestamp"]
        sign <- map["sign"]
    }
    
    func getReq() -> PayReq {
        let req = PayReq()
        req.openID = appid
        req.nonceStr        = noncestr
        req.package         = package
        req.partnerId       = partnerid
        req.prepayId        = prepayid
        req.sign            = sign
        req.timeStamp       = UInt32(timestamp) ?? arc4random()
        return req
    }
    
}

public enum PTAlipayResultCode: Int {
    case failure    = 4000
    case reuse      = 5000
    case cancel     = 6001
    case netError   = 6002
    case unknow     = 6004
    case pending    = 8000
    case success    = 9000
    public var description: String {
        get {
            switch self {
            case .failure:  return "订单支付失败"
            case .reuse:    return "重复请求"
            case .cancel:   return "用户中途取消"
            case .netError: return "网络连接出错"
            case .unknow:   return "请查询商户订单列表中订单的支付状态"
            case .pending:  return "正在处理中,请查询商户订单列表中订单的支付状态"
            case .success:  return "订单支付成功"
            }
        }
    }
}

public enum PTPayType {
    
    case alipay
    case wechat
    
    func ment() -> String {
        switch self {
        case .alipay: return "ALI_APP"
        case .wechat: return "WX_APP"
        }
    }
    
}

extension Notification.Name {
    struct PTPay {
        static let alipayPaySuccess = Notification.Name(rawValue: "alipayPaySuccess")
        static let wechatPaySuccess = Notification.Name(rawValue: "wechatPaySuccess")
    }
}

enum PTPayResult {
    case error(String?)     //错误
    case failure(String?)   //失败
    case success(String?)   //成功
}

typealias PTPayCallback = ((PTPayResult) -> ())

public class PTPay: NSObject, WXApiDelegate {
    
    static let shared = PTPay()
    
    fileprivate var payResultCallback: PTPayCallback?
    
    func doAlipay(_ item: PTAlipayPayItem, _ callback: PTPayCallback?) {
        self.payResultCallback = callback
        AlipaySDK.defaultService().payOrder(item.code, fromScheme: PTConfig.Schemes.alipay) { (result) in
            defer {
                self.payResultCallback = nil
            }
            guard let status = result?["resultStatus"] as? String else {
                self.payResultCallback?(PTPayResult.failure("支付发生未知错误"))
                return
            }
            let code = PTAlipayResultCode(rawValue: (Int(status) ?? 0))
            if code == PTAlipayResultCode.success {
                self.payResultCallback?(PTPayResult.success(code?.description))
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name.PTPay.alipayPaySuccess, object: nil, userInfo: result)
                }
                return
            }
            self.payResultCallback?(PTPayResult.failure(code?.description))
        }
    }
    
    func doWeChatPay(_ item: PTWeChatPayItem, _ callback: PTPayCallback?) {
        if !WXApi.isWXAppInstalled() {
            callback?(PTPayResult.error("您未安装微信"))
            return
        }
        if !WXApi.isWXAppSupport() {
            callback?(PTPayResult.error("您的微信不支持这笔订单的支付"))
            return
        }
        payResultCallback = callback
        WXApi.send(item.getReq())
    }
    
    // MARK: Handle AppDelegate
    public func application(didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        //Alipay
        
        //WeChat
        WXApi.registerApp(PTConfig.WeChat.AppID)
    }
    
    public func applicaiton(open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //跳转支付宝钱包进行支付，处理支付结果
        if (url.host == "safepay") {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (dict) in
                guard let memo = dict?["memo"] as? String else {
                    return
                }
                HUD.flash(.label(memo), delay: PTConfig.PTHUD.delay)
                
                defer {
                    self.payResultCallback = nil
                }
                guard let status = dict?["resultStatus"] as? String else {
                    self.payResultCallback?(PTPayResult.failure("支付发生未知错误"))
                    return
                }
                let code = PTAlipayResultCode(rawValue: (Int(status) ?? 0))
                if code == PTAlipayResultCode.success {
                    self.payResultCallback?(PTPayResult.success(code?.description))
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name.PTPay.alipayPaySuccess, object: nil, userInfo: dict)
                    }
                    return
                }
                self.payResultCallback?(PTPayResult.failure(code?.description))
            })
            return true
        }
        if (url.host == "platformapi") {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (dict) in
                guard let memo = dict?["memo"] as? String else {
                    return
                }
                HUD.flash(.label(memo), delay: PTConfig.PTHUD.delay)
            })
            return true
        }
        
        //微信支付
        if (url.host == "pay") {
            return WXApi.handleOpen(url, delegate: PTPay.shared)
        }
        return true
    }
    
    // MARK: WXApiDelegate
    public func onReq(_ req: BaseReq!) {
        
    }
    
    public func onResp(_ resp: BaseResp!) {
        guard let payRsp = resp as! PayResp? else {
            return
        }
        defer {
            self.payResultCallback = nil
        }
        if payRsp.errCode == 0 {
            payResultCallback?(PTPayResult.success("支付成功"))
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.PTPay.wechatPaySuccess, object: nil, userInfo: nil)
            }
            return
        }
        payResultCallback?(PTPayResult.failure(payRsp.errStr ?? "支付失败"))
    }
    
}
