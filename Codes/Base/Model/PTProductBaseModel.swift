//
//  PTProductBaseModel.swift
//  PTPark
//
//  Created by CHEN KAIDI on 3/5/2017.
//
//

import Foundation
import ObjectMapper

class PTProductBaseModel: Mappable {
    required init?(map: Map){
        
    }
    var http_code: Int?
    
    func mapping(map: Map) {
        http_code   <- map["http_code"]
    }
}

