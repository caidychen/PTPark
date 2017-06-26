//
//  PTBaseModel.swift
//  PTPark
//
//  Created by soso on 2017/4/11.
//
//

import Foundation
import ObjectMapper

class PTBaseModel: Mappable {
    
    var http_code: Int?
    var message = ""
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        http_code   <- map["code"]
        message <- map["message"]
        
        if message.length == 0 {
            message <- map["msg"]
        }
        
    }
}
