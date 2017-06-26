//
//  PTHTTPBaseItem.swift
//  PTPark
//
//  Created by soso on 2017/5/10.
//
//

import Foundation
import ObjectMapper

struct PTHTTPEmptyData: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}

struct PTHTTPBaseItem<DataType: Mappable>: Mappable {
    
    var code: Int?
    var message: String?
    var data: DataType?
    
    fileprivate var http_code: Int?
    fileprivate var msg: String?
    
    // MARK: Mappable
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
        
        http_code <- map["http_code"]
        if let _ = http_code {
            code = http_code
        }
        msg <- map["msg"]
        if let _ = msg {
            message = msg
        }
    }
    
}

extension PTHTTPBaseItem {
    func isSuccess() -> Bool {
        guard let c = code else {
            return false
        }
        return c == PTResponseHTTPCode.success.rawValue
    }
}

struct PTHTTPBaseItems<DataType: Mappable>: Mappable {
    
    var code: Int?
    var message: String?
    var data: [DataType]?
    
    fileprivate var http_code: Int?
    fileprivate var msg: String?
    
    // MARK: Mappable
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
        
        http_code <- map["http_code"]
        if let _ = http_code {
            code = http_code
        }
        msg <- map["msg"]
        if let _ = msg {
            message = msg
        }
    }
    
}

extension PTHTTPBaseItems {
    func isSuccess() -> Bool {
        guard let c = code else {
            return false
        }
        return c == PTResponseHTTPCode.success.rawValue
    }
}
