//
//  DictionaryExtension.swift
//  PTLatitude
//
//  Created by 王炜程 on 2016/12/29.
//  Copyright © 2016年 Shanghai Putao Technology Co., Ltd. . All rights reserved.
//

import Foundation

extension Dictionary {
    
    mutating func append(_ dictionary: [Key: Value?]?) {
        guard let dictionary = dictionary else {
            return
        }
        for (key, value) in dictionary {
            if let value = value {
                updateValue(value, forKey: key)
            }
        }
    }
    
    func makeSign(with secret: String) -> String {
        
        let sorted = keys.sorted { (aKey, bKey) -> Bool in
            
            return false
        }
        var str_param = ""
        
        for key in sorted {
            if let value = self[key] as? String {
                
                if str_param.characters.count > 0 {
                    str_param += "&"
                }
                
                str_param += key as! String
                str_param += "="
                str_param += value.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: ":/?&=;+!@#$()',*[.]#<>%{|}\"\\^`{|}").inverted)!
            }
        }
        
        str_param += secret
        
        return str_param.md5().lowercased()
        
        
    }
}
