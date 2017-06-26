//
//  PTBaseService.swift
//  PTPark
//
//  Created by CHEN KAIDI on 2017/4/11.
//
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import CFNetwork

public func PTParametersPacket(_ parameters: [String:Any]?) -> [String:Any] {
    var merge = [String:Any]()

    if let param = parameters {
        for (key, value) in param {
            merge[key] = value
        }
    }
    return merge
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
    
}
