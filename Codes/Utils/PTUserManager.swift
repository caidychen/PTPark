//
//  PTUserManager.swift
//  PTPark
//
//  Created by Chunlin on 2017/5/5.
//
//

import Foundation
import ObjectMapper

class PTUserManager: NSObject {
    static let share = PTUserManager()
    
    var userInfo: PTUserInfoModel? {
        didSet{
            if let _userInfo = userInfo {
                // 保存用户信息
                _uid = "\(_userInfo.uid ?? 0)"
                _token = _userInfo.token ?? ""
                let dict = ["uid":_uid, "token":_token] as [String : Any]
                saveUserInfoToDisk(dict as NSDictionary)
                _isLogin = true
            } else {
                _isLogin = false
                clearUserInfo()
            }
        }
    }
    
    var memberInfo: PTMemberInfoModel?
    
    fileprivate var deviceID:String!  //当前设备唯一的 UUID
    fileprivate lazy var _isLogin = false
    
    fileprivate var _token: String = ""
    fileprivate var _uid: String = ""
    
    override init() {
        super.init()
        
        initUserInfoFromDisk()
    }
    
    func initDrviceUUIDFromDisk() {
        let filePath = getDrviceUUIDSaveDocumentsPath()
        let diskDrviceUUID = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
        if diskDrviceUUID == nil {
            let uuid = UIDevice.current.identifierForVendor?.uuidString
            if NSKeyedArchiver.archiveRootObject(uuid!, toFile: filePath) {
                deviceID = uuid!
                printLog("deviceID 初始化成功: \(deviceID)")
            } else {
                printLog("deviceID 初始化失败")
            }
        } else {
            deviceID = diskDrviceUUID as! String
        }
    }
    
    func getDocumentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }
    
    func getDrviceUUIDSaveDocumentsPath() -> String {
        return getDocumentDirectory().stringByAppendingPathComponent("drviceUUID.data")
    }
    
    func getDeviceID() -> String {
        return deviceID
    }
    
    func getDeviceName() -> String {
        return UIDevice.current.model
    }
    
    func isLogin() ->Bool {
        return _isLogin
    }
    
    func initUserInfoFromDisk() {
        let filePath = getUserInfoSaveDocumentsPath()
        if FileManager.default.fileExists(atPath: filePath) {
            let dict = NSDictionary(contentsOfFile: filePath)
            if let uid = dict?.object(forKey: "uid") as? String {
                _uid = uid
            } else if let uid = dict?.object(forKey: "uid") as? NSNumber {
                _uid = "\(uid)"
            }
            
            if let token = dict?.object(forKey: "token") as? String {
                _token = token
                _isLogin = true
            }
        }
    }
    
    func getUserInfoSaveDocumentsPath() -> String {
        return getDocumentDirectory().stringByAppendingPathComponent("userInfo.plist")
    }
    
    func saveUserInfoToDisk(_ dict: NSDictionary) {
        let filePath = getUserInfoSaveDocumentsPath()
        let result = dict.write(toFile: filePath, atomically: true)
        if result {
            printLog("保存token成功")
        } else {
            printLog("保存token失败")
        }
    }
    
    func clearUserInfo() {
        let filePath = getUserInfoSaveDocumentsPath()
        if FileManager.default.fileExists(atPath: filePath) {
            try! FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    func getToken() -> String {
        return _token
    }
    
    func getUID() -> String {
        return _uid
    }
}


extension Notification.Name {
    static let PTSingleSignDidLogout = Notification.Name("PTSingleSignDidLogout")
}

// MARK: 单点登录逻辑处理
extension PTUserManager {
    
    func checkResponseData(_ data: Data?) {
        guard let `data` = data else {
            return
        }
        var json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        } catch {
            return
        }
        guard let itemJson = json as? [String:Any] else {
            return
        }
        guard let item = PTHTTPBaseItem<PTHTTPEmptyData>(map: Map(mappingType: MappingType.fromJSON, JSON: itemJson)) else {
            return
        }
        guard let code = item.code else {
            return
        }
        guard let ptcode = PTResponseHTTPCode(rawValue: code) else {
            return
        }
        switch ptcode {
        case .tokenTimeout:
            var signItem = PTSingleSignItem()
            signItem.msg = item.message
            signItem.logout_type = .timeout
            didReceiveSingleSign(signItem)
            break
        case .loginOtherDevice:
            var signItem = PTSingleSignItem()
            signItem.msg = item.message
            signItem.logout_type = .loginOtherDevice
            didReceiveSingleSign(signItem)
            break
        default: break
        }
    }
    
    func didReceiveSingleSign(_ item: PTSingleSignItem) {
        DispatchQueue.main.async { [weak self] _ in
            //无记录的用户信息，不做处理
            if self?._uid.length == 0 || self?._token.length == 0 {
                return
            }
            //本机登录，不做处理
            if self?.deviceID == item.sign_device_id {
                return
            }
            
            //清除token
            self?._token = ""
//            self?._uid = ""
            self?.userInfo = nil
            
            NotificationCenter.default.post(name: NSNotification.Name.PTSingleSignDidLogout, object: nil, userInfo: item.toJSON())
        }
    }
}
