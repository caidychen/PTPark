//
//  StringExtension.swift
//  PTLatitude
//
//  Created by admin on 16/4/29.
//  Copyright © 2016年 PT. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    func md5() ->String!{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
    
    var length: Int {
        return self.characters.count // Swift 1.1
    }
    
    func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func removeAllSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeSpaceAndLine() -> String {
        //Remove both whitespace and line character in front and rear
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var removeNewLineString: String {
        var newStr: String
        newStr = self.replacingOccurrences(of: "\r", with: "")
        newStr = newStr.replacingOccurrences(of: "\n", with: "")
        return newStr
    }
    
    var trimmingString: String {
        var newStr: String
        //Remove both whitespace and line character in front and rear
        newStr = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //Remove the other position of the blank character and the newline character
        newStr = newStr.replacingOccurrences(of: "\r", with: "")
        newStr = newStr.replacingOccurrences(of: "\n", with: "")
        return newStr
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func insert(_ string:String,atIndex:Int) -> String {
        return  String(self.characters.prefix(atIndex)) + string + String(self.characters.suffix(self.characters.count-atIndex))
    }
    
    func addingPercentEncoding() -> String? {
        let encodingString = addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "\"\'[]:/?&=;+!@#$()',*{}\\<>%^`").inverted)
        return encodingString
    }
    
    var queryDictionary: [String: String] {
        var tmp = [String: String]()
        guard let urlString = addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return [:]
        }
        let url = URL(string: urlString)
        let query = url?.query
        
        let components = query?.components(separatedBy: "&")
        guard let c = components else {
            return tmp
        }
        
        for keyValue in c {
            let subComponent = keyValue.components(separatedBy: "=")
            let key = subComponent.first?.removingPercentEncoding
            let value = subComponent.last?.removingPercentEncoding
            if let k = key, let v = value {
                tmp[k] = v
            }
        }
        return tmp
    }
    
    func removeNonBmpUnicode() -> String? {
        return replacingOccurrences(of: "^[\u{00000}-\u{FFFFF}]", with: "")
    }
    
    func avatarSplit120() -> String {
        return replacingOccurrences(of: ".jpg", with: "_120x120.jpg")
    }
}

enum HMACAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:
            result = kCCHmacAlgMD5
        case .sha1:
            result = kCCHmacAlgSHA1
        case .sha224:
            result = kCCHmacAlgSHA224
        case .sha256:
            result = kCCHmacAlgSHA256
        case .sha384:
            result = kCCHmacAlgSHA384
        case .sha512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .md5:
            result = CC_MD5_DIGEST_LENGTH
        case .sha1:
            result = CC_SHA1_DIGEST_LENGTH
        case .sha224:
            result = CC_SHA224_DIGEST_LENGTH
        case .sha256:
            result = CC_SHA256_DIGEST_LENGTH
        case .sha384:
            result = CC_SHA384_DIGEST_LENGTH
        case .sha512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func hmac(_ algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData:Data = Data(bytes: UnsafePointer<UInt8>(result), count: (Int(algorithm.digestLength())))
        let hmacBase64 = hmacData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength76Characters)
        let real = hmacBase64.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_")
        return real
    }
}
