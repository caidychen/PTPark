//
//  PTBaseService.swift
//  PTPark
//
//  Created by soso on 2017/4/11.
//
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import CFNetwork

enum PTResponseHTTPCode: Int {
    case success            = 200   //成功
    case tokenTimeout       = 602   //登录失效(token过期)
    case loginOtherDevice   = 604   //账号在其他设备登录
}

public func PTParametersPacket(_ parameters: [String:Any]?) -> [String:Any] {
    var merge = [String:Any]()
    merge["appid"]      = PTConfig.AppID        //appid，与uid对应校验
    merge["device_id"]  = PTUserManager.share.getDeviceID()         //设备ID，该参数与data同级
    merge["uid"]        = PTUserManager.share.getUID()              //家长ID
    merge["token"]      = PTUserManager.share.getToken()            //家长Token
    if let param = parameters {
        for (key, value) in param {
            merge[key] = value
        }
    }
    return merge
}

enum PTBaseResult<ST, FT> {
    case success(ST)
    case failure(FT)
}

protocol PTBaseServiceType {
    
    var parameters: [String:Any] { get set }
    
    func cancel()
    
}

class PTBaseService : NSObject, PTBaseServiceType {
    
    static let sharedInstance = PTBaseService()
    var parameters = [String:Any]()
    
    class func request(_ url: String, method: HTTPMethod, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completionHandler: @escaping (URLRequest?, DefaultDataResponse?, Data?, Error?) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.session.configuration.timeoutIntervalForResource = 10
        
        if let headers = headers {
            var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            defaultHeaders.append(headers)
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = defaultHeaders
        }
        // 获得参数字典
        // 打印请求地址
        print("========================================================================")
        print("\(url)")
        if let parameters = parameters {
            for (key, value) in parameters {
                print("\(key)\t: \(value)")
            }
        }
        print("========================================================================")
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).response { (response) in
            PTUserManager.share.checkResponseData(response.data)
            guard let data = response.data else {
                completionHandler(response.request, response, nil, response.error)
                return
            }
            do {
                guard (try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]) != nil else {
                    completionHandler(response.request, response, nil, response.error)
                    return
                }
                completionHandler(response.request, response, response.data, response.error)
            }catch {
                completionHandler(response.request, response, nil, response.error)
            }
        }
    }
    
    func cancel() {
        
    }
    
    class func request2<T:Mappable>(_ url: String, method: HTTPMethod = HTTPMethod.get, parameters: [String: Any]? = nil, model: T.Type, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.session.configuration.timeoutIntervalForResource = 10
        
        if let headers = headers {
            var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            defaultHeaders.append(headers)
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = defaultHeaders
        }
        // 获得参数字典
        // 打印请求地址
        
        print("========================================================================")
        print("\(url)")
        if let parameters = parameters {
            for (key, value) in parameters {
                print("\(key)\t: \(value)")
            }
        }
        print("========================================================================")
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseObject {(response: DataResponse<T>) in
            PTUserManager.share.checkResponseData(response.data)
            completionHandler(response)
        }
    }
}
