//
//  AppDelegate+Push.swift
//  PTPark
//
//  Created by soso on 2017/5/22.
//
//

import UIKit
import UserNotifications
import GPushiOS

extension Data {
    var hexString: String {
        return withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
}

extension AppDelegate {
    
    func PTApp(_ app: UIApplication, didLaunchOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (result, error) in
                if result {
                    app.registerForRemoteNotifications()
                }
            })
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            app.registerUserNotificationSettings(settings)
            app.registerForRemoteNotifications()
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        GPush.register(forRemoteNotificationConfig: GPushEntity(), delegate: self)
        GPush.setup(with: PTConfig.GPush.type, appids: [PTConfig.GPush.AppID], userID: PTUserManager.share.getUID())
        
    }
    
    func PTApp(_ app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if deviceToken.count == 0 {
            return
        }
        let str = deviceToken.hexString
        print(str)
        GPush.registerDeviceToken(str)
    }
    
    func PTApp(_ app: UIApplication, didReceive userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let json = userInfo as? [String : Any] else {
            return
        }
        let item = PTMessageItem(map: Map(mappingType: MappingType.fromJSON, JSON: json))
        PTMessageManager.manager.didReceive(item, false)
    }
    
    func PTApp(_ app: UIApplication, didReceive notification: UILocalNotification) {
        print("###### didReceive notification")
    }
    
}

extension AppDelegate: GPushDelegate {
    
    func gpush(_ push: GPush!, didReceivedMessage message: [AnyHashable : Any]!) {
        guard let json = message as? [String : Any] else {
            return
        }
        let item = PTMessageItem(map: Map(mappingType: MappingType.fromJSON, JSON: json))
        PTMessageManager.manager.didReceive(item, false)
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //非点击通知不处理
        if response.actionIdentifier != UNNotificationDefaultActionIdentifier {
            return
        }
        //用户点击通知
        guard let json = response.notification.request.content.userInfo as? [String : Any] else {
            return
        }
        var messageItem = PTMessageItem()
        messageItem.ios_payload = PTPayloadItem(map: Map(mappingType: MappingType.fromJSON, JSON: json))
        PTMessageManager.manager.didReceive(messageItem, true)
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}




import ObjectMapper

struct PTAPSItem: Mappable {
    
    var alert: String = ""
    var sound: String = ""
    var badge: Int = 0
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        alert <- map["alert"]
        sound <- map["sound"]
        badge <- map["badge"]
    }
    
}

struct PTMessageExtraItem: Mappable {
    
    var id: Int = 0
    var location_type: String = ""
    var location_action: String = ""
    var custom_field: Any?
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        location_type <- map["location_type"]
        location_action <- map["location_action"]
        custom_field <- map["custom_field"]
    }
    
    var realmItem: PTMessageRealmItem {
        get {
            let messageItem = PTMessageRealmItem()
            messageItem.message_id = self.id
            return messageItem
        }
    }
    
}

struct PTPayloadItem: Mappable {
    
    var aps = PTAPSItem()
    var extras = PTMessageExtraItem()
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        aps <- map["aps"]
        extras <- map["extras"]
    }
    
}

struct PTInsidePayloadItem: Mappable {
    
    var red_dot: String = ""
    var message_center_id: Int = 0
    var extras = PTMessageExtraItem()
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        message_center_id <- map["message_center_id"]
        red_dot <- map["red_dot"]
        extras <- map["extras"]
        extras.id = message_center_id
    }
    
    var realmItem: PTMessageRealmItem {
        get {
            let messageItem = PTMessageRealmItem()
            messageItem.message_id = self.message_center_id
            return messageItem
        }
    }
    
}

enum PTUserLogoutType: Int {
    case timeout
    case loginOtherDevice
}

struct PTSingleSignItem: Mappable {
    
    var sign_device_id: String? = ""
    var sign_uid: String? = ""
    var msg: String? = ""
    
    var logout_type: PTUserLogoutType?
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        sign_device_id <- map["sign_device_id"]
        sign_uid <- map["sign_uid"]
        msg <- map["msg"]
        logout_type <- map["logout_type"]
        
        if let uid_int = map.JSON["sign_uid"] as? Int {
            sign_uid = "\(uid_int)"
        }
    }
    
}

struct PTMessageItem: Mappable {
    
    var ios_payload: PTPayloadItem?
    var inside_payload: PTInsidePayloadItem?
    var single_sign: PTSingleSignItem?
    
    init() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        ios_payload <- map["ios_payload"]
        inside_payload <- map["inside_payload"]
        single_sign <- map["single_sign"]
    }
    
}

