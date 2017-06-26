//
//  PTConstants.swift
//  PTPark
//
//  Created by Chunlin on 2017/5/1.
//
//

import Foundation
import UIKit

func printLog<T>(_ message: T,
              file: String = #file,
              line: Int = #line,
              method: String = #function) {
    #if DEBUG
        print("[\((file as NSString).lastPathComponent)[\(line)], \(method)]: \(message)\n")
    #endif
}

func ptLoginSign(appid: String, clientType: String, deviceID: String, deviceName: String, mobile: String, password: String, platformID: String, version: String, secretKey: String) -> String {
    var array = Array<String>()
    if appid.characters.count > 0 {
        array.append("appid=\(appid)")
    }
    if clientType.characters.count > 0 {
        array.append("client_type=\(clientType)")
    }
    if deviceID.characters.count > 0 {
        array.append("device_id=\(deviceID)")
    }
    if deviceName.characters.count > 0 {
        array.append("device_name=\(deviceName)")
    }
    if mobile.characters.count > 0 {
        array.append("mobile=\(mobile)")
    }
    if password.characters.count > 0 {
        array.append("passwd=\(password)")
    }
    if platformID.characters.count > 0 {
        array.append("platform_id=\(platformID)")
    }
    if version.characters.count > 0 {
        array.append("version=\(version)")
    }
    
    var sign = array.joined(separator: "&")
    if secretKey.characters.count > 0 {
        sign = sign.appending(secretKey)
    }

    let cs = CharacterSet(charactersIn: "`#%^{}\"[]|\\<>//")
    sign = sign.addingPercentEncoding(withAllowedCharacters: cs)!
    sign = sign.removingPercentEncoding!
    sign = sign.md5()
    
    return sign.lowercased()
}

let PTTableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Screenwidth, height: 1))

//MARK: - 通知
let kLoginSeccussNotification = "kLoginSeccussNotification"
let kLogoutSeccussNotification = "kLoginSeccussNotification"

// 评价更新
let kUpdateCommentNotification = "kUpdateCommentNotification"

let kDelayTime: TimeInterval = 1
let PTProductName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String

//MARK: - 枚举值
/** 登录注册View类型 */
enum PTLoginUIType {
    case leftSMSVerification
    case login
    case rightSMSVerification
    
    var intValue: Int {
        switch self {
        case .leftSMSVerification:
            return 0
        case .login:
            return 1
        case .rightSMSVerification:
            return 2
        }
    }
}

/** 登录源类型, 从哪个地方点击触发的 */
enum PTLoginSourceType {
    case login
    case signIn
    case showQR
    case tapAvatar
    case address
    case coupon
    case member
    case score
    case setting
    case pay
    case post
    case receive
    case evaluate
    case all
    case comment
    case booking
    
    var intValue: Int {
        switch self {
        case .login:
            return 0
        case .signIn:
            return 1
        case .showQR:
            return 2
        case .tapAvatar:
            return 3
        case .address:
            return 4
        case .coupon:
            return 5
        case .member:
            return 4
        case .score:
            return 5
        case .setting:
            return 6
        case .pay:
            return 1001
        case .post:
            return 1002
        case .receive:
            return 1003
        case .evaluate:
            return 1004
        case .all:
            return 1005
        case .comment:
            return 1006
        case .booking:
            return 1007
        }
        
    }
}

/** cell箭头的方向 */
enum PTCellArrowType {
    case right
    case down
    
    var intValue: Int {
        switch self {
        case .right:
            return 0
        case .down:
            return 1
        }
    }
}

enum PTRelationType {
    case father
    case mother
    case grandpa
    case grandma
    case grandfather
    case grandmother
    case other
    
    var intValue: Int {
        switch self {
        case .father:
            return 1
        case .mother:
            return 2
        case .grandpa:
            return 3
        case .grandma:
            return 4
        case .grandfather:
            return 5
        case .grandmother:
            return 6
        case .other:
            return 7
        }
    }
    
    var stringValue: String {
        switch self {
        case .father:
            return "爸爸"
        case .mother:
            return "妈妈"
        case .grandpa:
            return "爷爷"
        case .grandma:
            return "奶奶"
        case .grandfather:
            return "外公"
        case .grandmother:
            return "外婆"
        case .other:
            return "其他"
        }
    }
}

enum PTGenderType {
    case female
    case male
    
    var intValue: Int {
        switch self {
        case .female:
            return 0
        case .male:
            return 1
        }
    }
    
    var stringValue: String {
        switch self {
        case .female:
            return "女"
        case .male:
            return "男"
        }
    }
}

enum PTMemberLevelType {
    case common
    case brass
    case silver
    case gold
    case diamond
    
    var intValue: Int {
        switch self {
        case .common:
            return 1
        case .brass:
            return 2
        case .silver:
            return 3
        case .gold:
            return 4
        case .diamond:
            return 5
        }
    }
    
    var stringValue: String {
        switch self {
        case .common:
            return "普通会员"
        case .brass:
            return "黄铜会员"
        case .silver:
            return "白银会员"
        case .gold:
            return "黄金会员"
        case .diamond:
            return "钻石会员"
        }
    }
}

enum PTTapStoreEventType {
    case map
    case contact
    case book
    case pic
    case cancel
}

//0未确认进行中，1完成体验，2确认缺席，3用户取消，
enum PTBookingStatus {
    case proceed
    case finished
    case absent
    case cacel
    
    var intValue: Int {
        switch self {
        case .proceed:
            return 0
        case .finished:
            return 1
        case .absent:
            return 2
        case .cacel:
            return 3
        }
    }
    
    var stringValue: String {
        switch self {
        case .proceed:
            return "进行中"
        case .finished:
            return "已完成"
        case .absent:
            return "未出席"
        case .cacel:
            return "已取消"
        }
    }
}

enum PTArticleListType {
    //自主学习列表
    case articleList
    //标签文章列表
    case tagArticle
    //产品攻略---模块跳转文章列表
    case raidersBlock
    
    var intValue: Int {
        switch self {
        case .articleList:
            return 0
        case .tagArticle:
            return 1
        case .raidersBlock:
            return 2
        }
    }
}
